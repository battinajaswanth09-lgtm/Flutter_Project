import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/academic_models.dart';
import '../../providers/academic_provider.dart';
import '../../widgets/responsive_scaffold.dart';

class FacultyAssignmentsScreen extends StatelessWidget {
  const FacultyAssignmentsScreen({Key? key}) : super(key: key);

  void _showAddAssignmentDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final marksCtrl = TextEditingController(text: '25');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Publish Course Assignment', style: TextStyle(fontWeight: FontWeight.w700)),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Assignment Title')),
              const SizedBox(height: 12),
              TextFormField(controller: descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Instructions / Requirements')),
              const SizedBox(height: 12),
              TextFormField(controller: marksCtrl, decoration: const InputDecoration(labelText: 'Maximum Points / Marks')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final academic = Provider.of<AcademicProvider>(context, listen: false);
              academic.addAssignment(
                AssignmentModel(
                  id: 'asg-${DateTime.now().millisecondsSinceEpoch}',
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  subjectName: 'Data Structures and Algorithms',
                  subjectCode: 'CS301',
                  facultyName: 'Prof. Robert C. Martin',
                  totalMarks: int.tryParse(marksCtrl.text) ?? 20,
                  dueDate: '2025-11-25',
                ),
              );
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Assignment published to students!'), backgroundColor: AppColors.success),
              );
            },
            child: const Text('Publish Assignment'),
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
      currentRoute: '/faculty/assignments',
      pageTitle: 'Coursework & Assignments',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Active Course Assignments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ElevatedButton.icon(
                onPressed: () => _showAddAssignmentDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Assignment'),
              ),
            ],
          ),
          const SizedBox(height: 20),

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
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(asg.subjectCode, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                        ),
                        Text('Due Date: ${asg.dueDate}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.warning)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(asg.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(asg.description, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Max Marks: ${asg.totalMarks} Points', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                        OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('38 of 42 student submissions received.')),
                            );
                          },
                          icon: const Icon(Icons.folder_shared_outlined, size: 16),
                          label: const Text('View 38 Submissions', style: TextStyle(fontSize: 12)),
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
