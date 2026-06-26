module.exports = (err, req, res, next) => {
  console.error('[Error Handler Log]:', err.stack || err);

  const statusCode = err.status || err.statusCode || 500;
  const message = err.message || 'Internal server error';

  res.status(statusCode).json({
    success: false,
    data: null,
    message
  });
};
