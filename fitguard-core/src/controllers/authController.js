const User = require('../models/User');
const jwt = require('jsonwebtoken');


function generateTokens(user) {
  const accessToken = jwt.sign(
    { userId: user._id, role: user.role },
    process.env.JWT_SECRET,
    { expiresIn: '15m' }
  );
  const refreshToken = jwt.sign(
    { userId: user._id, role: user.role },
    process.env.JWT_REFRESH_SECRET,
    { expiresIn: '7d' }
  );
  return { accessToken, refreshToken };
}

exports.register = async (req, res, next) => {
  try {
    const { name, email, password, sport, age, weight, height } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({
        success: false,
        data: null,
        message: 'A user with this email already exists'
      });
    }

    const user = new User({
      name,
      email,
      password,
      sport,
      age,
      weight,
      height
    });

    const { accessToken, refreshToken } = generateTokens(user);
    user.refreshTokens.push(refreshToken);
    await user.save();

    res.status(201).json({
      success: true,
      data: {
        accessToken,
        refreshToken,
        user: {
          id: user._id,
          name: user.name,
          email: user.email,
          role: user.role,
          sport: user.sport,
          age: user.age,
          weight: user.weight,
          height: user.height
        }
      },
      message: 'Athlete registered successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({
        success: false,
        data: null,
        message: 'Invalid email or password'
      });
    }

    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        data: null,
        message: 'Invalid email or password'
      });
    }

    const { accessToken, refreshToken } = generateTokens(user);
    user.refreshTokens.push(refreshToken);
    await user.save();

    res.status(200).json({
      success: true,
      data: {
        accessToken,
        refreshToken,
        user: {
          id: user._id,
          name: user.name,
          email: user.email,
          role: user.role,
          sport: user.sport,
          age: user.age,
          weight: user.weight,
          height: user.height
        }
      },
      message: 'Login successful'
    });
  } catch (err) {
    next(err);
  }
};

exports.logout = async (req, res, next) => {
  try {
    const { refreshToken } = req.body;

    const user = await User.findOne({ refreshTokens: refreshToken });
    if (user) {
      user.refreshTokens = user.refreshTokens.filter(token => token !== refreshToken);
      await user.save();
    }

    res.status(200).json({
      success: true,
      data: {},
      message: 'Logged out successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.refreshToken = async (req, res, next) => {
  try {
    const { refreshToken } = req.body;

    let decoded;
    try {
      decoded = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET);
    } catch (err) {
      return res.status(401).json({
        success: false,
        data: null,
        message: 'Invalid or expired refresh token'
      });
    }

    const user = await User.findOne({ _id: decoded.userId, refreshTokens: refreshToken });
    if (!user) {
      return res.status(403).json({
        success: false,
        data: null,
        message: 'Refresh token is invalid or has been revoked'
      });
    }

    const newTokens = generateTokens(user);

    user.refreshTokens = user.refreshTokens.filter(token => token !== refreshToken);
    user.refreshTokens.push(newTokens.refreshToken);
    await user.save();

    res.status(200).json({
      success: true,
      data: {
        accessToken: newTokens.accessToken,
        refreshToken: newTokens.refreshToken
      },
      message: 'Token refreshed successfully'
    });
  } catch (err) {
    next(err);
  }
};

exports.updatePassword = async (req, res, next) => {
  try {
    const { currentPassword, newPassword } = req.body;
    const user = await User.findById(req.user._id);
    
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    const isMatch = await user.comparePassword(currentPassword);
    if (!isMatch) {
      return res.status(401).json({ success: false, message: 'Incorrect current password' });
    }

    user.password = newPassword;
    await user.save();

    res.status(200).json({
      success: true,
      message: 'Password updated successfully'
    });
  } catch (err) {
    next(err);
  }
};
