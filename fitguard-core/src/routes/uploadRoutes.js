const express = require('express');
const uploadController = require('../controllers/uploadController');
const upload = require('../config/multer');
const auth = require('../middleware/auth');

const router = express.Router();

router.use(auth);

router.post('/', upload.single('file'), uploadController.uploadFile);

module.exports = router;
