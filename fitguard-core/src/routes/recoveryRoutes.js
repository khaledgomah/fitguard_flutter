const express = require('express');
const { body, param } = require('express-validator');
const recoveryController = require('../controllers/recoveryController');
const auth = require('../middleware/auth');
const validate = require('../middleware/validate');

const router = express.Router();

router.use(auth);

router.post(
  '/generate',
  [
    body('injuryLogId').isMongoId().withMessage('A valid injury log ID is required')
  ],
  validate,
  recoveryController.generateProtocol
);

router.get('/', recoveryController.getProtocols);

router.get('/active', recoveryController.getActiveProtocols);

router.get(
  '/:id',
  [
    param('id').isMongoId().withMessage('Invalid protocol ID')
  ],
  validate,
  recoveryController.getProtocolById
);

router.put(
  '/:id/phase/:phaseNumber/complete',
  [
    param('id').isMongoId().withMessage('Invalid protocol ID'),
    param('phaseNumber').isInt({ min: 1 }).withMessage('Phase number must be a positive integer')
  ],
  validate,
  recoveryController.completePhase
);

router.put(
  '/:id/phase/:phaseNumber/exercise/:exerciseId/toggle',
  [
    param('id').isMongoId().withMessage('Invalid protocol ID'),
    param('phaseNumber').isInt({ min: 1 }).withMessage('Phase number must be a positive integer'),
    param('exerciseId').isMongoId().withMessage('Invalid exercise ID')
  ],
  validate,
  recoveryController.toggleExercise
);

module.exports = router;
