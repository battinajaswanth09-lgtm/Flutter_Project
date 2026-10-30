const mongoose = require('mongoose');

const SubmissionSchema = new mongoose.Schema({
  student: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Student',
    required: true,
  },
  submissionDate: {
    type: Date,
    default: Date.now,
  },
  fileUrl: {
    type: String,
    default: '',
  },
  notes: {
    type: String,
    default: '',
  },
  marksAwarded: {
    type: Number,
  },
  feedback: {
    type: String,
    default: '',
  },
  status: {
    type: String,
    enum: ['Submitted', 'Graded', 'Late', 'Resubmission Requested'],
    default: 'Submitted',
  },
});

const AssignmentSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: [true, 'Please provide assignment title'],
      trim: true,
    },
    description: {
      type: String,
      required: true,
    },
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
    semester: {
      type: Number,
      required: true,
    },
    section: {
      type: String,
      default: 'A',
    },
    totalMarks: {
      type: Number,
      default: 20,
    },
    dueDate: {
      type: Date,
      required: true,
    },
    attachmentUrl: {
      type: String,
      default: '',
    },
    submissions: [SubmissionSchema],
  },
  { timestamps: true }
);

module.exports = mongoose.model('Assignment', AssignmentSchema);
