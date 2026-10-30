const mongoose = require('mongoose');

const StudentSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      unique: true,
    },
    rollNumber: {
      type: String,
      required: [true, 'Please provide student roll number'],
      unique: true,
      uppercase: true,
      trim: true,
    },
    registrationNumber: {
      type: String,
      unique: true,
      sparse: true,
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
      required: true,
    },
    semester: {
      type: Number,
      required: true,
      min: 1,
      max: 12,
      default: 1,
    },
    section: {
      type: String,
      default: 'A',
      uppercase: true,
      trim: true,
    },
    batchYear: {
      type: String,
      default: '2023-2027',
    },
    gender: {
      type: String,
      enum: ['Male', 'Female', 'Other'],
      default: 'Male',
    },
    dateOfBirth: {
      type: Date,
    },
    bloodGroup: {
      type: String,
      default: 'O+',
    },
    address: {
      type: String,
      default: '',
    },
    guardianName: {
      type: String,
      default: '',
    },
    guardianPhone: {
      type: String,
      default: '',
    },
    overallAttendance: {
      type: Number,
      default: 85.0,
      min: 0,
      max: 100,
    },
    cgpa: {
      type: Number,
      default: 8.4,
      min: 0,
      max: 10,
    },
    status: {
      type: String,
      enum: ['Active', 'Suspended', 'Alumni', 'Dropped'],
      default: 'Active',
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Student', StudentSchema);
