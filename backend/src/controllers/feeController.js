const Fee = require('../models/Fee');
const Student = require('../models/Student');

// @desc    Get all fees (Admin)
// @route   GET /api/fees
// @access  Private (Admin)
exports.getAllFees = async (req, res, next) => {
  try {
    const { status, semester } = req.query;
    const query = {};
    if (status) query.status = status;
    if (semester) query.semester = Number(semester);

    const fees = await Fee.find(query)
      .populate({
        path: 'student',
        populate: [
          { path: 'user', select: 'name email rollNumber' },
          { path: 'department', select: 'name code' },
        ],
      })
      .sort({ dueDate: 1 });

    res.status(200).json({ success: true, count: fees.length, data: fees });
  } catch (err) {
    next(err);
  }
};

// @desc    Get fees for a student
// @route   GET /api/fees/student/:studentId
// @access  Private
exports.getStudentFees = async (req, res, next) => {
  try {
    const fees = await Fee.find({ student: req.params.studentId }).sort({ dueDate: 1 });
    res.status(200).json({ success: true, data: fees });
  } catch (err) {
    next(err);
  }
};

// @desc    Create fee invoice (Admin)
// @route   POST /api/fees
// @access  Private (Admin)
exports.createFee = async (req, res, next) => {
  try {
    const fee = await Fee.create(req.body);
    res.status(201).json({ success: true, data: fee });
  } catch (err) {
    next(err);
  }
};

// @desc    Pay fee / record payment
// @route   POST /api/fees/:id/pay
// @access  Private
exports.payFee = async (req, res, next) => {
  try {
    const { amount, paymentMethod, transactionId } = req.body;
    const fee = await Fee.findById(req.params.id);

    if (!fee) {
      return res.status(404).json({ success: false, message: 'Fee invoice not found' });
    }

    fee.paidAmount = (fee.paidAmount || 0) + Number(amount);
    fee.paymentMethod = paymentMethod || 'Online / UPI';
    fee.transactionId = transactionId || `TXN-${Date.now()}`;
    fee.paidDate = new Date();
    fee.receiptNumber = `REC-${Math.floor(100000 + Math.random() * 900000)}`;

    await fee.save();

    res.status(200).json({
      success: true,
      message: 'Payment recorded successfully',
      data: fee,
    });
  } catch (err) {
    next(err);
  }
};

