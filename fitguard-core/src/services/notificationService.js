const Notification = require('../models/Notification');

const createNotification = async ({ userId, type, message }) => {
  if (!userId || !type || !message) {
    return null;
  }

  return Notification.create({
    userId,
    type,
    message
  });
};

module.exports = {
  createNotification
};
