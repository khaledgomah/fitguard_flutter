const mongoose = require('mongoose');
const exerciseSchema = require('./Exercise');

const recoveryPhaseSchema = new mongoose.Schema({
  phaseNumber: {
    type: Number,
    required: true
  },
  name: {
    type: String,
    required: true
  },
  durationDays: {
    type: Number,
    required: true
  },
  exercises: {
    type: [exerciseSchema],
    default: []
  },
  completed: {
    type: Boolean,
    default: false
  }
}, { _id: false });

const recoveryProtocolSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  injuryLogId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'InjuryLog',
    required: true
  },
  phases: {
    type: [recoveryPhaseSchema],
    required: true
  },
  currentPhase: {
    type: Number,
    default: 1
  },
  startDate: {
    type: Date,
    default: Date.now
  },
  endDate: {
    type: Date
  },
  goal: {
    type: String,
    required: false
  },
  target: {
    type: String,
    required: false
  },
  status: {
    type: String,
    enum: ['active', 'completed'],
    default: 'active'
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('RecoveryProtocol', recoveryProtocolSchema);
