const mongoose = require('mongoose');

const FacultySchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      unique: true,
    },
    employeeId: {
      type: String,
      required: [true, 'Please provide an Employee ID'],
      unique: true,
      uppercase: true,
      trim: true,
    },
    department: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Department',
      required: true,
    },
    designation: {
      type: String,
      default: 'Assistant Professor',
      enum: ['Professor', 'Associate Professor', 'Assistant Professor', 'Lecturer', 'Head of Department', 'Lab Assistant'],
    },
    qualification: {
      type: String,
      default: 'M.Tech / Ph.D',
    },
    joiningDate: {
      type: Date,
      default: Date.now,
    },
    specialization: {
      type: String,
      default: 'Computer Engineering',
    },
    assignedSubjects: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Subject',
      },
    ],
    assignedClasses: [
      {
        semester: Number,
        section: String,
      },
    ],
    experienceYears: {
      type: Number,
      default: 3,
    },
    salaryStatus: {
      type: String,
      enum: ['Paid', 'Pending'],
      default: 'Paid',
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Faculty', FacultySchema);
