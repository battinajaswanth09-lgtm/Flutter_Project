const express = require('express');
const router = express.Router();
const {
  markAttendance,
  getAttendance,
  getStudentAttendanceSummary,
} = require('../controllers/attendanceController');
const { protect, authorize } = require('../middleware/auth');

router.use(protect);

router.post('/', authorize('admin', 'faculty'), markAttendance);
router.get('/', getAttendance);
router.get('/student/:studentId', getStudentAttendanceSummary);

module.exports = router;

