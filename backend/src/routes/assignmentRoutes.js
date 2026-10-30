const express = require('express');
const router = express.Router();
const {
  getAssignments,
  createAssignment,
  submitAssignment,
} = require('../controllers/assignmentController');
const { protect, authorize } = require('../middleware/auth');

router.use(protect);

router.get('/', getAssignments);
router.post('/', authorize('admin', 'faculty'), createAssignment);
router.post('/:id/submit', authorize('student'), submitAssignment);

module.exports = router;
