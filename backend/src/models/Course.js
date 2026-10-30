const mongoose = require('mongoose');

const CourseSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: [true, 'Please provide course title (e.g. B.Tech Computer Science)'],
      trim: true,
    },
    code: {
      type: String,
      required: [true, 'Please provide course code (e.g. BT-CSE)'],
      unique: true,
      uppercase: true,
      trim: true,
    },
    department: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Department',
      required: [true, 'Course must belong to a department'],
    },
    durationYears: {
      type: Number,
      default: 4,
    },
    totalSemesters: {
      type: Number,
      default: 8,
    },
    credits: {
      type: Number,
      default: 160,
    },
    description: {
      type: String,
      default: '',
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Course', CourseSchema);
