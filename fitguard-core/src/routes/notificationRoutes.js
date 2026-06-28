const express = require('express');
const { param } = require('express-validator');
const notificationController = require('../controllers/notificationController');
const auth = require('../middleware/auth');
const validate = require('../middleware/validate');

const router = express.Router();

router.use(auth);

router.get('/', notificationController.getNotifications);

router.put('/read-all', notificationController.markAllAsRead);

router.put(
  '/:id/read',
  [
    param('id').isMongoId().withMessage('Invalid notification ID')
  ],
  validate,
  notificationController.markAsRead
);

router.delete(
  '/:id',
  [
    param('id').isMongoId().withMessage('Invalid notification ID')
  ],
  validate,
  notificationController.deleteNotification
);

module.exports = router;
