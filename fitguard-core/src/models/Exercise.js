const mongoose = require('mongoose');

const exerciseSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true
  },
  description: {
    type: String
  },
  sets: {
    type: Number
  },
  reps: {
    type: Number
  },
  duration: {
    type: String
  },
  completed: {
    type: Boolean,
    default: false
  },
  completedAt: {
    type: Date
  },
  notes: {
    type: String
  }
}, { _id: true }); // Give exercises an ID so they can be toggled

module.exports = exerciseSchema;
