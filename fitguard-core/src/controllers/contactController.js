const ContactInquiry = require('../models/ContactInquiry');

exports.submitInquiry = async (req, res, next) => {
  try {
    const { firstName, lastName, email, inquiryType, message } = req.body;

    const inquiry = new ContactInquiry({
      firstName,
      lastName,
      email,
      inquiryType,
      message
    });

    await inquiry.save();

    res.status(201).json({
      success: true,
      data: inquiry,
      message: 'Inquiry submitted successfully. We will be in touch soon.'
    });
  } catch (err) {
    if (err.name === 'ValidationError') {
      const messages = Object.values(err.errors).map(val => val.message);
      return res.status(400).json({
        success: false,
        error: messages.join(', ')
      });
    }
    next(err);
  }
};
