const express = require('express');
const router = express.Router();

const authRoutes = require('./authRoutes');
const adminRoutes = require('./adminRoutes');
const studentRoutes = require('./studentRoutes');
const facultyRoutes = require('./facultyRoutes');
const departmentRoutes = require('./departmentRoutes');
const courseRoutes = require('./courseRoutes');
const attendanceRoutes = require('./attendanceRoutes');
const examRoutes = require('./examRoutes');
const timetableRoutes = require('./timetableRoutes');
const feeRoutes = require('./feeRoutes');
const announcementRoutes = require('./announcementRoutes');
const assignmentRoutes = require('./assignmentRoutes');

router.use('/auth', authRoutes);
router.use('/admin', adminRoutes);
router.use('/students', studentRoutes);
router.use('/faculty', facultyRoutes);
router.use('/departments', departmentRoutes);
router.use('/courses', courseRoutes);
router.use('/attendance', attendanceRoutes);
router.use('/exams', examRoutes);
router.use('/timetables', timetableRoutes);
router.use('/fees', feeRoutes);
router.use('/announcements', announcementRoutes);
router.use('/assignments', assignmentRoutes);

module.exports = router;
