const Department = require('../models/Department');

// @desc    Get all departments
// @route   GET /api/departments
// @access  Public / Private
exports.getDepartments = async (req, res, next) => {
  try {
    const departments = await Department.find().sort({ name: 1 });
    res.status(200).json({
      success: true,
      count: departments.length,
      data: departments,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Create department
// @route   POST /api/departments
// @access  Private (Admin)
exports.createDepartment = async (req, res, next) => {
  try {
    const department = await Department.create(req.body);
    res.status(201).json({
      success: true,
      message: 'Department created successfully',
      data: department,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Update department
// @route   PUT /api/departments/:id
// @access  Private (Admin)
exports.updateDepartment = async (req, res, next) => {
  try {
    const department = await Department.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });
    if (!department) {
      return res.status(404).json({ success: false, message: 'Department not found' });
    }
    res.status(200).json({
      success: true,
      message: 'Department updated successfully',
      data: department,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Delete department
// @route   DELETE /api/departments/:id
// @access  Private (Admin)
exports.deleteDepartment = async (req, res, next) => {
  try {
    const department = await Department.findByIdAndDelete(req.params.id);
    if (!department) {
      return res.status(404).json({ success: false, message: 'Department not found' });
    }
    res.status(200).json({
      success: true,
      message: 'Department deleted successfully',
    });
  } catch (err) {
    next(err);
  }
};

