const mongoose = require('mongoose');

const FeeSchema = new mongoose.Schema(
  {
    student: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Student',
      required: true,
    },
    title: {
      type: String,
      default: 'Semester Tuition Fee',
    },
    academicYear: {
      type: String,
      default: '2025-2026',
    },
    semester: {
      type: Number,
      required: true,
    },
    feeType: {
      type: String,
      enum: ['Tuition', 'Hostel', 'Examination', 'Library', 'Transport', 'Laboratory', 'Other'],
      default: 'Tuition',
    },
    totalAmount: {
      type: Number,
      required: true,
    },
    paidAmount: {
      type: Number,
      default: 0,
    },
    dueDate: {
      type: Date,
      required: true,
    },
    paidDate: {
      type: Date,
    },
    paymentMethod: {
      type: String,
      enum: ['Online / UPI', 'Credit/Debit Card', 'Bank Transfer', 'Cash', 'Cheque', 'None'],
      default: 'None',
    },
    transactionId: {
      type: String,
      default: '',
    },
    status: {
      type: String,
      enum: ['Paid', 'Pending', 'Partial', 'Overdue'],
      default: 'Pending',
    },
    receiptNumber: {
      type: String,
      default: '',
    },
  },
  { timestamps: true }
);

FeeSchema.pre('save', function (next) {
  if (this.paidAmount >= this.totalAmount) {
    this.status = 'Paid';
  } else if (this.paidAmount > 0 && this.paidAmount < this.totalAmount) {
    this.status = 'Partial';
  } else if (this.dueDate && new Date() > this.dueDate && this.paidAmount === 0) {
    this.status = 'Overdue';
  } else {
    this.status = 'Pending';
  }
  next();
});

module.exports = mongoose.model('Fee', FeeSchema);
