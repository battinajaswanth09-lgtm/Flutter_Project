const mongoose = require('mongoose');

const ExaminationSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: [true, 'Please provide exam title'],
      trim: true,
    },
    examCode: {
      type: String,
      required: true,
      unique: true,
      uppercase: true,
    },
    examType: {
      type: String,
      enum: ['Midterm', 'Final', 'Quiz', 'Internal Assessment', 'Practical'],
      default: 'Final',
    },
    academicYear: {
      type: String,
      default: '2025-2026',
    },
    semester: {
      type: Number,
      required: true,
    },
    department: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Department',
      required: true,
    },
    startDate: {
      type: Date,
      required: true,
    },
    endDate: {
      type: Date,
      required: true,
    },
    status: {
      type: String,
      enum: ['Upcoming', 'Ongoing', 'Completed', 'Results Published'],
      default: 'Upcoming',
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Examination', ExaminationSchema);
