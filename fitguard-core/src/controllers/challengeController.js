const Challenge = require('../models/Challenge');
const InjuryLog = require('../models/InjuryLog');
const Notification = require('../models/Notification');
const aiService = require('../services/aiService');
const { getInjuryAIContext } = require('../utils/injuryPatterns');
const APIFeatures = require('../utils/apiFeatures');

exports.generateChallenge = async (req, res, next) => {
  try {
    const { difficulty } = req.body;
    const user = req.user;

    const injuryLogs = await InjuryLog.find({ userId: user._id });

    const aiContext = getInjuryAIContext(user, difficulty, injuryLogs);
    const aiResult = await aiService.generateChallenge(aiContext);

    if (!aiResult || !Array.isArray(aiResult.days)) {
      return res.status(502).json({
        success: false,
        data: null,
        message: 'Invalid plan format returned by the AI service.'
      });
    }

    await Challenge.updateMany(
      { userId: user._id, status: 'active' },
      { $set: { status: 'abandoned' } }
    );

    const generatedPlan = aiResult.days.map(d => ({
      day: d.day,
      task: d.task,
      exercises: (d.exercises || []).map(ex => {
        if (typeof ex === 'string') {
          return { title: ex, completed: false };
        }
        return {
          title: ex.title || 'Exercise',
          description: ex.description || '',
          sets: typeof ex.sets === 'number' ? ex.sets : null,
          reps: typeof ex.reps === 'number' ? ex.reps : null,
          duration: ex.duration || null,
          completed: ex.completed || false
        };
      }),
      muscleGroups: d.muscleGroups || [],
      difficulty: d.difficulty || difficulty,
      completed: false
    }));

    const challenge = new Challenge({
      userId: user._id,
      sport: user.sport,
      difficulty,
      generatedPlan,
      startDate: new Date(),
      status: 'active'
    });

    await challenge.save();

    const notification = new Notification({
      userId: user._id,
      type: 'challenge_nudge',
      message: `Your personalized 30-day ${challenge.sport} challenge (${challenge.difficulty}) has been generated! Complete Day 1 to start your streak.`
    });
    await notification.save();

    res.status(201).json({
      success: true,
      data: challenge,
      message: 'Challenge generated successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.getChallenges = async (req, res, next) => {
  try {
    const features = new APIFeatures(Challenge.find({ userId: req.user._id }), req.query)
      .filter()
      .sort()
      .limitFields()
      .paginate();

    const challenges = await features.query;
    const total = await Challenge.countDocuments({ userId: req.user._id, ...features.query.getQuery() });

    res.status(200).json({
      success: true,
      data: challenges,
      total,
      message: 'Challenges retrieved successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.getActiveChallenge = async (req, res, next) => {
  try {
    const challenge = await Challenge.findOne({ userId: req.user._id, status: 'active' });
    if (!challenge) {
      return res.status(200).json({
        success: true,
        data: null,
        message: 'No active challenge found'
      });
    }

    res.status(200).json({
      success: true,
      data: challenge,
      message: 'Active challenge retrieved successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.getChallengeById = async (req, res, next) => {
  try {
    const challenge = await Challenge.findOne({ _id: req.params.id, userId: req.user._id });
    if (!challenge) {
      return res.status(404).json({
        success: false,
        data: null,
        message: 'Challenge not found'
      });
    }

    res.status(200).json({
      success: true,
      data: challenge,
      message: 'Challenge retrieved successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.completeDay = async (req, res, next) => {
  try {
    const { id, dayNumber } = req.params;
    const dayVal = parseInt(dayNumber, 10);

    const challenge = await Challenge.findOne({ _id: id, userId: req.user._id });
    if (!challenge) {
      return res.status(404).json({
        success: false,
        data: null,
        message: 'Challenge not found'
      });
    }

    if (challenge.status !== 'active') {
      return res.status(400).json({
        success: false,
        data: null,
        message: `Cannot modify a challenge that is already ${challenge.status}`
      });
    }

    const dayObj = challenge.generatedPlan.find(d => d.day === dayVal);
    if (!dayObj) {
      return res.status(400).json({
        success: false,
        data: null,
        message: `Day ${dayNumber} does not exist in this challenge`
      });
    }

    if (dayObj.completed) {
      return res.status(400).json({
        success: false,
        data: null,
        message: `Day ${dayNumber} is already completed`
      });
    }

    dayObj.completed = true;
    dayObj.completedAt = new Date();

    challenge.markModified('generatedPlan');

    const allCompleted = challenge.generatedPlan.every(d => d.completed);
    if (allCompleted) {
      challenge.status = 'completed';
      challenge.completedAt = new Date();
    }

    await challenge.save();

    let msg = `Day ${dayVal} of your ${challenge.sport} challenge is complete! Keep up the good work.`;
    if (challenge.status === 'completed') {
      msg = `Incredible job! You have fully completed your 30-day ${challenge.sport} challenge!`;
    }

    const notification = new Notification({
      userId: req.user._id,
      type: 'challenge_nudge',
      message: msg
    });
    await notification.save();

    res.status(200).json({
      success: true,
      data: challenge,
      message: challenge.status === 'completed'
        ? 'Challenge completed! Congratulations!'
        : `Day ${dayVal} marked as complete`
    });
  } catch (err) {
    next(err);
  }
};

exports.abandonChallenge = async (req, res, next) => {
  try {
    const { id } = req.params;

    const challenge = await Challenge.findOne({ _id: id, userId: req.user._id, status: 'active' });
    if (!challenge) {
      return res.status(404).json({
        success: false,
        data: null,
        message: 'Active challenge not found'
      });
    }

    challenge.status = 'abandoned';
    await challenge.save();

    res.status(200).json({
      success: true,
      data: challenge,
      message: 'Challenge abandoned successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.toggleExercise = async (req, res, next) => {
  try {
    const { id, dayNumber, exerciseId } = req.params;
    const dayVal = parseInt(dayNumber, 10);

    const challenge = await Challenge.findOne({ _id: id, userId: req.user._id });
    if (!challenge) {
      return res.status(404).json({ success: false, data: null, message: 'Challenge not found' });
    }

    const dayObj = challenge.generatedPlan.find(d => d.day === dayVal);
    if (!dayObj) {
      return res.status(404).json({ success: false, data: null, message: 'Day not found' });
    }

    const exercise = dayObj.exercises.id(exerciseId);
    if (!exercise) {
      return res.status(404).json({ success: false, data: null, message: 'Exercise not found' });
    }

    exercise.completed = !exercise.completed;
    exercise.completedAt = exercise.completed ? new Date() : null;

    challenge.markModified('generatedPlan');
    await challenge.save();

    res.status(200).json({
      success: true,
      data: challenge,
      message: 'Exercise toggled successfully'
    });
  } catch (err) {
    next(err);
  }
};
