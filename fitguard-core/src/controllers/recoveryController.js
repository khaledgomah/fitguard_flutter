const RecoveryProtocol = require('../models/RecoveryProtocol');
const InjuryLog = require('../models/InjuryLog');
const Notification = require('../models/Notification');
const aiService = require('../services/aiService');
const { getInjuryAIContext } = require('../utils/injuryPatterns');
const APIFeatures = require('../utils/apiFeatures');

exports.generateProtocol = async (req, res, next) => {
  try {
    const { injuryLogId } = req.body;
    const user = req.user;

    const injuryLog = await InjuryLog.findOne({ _id: injuryLogId, userId: user._id });
    if (!injuryLog) {
      return res.status(404).json({
        success: false,
        data: null,
        message: 'Injury log not found'
      });
    }

    if (injuryLog.recoveryStatus === 'recovered') {
      return res.status(400).json({
        success: false,
        data: null,
        message: 'Cannot generate a recovery protocol for an already recovered injury'
      });
    }

    const injuryLogs = await InjuryLog.find({ userId: user._id });
    const aiContext = getInjuryAIContext(user, 'intermediate', injuryLogs);

    const aiResult = await aiService.generateRecoveryProtocol(injuryLog, aiContext);

    if (!aiResult || !Array.isArray(aiResult.phases)) {
      return res.status(502).json({
        success: false,
        data: null,
        message: 'Invalid protocol format returned by the AI service.'
      });
    }

    await RecoveryProtocol.updateMany(
      { userId: user._id, injuryLogId, status: 'active' },
      { $set: { status: 'completed' } }
    );

    const phases = aiResult.phases.map(p => ({
      phaseNumber: p.phaseNumber,
      name: p.name,
      durationDays: p.durationDays,
      exercises: p.exercises || [],
      completed: false
    }));

    const startDate = new Date();
    const totalDays = phases.reduce((sum, p) => sum + (p.durationDays || 0), 0);
    const endDate = new Date(startDate.getTime() + totalDays * 24 * 60 * 60 * 1000);

    const protocol = new RecoveryProtocol({
      userId: user._id,
      injuryLogId,
      phases,
      currentPhase: 1,
      startDate: startDate,
      endDate: endDate,
      goal: aiResult.goal || 'Return to play safely',
      target: aiResult.target || 'Full mobility and strength',
      status: 'active'
    });

    await protocol.save();

    const notification = new Notification({
      userId: user._id,
      type: 'recovery_reminder',
      message: `Recovery protocol generated for your ${injuryLog.muscleGroup} ${injuryLog.injuryType}. Let's start Phase 1: ${phases[0].name}.`
    });
    await notification.save();

    res.status(201).json({
      success: true,
      data: protocol,
      message: 'Recovery protocol generated successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.getProtocols = async (req, res, next) => {
  try {
    const features = new APIFeatures(RecoveryProtocol.find({ userId: req.user._id }).populate('injuryLogId'), req.query)
      .filter()
      .sort()
      .limitFields()
      .paginate();

    const protocols = await features.query;
    const total = await RecoveryProtocol.countDocuments({ userId: req.user._id, ...features.query.getQuery() });

    res.status(200).json({
      success: true,
      data: protocols,
      total,
      message: 'Recovery protocols retrieved successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.getActiveProtocols = async (req, res, next) => {
  try {
    const protocol = await RecoveryProtocol.findOne({ userId: req.user._id, status: 'active' })
      .populate('injuryLogId');

    res.status(200).json({
      success: true,
      data: protocol || null,
      message: protocol ? 'Active recovery protocol retrieved successfully' : 'No active recovery protocol found'
    });
  } catch (err) {
    next(err);
  }
};

exports.getProtocolById = async (req, res, next) => {
  try {
    const protocol = await RecoveryProtocol.findOne({ _id: req.params.id, userId: req.user._id })
      .populate('injuryLogId');
    if (!protocol) {
      return res.status(404).json({
        success: false,
        data: null,
        message: 'Recovery protocol not found'
      });
    }

    res.status(200).json({
      success: true,
      data: protocol,
      message: 'Recovery protocol retrieved successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.completePhase = async (req, res, next) => {
  try {
    const { id, phaseNumber } = req.params;
    const phaseVal = parseInt(phaseNumber, 10);

    const protocol = await RecoveryProtocol.findOne({ _id: id, userId: req.user._id });
    if (!protocol) {
      return res.status(404).json({
        success: false,
        data: null,
        message: 'Recovery protocol not found'
      });
    }

    if (protocol.status !== 'active') {
      return res.status(400).json({
        success: false,
        data: null,
        message: `Recovery protocol is already marked as ${protocol.status}`
      });
    }

    const phase = protocol.phases.find(p => p.phaseNumber === phaseVal);
    if (!phase) {
      return res.status(400).json({
        success: false,
        data: null,
        message: `Phase ${phaseNumber} does not exist in this protocol`
      });
    }

    if (phase.completed) {
      return res.status(400).json({
        success: false,
        data: null,
        message: `Phase ${phaseNumber} is already completed`
      });
    }

    await RecoveryProtocol.updateOne(
      { _id: id, userId: req.user._id, "phases.phaseNumber": phaseVal },
      { $set: { "phases.$.completed": true } }
    );

    const updatedProtocol = await RecoveryProtocol.findOne({ _id: id, userId: req.user._id });

    const allCompleted = updatedProtocol.phases.every(p => p.completed);

    if (allCompleted) {
      updatedProtocol.status = 'completed';
      await InjuryLog.updateOne(
        { _id: updatedProtocol.injuryLogId },
        { $set: { recoveryStatus: 'recovered' } }
      );
    } else {
      const nextPhase = updatedProtocol.phases.find(p => !p.completed);
      if (nextPhase) {
        updatedProtocol.currentPhase = nextPhase.phaseNumber;
      }
    }

    await updatedProtocol.save();

    let msg = `Phase ${phaseVal} of your recovery protocol completed.`;
    if (updatedProtocol.status === 'completed') {
      const injuryLogObj = await InjuryLog.findById(updatedProtocol.injuryLogId);
      const muscle = injuryLogObj ? injuryLogObj.muscleGroup : 'injured area';
      msg = `Excellent work! You completed all recovery phases for your ${muscle}. Injury marked as recovered.`;
    }

    const notification = new Notification({
      userId: req.user._id,
      type: 'recovery_reminder',
      message: msg
    });
    await notification.save();

    res.status(200).json({
      success: true,
      data: updatedProtocol,
      message: updatedProtocol.status === 'completed'
        ? 'All phases completed! Injury recovered!'
        : `Phase ${phaseVal} marked as complete`
    });
  } catch (err) {
    next(err);
  }
};

exports.toggleExercise = async (req, res, next) => {
  try {
    const { id, phaseNumber, exerciseId } = req.params;
    const phaseVal = parseInt(phaseNumber, 10);

    const protocol = await RecoveryProtocol.findOne({ _id: id, userId: req.user._id });
    if (!protocol) {
      return res.status(404).json({ success: false, data: null, message: 'Protocol not found' });
    }

    const phase = protocol.phases.find(p => p.phaseNumber === phaseVal);
    if (!phase) {
      return res.status(404).json({ success: false, data: null, message: 'Phase not found' });
    }

    const exercise = phase.exercises.id(exerciseId);
    if (!exercise) {
      return res.status(404).json({ success: false, data: null, message: 'Exercise not found' });
    }

    exercise.completed = !exercise.completed;
    exercise.completedAt = exercise.completed ? new Date() : null;

    protocol.markModified('phases');
    await protocol.save();

    res.status(200).json({
      success: true,
      data: protocol,
      message: 'Exercise toggled successfully'
    });
  } catch (err) {
    next(err);
  }
};
