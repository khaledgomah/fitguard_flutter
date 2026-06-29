const InjuryLog = require('../models/InjuryLog');
const { createNotification } = require('../services/notificationService');
const APIFeatures = require('../utils/apiFeatures');

exports.createInjury = async (req, res, next) => {
  try {
    const { muscleGroup, injuryType, severity, dateOccurred, recoveryStatus, notes } = req.body;

    const injury = new InjuryLog({
      userId: req.user._id,
      muscleGroup,
      injuryType,
      severity,
      dateOccurred,
      recoveryStatus: recoveryStatus || 'active',
      notes
    });

    await injury.save();

    await createNotification({
      userId: req.user._id,
      type: 'injury_reminder',
      message: `Injury logged: ${injury.severity} ${injury.injuryType} on ${injury.muscleGroup}. Take care and consider generating a recovery protocol.`
    });

    res.status(201).json({
      success: true,
      data: injury,
      message: 'Injury log created successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.getInjuries = async (req, res, next) => {
  try {
    const features = new APIFeatures(InjuryLog.find({ userId: req.user._id }), req.query)
      .filter()
      .sort()
      .limitFields()
      .paginate();
    
    const injuries = await features.query;
    const total = await InjuryLog.countDocuments({ userId: req.user._id, ...features.query.getQuery() });

    res.status(200).json({
      success: true,
      data: injuries,
      total,
      message: 'Injury logs retrieved successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.getInjuryById = async (req, res, next) => {
  try {
    const injury = await InjuryLog.findOne({ _id: req.params.id, userId: req.user._id });
    if (!injury) {
      return res.status(404).json({
        success: false,
        data: null,
        message: 'Injury log not found'
      });
    }

    res.status(200).json({
      success: true,
      data: injury,
      message: 'Injury log retrieved successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.updateInjury = async (req, res, next) => {
  try {
    const injury = await InjuryLog.findOne({ _id: req.params.id, userId: req.user._id });
    if (!injury) {
      return res.status(404).json({
        success: false,
        data: null,
        message: 'Injury log not found'
      });
    }

    const { muscleGroup, injuryType, severity, dateOccurred, recoveryStatus, notes } = req.body;
    const previousStatus = injury.recoveryStatus;

    if (muscleGroup !== undefined) injury.muscleGroup = muscleGroup;
    if (injuryType !== undefined) injury.injuryType = injuryType;
    if (severity !== undefined) injury.severity = severity;
    if (dateOccurred !== undefined) injury.dateOccurred = dateOccurred;
    if (recoveryStatus !== undefined) injury.recoveryStatus = recoveryStatus;
    if (notes !== undefined) injury.notes = notes;

    await injury.save();

    if (previousStatus === 'active' && injury.recoveryStatus === 'recovered') {
      await createNotification({
        userId: req.user._id,
        type: 'recovery_reminder',
        message: `Great news! You have recovered from your ${injury.muscleGroup} injury.`
      });
    }

    res.status(200).json({
      success: true,
      data: injury,
      message: 'Injury log updated successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.deleteInjury = async (req, res, next) => {
  try {
    const result = await InjuryLog.deleteOne({ _id: req.params.id, userId: req.user._id });
    if (result.deletedCount === 0) {
      return res.status(404).json({
        success: false,
        data: null,
        message: 'Injury log not found'
      });
    }

    res.status(200).json({
      success: true,
      data: {},
      message: 'Injury log deleted successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.getPatterns = async (req, res, next) => {
  try {
    const patterns = await InjuryLog.aggregate([
      { $match: { userId: req.user._id } },
      {
        $group: {
          _id: '$muscleGroup',
          count: { $sum: 1 }
        }
      },
      { $sort: { count: -1 } },
      {
        $project: {
          _id: 0,
          muscleGroup: '$_id',
          count: 1
        }
      }
    ]);

    res.status(200).json({
      success: true,
      data: patterns,
      message: 'Injury patterns aggregated successfully'
    });
  } catch (err) {
    next(err);
  }
};
