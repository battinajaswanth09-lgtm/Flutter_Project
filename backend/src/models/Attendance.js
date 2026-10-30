const mongoose = require('mongoose');

const AttendanceRecordSchema = new mongoose.Schema({
  student: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Student',
    required: true,
  },
  status: {
    type: String,
    enum: ['Present', 'Absent', 'Late', 'Excused'],
    default: 'Present',
  },
  remarks: {
    type: String,
    default: '',
  },
});

const AttendanceSchema = new mongoose.Schema(
  {
    subject: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Subject',
      required: true,
    },
    faculty: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Faculty',
      required: true,
    },
    department: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Department',
      required: true,
    },
    date: {
      type: Date,
      default: Date.now,
      required: true,
    },
    semester: {
      type: Number,
      required: true,
    },
    section: {
      type: String,
      required: true,
    },
    records: [AttendanceRecordSchema],
  },
  { timestamps: true }
);

module.exports = mongoose.model('Attendance', AttendanceSchema);

