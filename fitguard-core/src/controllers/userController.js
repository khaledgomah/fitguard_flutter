const User = require('../models/User');

exports.getProfile = async (req, res, next) => {
  try {
    const user = req.user;
    res.status(200).json({
      success: true,
      data: {
        id: user._id,
        name: user.name,
        email: user.email,
        sport: user.sport,
        age: user.age,
        weight: user.weight,
        height: user.height,
        avatarUrl: user.avatarUrl,
        settings: user.settings,
        connectedDevices: user.connectedDevices,
        createdAt: user.createdAt
      },
      message: 'Athlete profile retrieved successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.updateProfile = async (req, res, next) => {
  try {
    const user = req.user;
    const { name, email, sport, age, weight, height } = req.body;

    if (name !== undefined) user.name = name;
    if (email !== undefined) user.email = email;
    if (sport !== undefined) user.sport = sport;
    if (age !== undefined) user.age = age;
    if (weight !== undefined) user.weight = weight;
    if (height !== undefined) user.height = height;
    if (req.body.avatarUrl !== undefined) user.avatarUrl = req.body.avatarUrl;

    await user.save();

    res.status(200).json({
      success: true,
      data: {
        id: user._id,
        name: user.name,
        email: user.email,
        sport: user.sport,
        age: user.age,
        weight: user.weight,
        height: user.height,
        avatarUrl: user.avatarUrl,
        settings: user.settings,
        connectedDevices: user.connectedDevices,
        createdAt: user.createdAt
      },
      message: 'Athlete profile updated successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.updateSettings = async (req, res, next) => {
  try {
    const user = req.user;
    const { settings } = req.body;
    
    if (settings) {
      user.settings = { ...user.settings, ...settings };
      await user.save();
    }

    res.status(200).json({
      success: true,
      data: user.settings,
      message: 'Settings updated successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.updateDevices = async (req, res, next) => {
  try {
    const user = req.user;
    const { devices } = req.body;
    
    if (devices) {
      user.connectedDevices = devices;
      await user.save();
    }

    res.status(200).json({
      success: true,
      data: user.connectedDevices,
      message: 'Devices updated successfully'
    });
  } catch (err) {
    next(err);
  }
};
