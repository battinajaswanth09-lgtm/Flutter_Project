import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/student_model.dart';
import '../../providers/student_provider.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../widgets/search_filter_bar.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/confirm_dialog.dart';

class AdminStudentsScreen extends StatelessWidget {
  const AdminStudentsScreen({Key? key}) : super(key: key);

  void _showStudentDialog(BuildContext context, {StudentModel? studentToEdit}) {
    final isEditing = studentToEdit != null;
    final nameCtrl = TextEditingController(text: studentToEdit?.name ?? '');
    final emailCtrl = TextEditingController(text: studentToEdit?.email ?? '');
    final rollCtrl = TextEditingController(text: studentToEdit?.rollNumber ?? '');
    final deptCtrl = TextEditingController(text: studentToEdit?.departmentCode ?? 'CSE');
    final semCtrl = TextEditingController(text: (studentToEdit?.semester ?? 1).toString());
    final secCtrl = TextEditingController(text: studentToEdit?.section ?? 'A');
    final cgpaCtrl = TextEditingController(text: (studentToEdit?.cgpa ?? 8.0).toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isEditing ? 'Edit Student Details' : 'Add New Student Record', style: const TextStyle(fontWeight: FontWeight.w700)),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Student Full Name')),
                const SizedBox(height: 12),
                TextFormField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email Address')),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TextFormField(controller: rollCtrl, decoration: const InputDecoration(labelText: 'Roll Number'))),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(controller: deptCtrl, decoration: const InputDecoration(labelText: 'Department (CSE/ECE)'))),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TextFormField(controller: semCtrl, decoration: const InputDecoration(labelText: 'Semester (1-8)'))),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(controller: secCtrl, decoration: const InputDecoration(labelText: 'Section (A/B)'))),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(controller: cgpaCtrl, decoration: const InputDecoration(labelText: 'CGPA'))),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final studentProvider = Provider.of<StudentProvider>(context, listen: false);
              final updated = StudentModel(
                id: isEditing ? studentToEdit.id : 'std-${DateTime.now().millisecondsSinceEpoch}',
                userId: isEditing ? studentToEdit.userId : 'usr-${DateTime.now().millisecondsSinceEpoch}',
                name: nameCtrl.text.trim(),
                email: emailCtrl.text.trim(),
                avatar: isEditing ? studentToEdit.avatar : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80',
                rollNumber: rollCtrl.text.trim(),
                departmentId: 'dept-01',
                departmentName: deptCtrl.text.trim() == 'ECE' ? 'Electronics & Comm.' : 'Computer Science',
                departmentCode: deptCtrl.text.trim().toUpperCase(),
                courseId: 'crs-01',
                courseTitle: 'Bachelor of Technology',
                semester: int.tryParse(semCtrl.text) ?? 1,
                section: secCtrl.text.trim().toUpperCase(),
                cgpa: double.tryParse(cgpaCtrl.text) ?? 8.0,
                overallAttendance: isEditing ? studentToEdit.overallAttendance : 85.0,
              );

              if (isEditing) {
                studentProvider.updateStudent(updated);
              } else {
                studentProvider.addStudent(updated);
              }
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isEditing ? 'Student updated' : 'Student added successfully'), backgroundColor: AppColors.success),
              );
            },
            child: Text(isEditing ? 'Save Changes' : 'Create Student'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    final students = studentProvider.students;

    return ResponsiveScaffold(
      currentRoute: '/admin/students',
      pageTitle: 'Student Directory & Admissions',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchFilterBar(
            hintText: 'Search by student name, roll number...',
            onSearchChanged: studentProvider.setSearchQuery,
            selectedDepartment: studentProvider.selectedDepartment,
            onDepartmentChanged: studentProvider.setDepartmentFilter,
            onAddNew: () => _showStudentDialog(context),
            addNewLabel: 'Add Student',
          ),
          const SizedBox(height: 20),

          // Data Table
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Students: ${students.length}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const Text(
                        'Showing active enrollment',
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    horizontalMargin: 20,
                    columnSpacing: 28,
                    columns: const [
                      DataColumn(label: Text('Student', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Roll Number', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Department', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Class', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Attendance', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('CGPA', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.w700))),
                    ],
                    rows: students.map((s) {
                      final isShortage = s.overallAttendance < 75.0;

                      return DataRow(
                        cells: [
                          DataCell(
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: NetworkImage(s.avatar),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(s.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                    Text(s.email, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          DataCell(Text(s.rollNumber, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(s.departmentCode, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 11)),
                            ),
                          ),
                          DataCell(Text('Sem ${s.semester} - Sec ${s.section}', style: const TextStyle(fontSize: 12))),
                          DataCell(
                            Row(
                              children: [
                                Text(
                                  '${s.overallAttendance}%',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: isShortage ? AppColors.danger : AppColors.success,
                                  ),
                                ),
                                if (isShortage) ...[
                                  const SizedBox(width: 4),
                                  const Icon(Icons.warning_amber, size: 14, color: AppColors.danger),
                                ],
                              ],
                            ),
                          ),
                          DataCell(Text('${s.cgpa}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                          DataCell(StatusBadge(status: s.status)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                                  tooltip: 'Edit Student',
                                  onPressed: () => _showStudentDialog(context, studentToEdit: s),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
                                  tooltip: 'Delete Student',
                                  onPressed: () async {
                                    final confirm = await ConfirmDialog.show(
                                      context,
                                      title: 'Delete Student Record?',
                                      message: 'Are you sure you want to permanently remove ${s.name} (${s.rollNumber})? This will delete associated academic and fee records.',
                                    );
                                    if (confirm) {
                                      studentProvider.deleteStudent(s.id);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
