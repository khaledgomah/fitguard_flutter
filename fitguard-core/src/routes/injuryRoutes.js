const express = require('express');
const { body, param } = require('express-validator');
const injuryController = require('../controllers/injuryController');
const auth = require('../middleware/auth');
const validate = require('../middleware/validate');

const router = express.Router();

router.use(auth);

router.post(
  '/',
  [
    body('muscleGroup').notEmpty().withMessage('Muscle group is required').trim(),
    body('injuryType').notEmpty().withMessage('Injury type is required').trim(),
    body('severity').isIn(['mild', 'moderate', 'severe']).withMessage('Severity must be mild, moderate, or severe'),
    body('dateOccurred').isISO8601().withMessage('A valid date is required (ISO8601 format)'),
    body('recoveryStatus').optional().isIn(['active', 'recovered']).withMessage('Recovery status must be active or recovered'),
    body('notes').optional().trim()
  ],
  validate,
  injuryController.createInjury
);

router.get('/', injuryController.getInjuries);

router.get('/patterns', injuryController.getPatterns);

router.get(
  '/:id',
  [
    param('id').isMongoId().withMessage('Invalid injury log ID')
  ],
  validate,
  injuryController.getInjuryById
);

router.put(
  '/:id',
  [
    param('id').isMongoId().withMessage('Invalid injury log ID'),
    body('muscleGroup').optional().notEmpty().withMessage('Muscle group cannot be empty').trim(),
    body('injuryType').optional().notEmpty().withMessage('Injury type cannot be empty').trim(),
    body('severity').optional().isIn(['mild', 'moderate', 'severe']).withMessage('Severity must be mild, moderate, or severe'),
    body('dateOccurred').optional().isISO8601().withMessage('A valid date is required'),
    body('recoveryStatus').optional().isIn(['active', 'recovered']).withMessage('Recovery status must be active or recovered'),
    body('notes').optional().trim()
  ],
  validate,
  injuryController.updateInjury
);

router.delete(
  '/:id',
  [
    param('id').isMongoId().withMessage('Invalid injury log ID')
  ],
  validate,
  injuryController.deleteInjury
);

module.exports = router;
