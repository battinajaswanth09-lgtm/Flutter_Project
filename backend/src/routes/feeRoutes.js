const express = require('express');
const router = express.Router();
const {
  getAllFees,
  getStudentFees,
  createFee,
  payFee,
} = require('../controllers/feeController');
const { protect, authorize } = require('../middleware/auth');

router.use(protect);

router.get('/', authorize('admin'), getAllFees);
router.get('/student/:studentId', getStudentFees);
router.post('/', authorize('admin'), createFee);
router.post('/:id/pay', payFee);

module.exports = router;

