const mongoose = require('mongoose');

const injuryLogSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  muscleGroup: {
    type: String,
    required: true,
    trim: true,
    lowercase: true
  },
  injuryType: {
    type: String,
    required: true,
    trim: true,
    lowercase: true
  },
  severity: {
    type: String,
    enum: ['mild', 'moderate', 'severe'],
    required: true
  },
  dateOccurred: {
    type: Date,
    required: true
  },
  recoveryStatus: {
    type: String,
    enum: ['active', 'recovered'],
    default: 'active',
    required: true
  },
  notes: {
    type: String,
    default: ''
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('InjuryLog', injuryLogSchema);
