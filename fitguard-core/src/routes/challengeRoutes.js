const express = require('express');
const { body, param } = require('express-validator');
const challengeController = require('../controllers/challengeController');
const auth = require('../middleware/auth');
const validate = require('../middleware/validate');

const router = express.Router();

router.use(auth);

router.post(
  '/generate',
  [
    body('difficulty')
      .isIn(['beginner', 'intermediate', 'advanced'])
      .withMessage('Difficulty must be beginner, intermediate, or advanced')
  ],
  validate,
  challengeController.generateChallenge
);

router.get('/', challengeController.getChallenges);

router.get('/active', challengeController.getActiveChallenge);

router.get(
  '/:id',
  [
    param('id').isMongoId().withMessage('Invalid challenge ID')
  ],
  validate,
  challengeController.getChallengeById
);

router.put(
  '/:id/day/:dayNumber/complete',
  [
    param('id').isMongoId().withMessage('Invalid challenge ID'),
    param('dayNumber').isInt({ min: 1, max: 30 }).withMessage('Day number must be between 1 and 30')
  ],
  validate,
  challengeController.completeDay
);

router.put(
  '/:id/abandon',
  [
    param('id').isMongoId().withMessage('Invalid challenge ID')
  ],
  validate,
  challengeController.abandonChallenge
);

router.put(
  '/:id/day/:dayNumber/exercise/:exerciseId/toggle',
  [
    param('id').isMongoId().withMessage('Invalid challenge ID'),
    param('dayNumber').isInt({ min: 1, max: 30 }).withMessage('Day number must be between 1 and 30'),
    param('exerciseId').isMongoId().withMessage('Invalid exercise ID')
  ],
  validate,
  challengeController.toggleExercise
);

module.exports = router;
