const Announcement = require('../models/Announcement');

// @desc    Get announcements for audience
// @route   GET /api/announcements
// @access  Public / Private
exports.getAnnouncements = async (req, res, next) => {
  try {
    const role = req.user ? req.user.role : 'all';
    const query = {
      isActive: true,
      targetAudience: { $in: ['all', role] },
    };

    const announcements = await Announcement.find(query)
      .sort({ createdAt: -1 })
      .populate('author', 'name role avatar');

    res.status(200).json({ success: true, count: announcements.length, data: announcements });
  } catch (err) {
    next(err);
  }
};

// @desc    Create announcement
// @route   POST /api/announcements
// @access  Private (Admin, Faculty)
exports.createAnnouncement = async (req, res, next) => {
  try {
    const { title, content, targetAudience, priority, expiresAt } = req.body;

    const announcement = await Announcement.create({
      title,
      content,
      targetAudience: targetAudience || 'all',
      priority: priority || 'medium',
      author: req.user._id,
      authorName: req.user.name,
      expiresAt,
    });

    res.status(201).json({ success: true, data: announcement });
  } catch (err) {
    next(err);
  }
};

// @desc    Delete announcement
// @route   DELETE /api/announcements/:id
// @access  Private (Admin)
exports.deleteAnnouncement = async (req, res, next) => {
  try {
    const announcement = await Announcement.findByIdAndDelete(req.params.id);
    if (!announcement) {
      return res.status(404).json({ success: false, message: 'Announcement not found' });
    }
    res.status(200).json({ success: true, message: 'Announcement removed' });
  } catch (err) {
    next(err);
  }
};

