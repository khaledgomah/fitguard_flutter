const mongoose = require('mongoose');
const exerciseSchema = require('../models/Exercise');
const APIFeatures = require('../utils/apiFeatures');

// Extend schema with optional userId and timestamps if not already defined
if (!exerciseSchema.path('userId')) {
  exerciseSchema.add({
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: false
    }
  });
}
exerciseSchema.set('timestamps', true);

const Exercise = mongoose.models.Exercise || mongoose.model('Exercise', exerciseSchema);

exports.createExercise = async (req, res, next) => {
  try {
    const { title, description, sets, reps, duration, completed, completedAt, notes } = req.body;

    const exercise = new Exercise({
      userId: req.user._id,
      title,
      description,
      sets,
      reps,
      duration,
      completed: completed || false,
      completedAt: completed ? (completedAt || new Date()) : null,
      notes
    });

    await exercise.save();

    res.status(201).json({
      success: true,
      data: exercise,
      message: 'Exercise created successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.getExercises = async (req, res, next) => {
  try {
    const features = new APIFeatures(Exercise.find({ userId: req.user._id }), req.query)
      .filter()
      .sort()
      .limitFields()
      .paginate();

    const exercises = await features.query;
    const total = await Exercise.countDocuments({ userId: req.user._id, ...features.query.getQuery() });

    res.status(200).json({
      success: true,
      data: exercises,
      total,
      message: 'Exercises retrieved successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.getExerciseById = async (req, res, next) => {
  try {
    const exercise = await Exercise.findOne({ _id: req.params.id, userId: req.user._id });
    if (!exercise) {
      return res.status(404).json({
        success: false,
        data: null,
        message: 'Exercise not found'
      });
    }

    res.status(200).json({
      success: true,
      data: exercise,
      message: 'Exercise retrieved successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.updateExercise = async (req, res, next) => {
  try {
    const exercise = await Exercise.findOne({ _id: req.params.id, userId: req.user._id });
    if (!exercise) {
      return res.status(404).json({
        success: false,
        data: null,
        message: 'Exercise not found'
      });
    }

    const { title, description, sets, reps, duration, completed, completedAt, notes } = req.body;

    if (title !== undefined) exercise.title = title;
    if (description !== undefined) exercise.description = description;
    if (sets !== undefined) exercise.sets = sets;
    if (reps !== undefined) exercise.reps = reps;
    if (duration !== undefined) exercise.duration = duration;
    if (completed !== undefined) {
      exercise.completed = completed;
      if (completed && !exercise.completedAt) {
        exercise.completedAt = completedAt || new Date();
      } else if (!completed) {
        exercise.completedAt = null;
      }
    }
    if (notes !== undefined) exercise.notes = notes;

    await exercise.save();

    res.status(200).json({
      success: true,
      data: exercise,
      message: 'Exercise updated successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.deleteExercise = async (req, res, next) => {
  try {
    const result = await Exercise.deleteOne({ _id: req.params.id, userId: req.user._id });
    if (result.deletedCount === 0) {
      return res.status(404).json({
        success: false,
        data: null,
        message: 'Exercise not found'
      });
    }

    res.status(200).json({
      success: true,
      data: {},
      message: 'Exercise deleted successfully'
    });
  } catch (err) {
    next(err);
  }
};
