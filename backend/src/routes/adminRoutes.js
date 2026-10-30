const express = require('express');
const router = express.Router();
const { getDashboardStats, getAcademicReports } = require('../controllers/adminController');
const { protect, authorize } = require('../middleware/auth');

router.use(protect);
router.use(authorize('admin'));

router.get('/dashboard-stats', getDashboardStats);
router.get('/reports', getAcademicReports);

module.exports = router;
