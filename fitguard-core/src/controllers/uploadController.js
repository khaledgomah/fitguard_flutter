exports.uploadFile = async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        data: null,
        message: 'No file uploaded'
      });
    }

    // If Cloudinary is used, req.file.path contains the full URL.
    // Otherwise, construct the local URL.
    const protocol = req.headers['x-forwarded-proto'] || req.protocol;
    const fileUrl = (req.file.path && req.file.path.startsWith('http'))
      ? req.file.path
      : `${protocol}://${req.get('host')}/uploads/${req.file.filename}`;

    res.status(201).json({
      success: true,
      data: {
        url: fileUrl,
        filename: req.file.filename,
        mimetype: req.file.mimetype,
        size: req.file.size
      },
      message: 'File uploaded successfully'
    });
  } catch (err) {
    next(err);
  }
};
