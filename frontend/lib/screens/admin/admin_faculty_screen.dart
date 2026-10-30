import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/faculty_model.dart';
import '../../providers/faculty_provider.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../widgets/search_filter_bar.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/confirm_dialog.dart';

class AdminFacultyScreen extends StatelessWidget {
  const AdminFacultyScreen({Key? key}) : super(key: key);

  void _showFacultyDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final empCtrl = TextEditingController();
    final deptCtrl = TextEditingController(text: 'CSE');
    final desigCtrl = TextEditingController(text: 'Assistant Professor');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Faculty Member', style: TextStyle(fontWeight: FontWeight.w700)),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Faculty Full Name')),
              const SizedBox(height: 12),
              TextFormField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Institutional Email')),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: empCtrl, decoration: const InputDecoration(labelText: 'Employee ID'))),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(controller: deptCtrl, decoration: const InputDecoration(labelText: 'Department (CSE/ECE)'))),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(controller: desigCtrl, decoration: const InputDecoration(labelText: 'Designation')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final fac = FacultyModel(
                id: 'fac-${DateTime.now().millisecondsSinceEpoch}',
                userId: 'usr-${DateTime.now().millisecondsSinceEpoch}',
                name: nameCtrl.text.trim(),
                email: emailCtrl.text.trim(),
                avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=250&q=80',
                employeeId: empCtrl.text.trim().toUpperCase(),
                departmentId: 'dept-01',
                departmentName: 'Computer Science',
                departmentCode: deptCtrl.text.trim().toUpperCase(),
                designation: desigCtrl.text.trim(),
                qualification: 'M.Tech / Ph.D',
                specialization: 'Computing Systems',
                experienceYears: 4,
              );
              Provider.of<FacultyProvider>(context, listen: false).addFaculty(fac);
              Navigator.of(ctx).pop();
            },
            child: const Text('Add Faculty'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final facultyProvider = Provider.of<FacultyProvider>(context);
    final facultyList = facultyProvider.facultyList;

    return ResponsiveScaffold(
      currentRoute: '/admin/faculty',
      pageTitle: 'Faculty & Academic Staff',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchFilterBar(
            hintText: 'Search by professor name, employee ID, designation...',
            onSearchChanged: facultyProvider.setSearchQuery,
            selectedDepartment: facultyProvider.selectedDepartment,
            onDepartmentChanged: facultyProvider.setDepartmentFilter,
            onAddNew: () => _showFacultyDialog(context),
            addNewLabel: 'Add Faculty',
          ),
          const SizedBox(height: 20),

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
                        'Total Faculty Members: ${facultyList.length}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const Text('Academic Staff Directory', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
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
                      DataColumn(label: Text('Faculty Member', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Employee ID', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Department', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Designation', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Qualification', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Experience', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Assigned Subjects', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.w700))),
                    ],
                    rows: facultyList.map((f) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Row(
                              children: [
                                CircleAvatar(radius: 16, backgroundImage: NetworkImage(f.avatar)),
                                const SizedBox(width: 12),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(f.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                    Text(f.email, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          DataCell(Text(f.employeeId, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0EA5E9).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(f.departmentCode, style: const TextStyle(color: Color(0xFF0EA5E9), fontWeight: FontWeight.w700, fontSize: 11)),
                            ),
                          ),
                          DataCell(Text(f.designation, style: const TextStyle(fontSize: 12))),
                          DataCell(Text(f.qualification, style: const TextStyle(fontSize: 12))),
                          DataCell(Text('${f.experienceYears} Years', style: const TextStyle(fontSize: 12))),
                          DataCell(
                            Text(
                              f.assignedSubjects.isNotEmpty ? f.assignedSubjects.join(', ') : 'None assigned',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
                              onPressed: () async {
                                final confirm = await ConfirmDialog.show(
                                  context,
                                  title: 'Delete Faculty Record?',
                                  message: 'Are you sure you want to remove ${f.name}?',
                                );
                                if (confirm) {
                                  facultyProvider.deleteFaculty(f.id);
                                }
                              },
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
