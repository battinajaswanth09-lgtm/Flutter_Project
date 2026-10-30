import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/academic_models.dart';
import '../../providers/academic_provider.dart';
import '../../widgets/responsive_scaffold.dart';

class StudentAssignmentsScreen extends StatelessWidget {
  const StudentAssignmentsScreen({Key? key}) : super(key: key);

  void _showSubmitModal(BuildContext context, AssignmentModel asg) {
    final linkCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Submit ${asg.title}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        content: SizedBox(
          width: 460,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: linkCtrl, decoration: const InputDecoration(labelText: 'Project Repository / Google Drive URL', prefixIcon: Icon(Icons.link, size: 20))),
              const SizedBox(height: 12),
              TextFormField(controller: notesCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Submission Notes / Comments')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coursework submitted successfully to faculty!'), backgroundColor: AppColors.success),
              );
            },
            child: const Text('Submit Assignment'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final academic = Provider.of<AcademicProvider>(context);
    final assignments = academic.assignments;

    return ResponsiveScaffold(
      currentRoute: '/student/assignments',
      pageTitle: 'Coursework & Project Submissions',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Assigned Homework, Labs & Projects', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: assignments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (ctx, index) {
              final asg = assignments[index];
              return Container(
                padding: const EdgeInsets.all(22),
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                          child: Text(asg.subjectCode, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                        ),
                        Text('Deadline: ${asg.dueDate}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.warning)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(asg.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(asg.description, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Faculty: ${asg.facultyName} • Points: ${asg.totalMarks}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textMuted)),
                        ElevatedButton.icon(
                          onPressed: () => _showSubmitModal(context, asg),
                          icon: const Icon(Icons.upload_file, size: 16),
                          label: const Text('Turn In Assignment'),
                        ),
                      ],
                    ),
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
