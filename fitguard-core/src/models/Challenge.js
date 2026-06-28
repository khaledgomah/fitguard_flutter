const mongoose = require('mongoose');
const exerciseSchema = require('./Exercise');

const dayPlanSchema = new mongoose.Schema({
  day: {
    type: Number,
    required: true
  },
  task: {
    type: String,
    required: false
  },
  exercises: {
    type: [exerciseSchema],
    default: []
  },
  muscleGroups: {
    type: [String],
    default: []
  },
  difficulty: {
    type: String,
    trim: true
  },
  completed: {
    type: Boolean,
    default: false
  },
  completedAt: {
    type: Date
  }
}, { _id: false });

const challengeSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  sport: {
    type: String,
    required: true
  },
  difficulty: {
    type: String,
    enum: ['beginner', 'intermediate', 'advanced'],
    required: true
  },
  generatedPlan: {
    type: [dayPlanSchema],
    required: true
  },
  startDate: {
    type: Date,
    default: Date.now
  },
  status: {
    type: String,
    enum: ['active', 'completed', 'abandoned'],
    default: 'active',
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  completedAt: {
    type: Date
  }
});

module.exports = mongoose.model('Challenge', challengeSchema);
