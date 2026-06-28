const express = require('express');
const { body } = require('express-validator');
const rateLimit = require('express-rate-limit');
const authController = require('../controllers/authController');
const validate = require('../middleware/validate');

const router = express.Router();

const isDev = process.env.NODE_ENV === 'development';
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, 
  max: isDev ? 1000 : 10,
  standardHeaders: true,
  legacyHeaders: false,
  skipSuccessfulRequests: true,
  message: { success: false, message: 'Too many failed login attempts, please try again later.' }
});

router.post(
  '/register',
  authLimiter,
  [
    body('name').notEmpty().withMessage('Name is required').trim(),
    body('email').isEmail().withMessage('A valid email address is required').normalizeEmail(),
    body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters long'),
    body('sport').notEmpty().withMessage('Sport preference is required').trim(),
    body('age').isInt({ min: 1 }).withMessage('Age must be a positive integer'),
    body('weight').isFloat({ min: 1 }).withMessage('Weight must be a positive number'),
    body('height').isFloat({ min: 1 }).withMessage('Height must be a positive number')
  ],
  validate,
  authController.register
);

router.post(
  '/login',
  authLimiter,
  [
    body('email').isEmail().withMessage('A valid email address is required').normalizeEmail(),
    body('password').notEmpty().withMessage('Password is required')
  ],
  validate,
  authController.login
);

router.post(
  '/logout',
  [
    body('refreshToken').notEmpty().withMessage('Refresh token is required')
  ],
  validate,
  authController.logout
);

router.post(
  '/refresh-token',
  [
    body('refreshToken').notEmpty().withMessage('Refresh token is required')
  ],
  validate,
  authController.refreshToken
);

router.put(
  '/password',
  require('../middleware/auth'),
  [
    body('currentPassword').notEmpty().withMessage('Current password is required'),
    body('newPassword').isLength({ min: 6 }).withMessage('New password must be at least 6 characters long')
  ],
  validate,
  authController.updatePassword
);

module.exports = router;
