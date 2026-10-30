const express = require('express');
const router = express.Router();
const {
  getAllFaculty,
  getFacultyById,
  createFaculty,
  updateFaculty,
  deleteFaculty,
  getMyFacultyOverview,
} = require('../controllers/facultyController');
const { protect, authorize } = require('../middleware/auth');

router.use(protect);

router.get('/me/overview', authorize('faculty'), getMyFacultyOverview);
router.get('/', authorize('admin', 'faculty'), getAllFaculty);
router.get('/:id', getFacultyById);
router.post('/', authorize('admin'), createFaculty);
router.put('/:id', authorize('admin'), updateFaculty);
router.delete('/:id', authorize('admin'), deleteFaculty);

module.exports = router;
