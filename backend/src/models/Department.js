const mongoose = require('mongoose');

const DepartmentSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Please provide department name'],
      unique: true,
      trim: true,
    },
    code: {
      type: String,
      required: [true, 'Please provide department code (e.g. CSE, EEE)'],
      unique: true,
      uppercase: true,
      trim: true,
    },
    description: {
      type: String,
      default: '',
    },
    headOfDepartment: {
      type: String,
      default: 'To Be Assigned',
    },
    establishedYear: {
      type: Number,
      default: new Date().getFullYear(),
    },
    contactEmail: {
      type: String,
      default: '',
    },
    phone: {
      type: String,
      default: '',
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Department', DepartmentSchema);

