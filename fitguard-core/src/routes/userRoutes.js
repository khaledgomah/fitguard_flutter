const express = require('express');
const { body } = require('express-validator');
const userController = require('../controllers/userController');
const auth = require('../middleware/auth');
const authorize = require('../middleware/authorize');
const validate = require('../middleware/validate');

const router = express.Router();

router.use(auth);

router.get('/profile', userController.getProfile);

router.put(
  '/profile',
  [
    body('name').optional().notEmpty().withMessage('Name cannot be empty').trim(),
    body('sport').optional().notEmpty().withMessage('Sport cannot be empty').trim(),
    body('age').optional().isInt({ min: 1 }).withMessage('Age must be a positive integer'),
    body('weight').optional().isFloat({ min: 1 }).withMessage('Weight must be a positive number'),
    body('height').optional().isFloat({ min: 1 }).withMessage('Height must be a positive number')
  ],
  validate,
  userController.updateProfile
);

router.put(
  '/settings',
  [
    body('settings').isObject().withMessage('Settings object is required')
  ],
  validate,
  userController.updateSettings
);

router.put(
  '/devices',
  [
    body('devices').isArray().withMessage('Devices array is required')
  ],
  validate,
  userController.updateDevices
);

module.exports = router;
