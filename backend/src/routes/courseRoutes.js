const express = require('express');
const router = express.Router();
const {
  getCourses,
  createCourse,
  updateCourse,
  deleteCourse,
  getSubjects,
  createSubject,
  updateSubject,
  deleteSubject,
} = require('../controllers/courseController');
const { protect, authorize } = require('../middleware/auth');

// Course routes
router.get('/', getCourses);
router.post('/', protect, authorize('admin'), createCourse);
router.put('/:id', protect, authorize('admin'), updateCourse);
router.delete('/:id', protect, authorize('admin'), deleteCourse);

// Subject routes
router.get('/subjects/all', getSubjects);
router.post('/subjects', protect, authorize('admin'), createSubject);
router.put('/subjects/:id', protect, authorize('admin'), updateSubject);
router.delete('/subjects/:id', protect, authorize('admin'), deleteSubject);

module.exports = router;
