const mongoose = require('mongoose');

const ResultSchema = new mongoose.Schema(
  {
    examination: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Examination',
      required: true,
    },
    student: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Student',
      required: true,
    },
    subject: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Subject',
      required: true,
    },
    marksObtained: {
      type: Number,
      required: true,
      min: 0,
    },
    maxMarks: {
      type: Number,
      default: 100,
    },
    grade: {
      type: String,
      default: 'A',
    },
    percentage: {
      type: Number,
    },
    status: {
      type: String,
      enum: ['Pass', 'Fail', 'Absent'],
      default: 'Pass',
    },
    remarks: {
      type: String,
      default: 'Good performance',
    },
  },
  { timestamps: true }
);

ResultSchema.pre('save', function (next) {
  if (this.marksObtained != null && this.maxMarks != null && this.maxMarks > 0) {
    this.percentage = Math.round((this.marksObtained / this.maxMarks) * 100);
    if (this.percentage >= 90) this.grade = 'A+';
    else if (this.percentage >= 80) this.grade = 'A';
    else if (this.percentage >= 70) this.grade = 'B';
    else if (this.percentage >= 60) this.grade = 'C';
    else if (this.percentage >= 50) this.grade = 'D';
    else this.grade = 'F';

    this.status = this.percentage >= 40 ? 'Pass' : 'Fail';
  }
  next();
});

module.exports = mongoose.model('Result', ResultSchema);
