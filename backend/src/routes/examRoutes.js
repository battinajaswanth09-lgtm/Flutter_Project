const express = require('express');
const router = express.Router();
const {
  getExams,
  createExam,
  submitMarks,
  getStudentResults,
} = require('../controllers/examController');
const { protect, authorize } = require('../middleware/auth');

router.use(protect);

router.get('/', getExams);
router.post('/', authorize('admin'), createExam);
router.post('/results', authorize('admin', 'faculty'), submitMarks);
router.get('/results/student/:studentId', getStudentResults);

module.exports = router;
