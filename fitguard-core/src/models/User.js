const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true
  },
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    trim: true
  },
  password: {
    type: String,
    required: true
  },
  sport: {
    type: String,
    required: true,
    trim: true
  },
  age: {
    type: Number,
    required: true
  },
  weight: {
    type: Number,
    required: true
  },
  height: {
    type: Number,
    required: true
  },
  role: {
    type: String,
    enum: ['athlete', 'admin'],
    default: 'athlete'
  },
  avatarUrl: {
    type: String,
    default: null
  },
  settings: {
    alerts: { type: Boolean, default: true },
    summary: { type: Boolean, default: true },
    updates: { type: Boolean, default: false }
  },
  connectedDevices: [{
    provider: { type: String, enum: ['whoop', 'garmin', 'apple_health'] },
    connectedAt: { type: Date, default: Date.now }
  }],
  refreshTokens: {
    type: [String],
    default: []
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

userSchema.pre('save', async function (next) {
  if (!this.isModified('password')) return next();
  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (err) {
    next(err);
  }
});

userSchema.methods.comparePassword = async function (candidatePassword) {
  return bcrypt.compare(candidatePassword, this.password);
};

module.exports = mongoose.model('User', userSchema);
