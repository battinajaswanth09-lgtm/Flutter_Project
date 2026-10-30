const mongoose = require('mongoose');

const SubjectSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Please provide subject name (e.g. Data Structures & Algorithms)'],
      trim: true,
    },
    code: {
      type: String,
      required: [true, 'Please provide subject code (e.g. CS301)'],
      unique: true,
      uppercase: true,
      trim: true,
    },
    department: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Department',
      required: true,
    },
    course: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Course',
    },
    semester: {
      type: Number,
      required: true,
      min: 1,
      max: 12,
    },
    credits: {
      type: Number,
      default: 4,
    },
    faculty: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Faculty',
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Subject', SubjectSchema);
