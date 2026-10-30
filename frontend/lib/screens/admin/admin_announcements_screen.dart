import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/academic_models.dart';
import '../../providers/academic_provider.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../widgets/status_badge.dart';

class AdminAnnouncementsScreen extends StatelessWidget {
  const AdminAnnouncementsScreen({Key? key}) : super(key: key);

  void _showAddAnnouncementDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    String priority = 'high';
    String audience = 'all';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Publish Campus Announcement', style: TextStyle(fontWeight: FontWeight.w700)),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
                const SizedBox(height: 12),
                TextFormField(controller: contentCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Notice Content')),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: priority,
                        decoration: const InputDecoration(labelText: 'Priority Level'),
                        items: const [
                          DropdownMenuItem(value: 'low', child: Text('Low')),
                          DropdownMenuItem(value: 'medium', child: Text('Medium')),
                          DropdownMenuItem(value: 'high', child: Text('High')),
                          DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                        ],
                        onChanged: (v) => setState(() => priority = v!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: audience,
                        decoration: const InputDecoration(labelText: 'Target Audience'),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All Campus')),
                          DropdownMenuItem(value: 'student', child: Text('Students Only')),
                          DropdownMenuItem(value: 'faculty', child: Text('Faculty Only')),
                        ],
                        onChanged: (v) => setState(() => audience = v!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final academic = Provider.of<AcademicProvider>(context, listen: false);
                academic.addAnnouncement(
                  AnnouncementModel(
                    id: 'ann-${DateTime.now().millisecondsSinceEpoch}',
                    title: titleCtrl.text.trim(),
                    content: contentCtrl.text.trim(),
                    priority: priority,
                    targetAudience: audience,
                    authorName: 'College Administration',
                    date: DateTime.now().toString().split(' ')[0],
                  ),
                );
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notice broadcasted successfully'), backgroundColor: AppColors.success),
                );
              },
              child: const Text('Broadcast Notice'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final academic = Provider.of<AcademicProvider>(context);
    final announcements = academic.announcements;

    return ResponsiveScaffold(
      currentRoute: '/admin/announcements',
      pageTitle: 'Campus Circulars & Announcements',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Active Public Notices', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ElevatedButton.icon(
                onPressed: () => _showAddAnnouncementDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Create Announcement'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: announcements.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, index) {
              final a = announcements[index];
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            StatusBadge(status: a.priority),
                            const SizedBox(width: 10),
                            Text(
                              'Audience: ${a.targetAudience.toUpperCase()}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        Text(a.date, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(a.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    Text(a.content, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
                    const SizedBox(height: 12),
                    Text('Issued by: ${a.authorName}', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.textMuted)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
