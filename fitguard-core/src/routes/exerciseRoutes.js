const express = require('express');
const { body, param } = require('express-validator');
const exerciseController = require('../controllers/exerciseController');
const auth = require('../middleware/auth');
const validate = require('../middleware/validate');

const router = express.Router();

router.use(auth);

router.post(
  '/',
  [
    body('title').notEmpty().withMessage('Title is required').trim(),
    body('description').optional().trim(),
    body('sets').optional().isInt({ min: 1 }).withMessage('Sets must be a positive integer'),
    body('reps').optional().isInt({ min: 1 }).withMessage('Reps must be a positive integer'),
    body('duration').optional().trim(),
    body('notes').optional().trim()
  ],
  validate,
  exerciseController.createExercise
);

router.get('/', exerciseController.getExercises);

router.get(
  '/:id',
  [
    param('id').isMongoId().withMessage('Invalid exercise ID')
  ],
  validate,
  exerciseController.getExerciseById
);

router.put(
  '/:id',
  [
    param('id').isMongoId().withMessage('Invalid exercise ID'),
    body('title').optional().notEmpty().withMessage('Title cannot be empty').trim(),
    body('description').optional().trim(),
    body('sets').optional().isInt({ min: 1 }).withMessage('Sets must be a positive integer'),
    body('reps').optional().isInt({ min: 1 }).withMessage('Reps must be a positive integer'),
    body('duration').optional().trim(),
    body('completed').optional().isBoolean().withMessage('Completed must be a boolean'),
    body('notes').optional().trim()
  ],
  validate,
  exerciseController.updateExercise
);

router.delete(
  '/:id',
  [
    param('id').isMongoId().withMessage('Invalid exercise ID')
  ],
  validate,
  exerciseController.deleteExercise
);

module.exports = router;
