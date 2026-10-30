import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/student_provider.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../widgets/status_badge.dart';

class FacultyMarksScreen extends StatefulWidget {
  const FacultyMarksScreen({Key? key}) : super(key: key);

  @override
  State<FacultyMarksScreen> createState() => _FacultyMarksScreenState();
}

class _FacultyMarksScreenState extends State<FacultyMarksScreen> {
  String _selectedExam = 'Semester 5 Mid-Term Examinations';
  String _selectedSubject = 'Data Structures and Algorithms (CS301)';
  final Map<String, TextEditingController> _marksControllers = {};

  @override
  void initState() {
    super.initState();
    final students = Provider.of<StudentProvider>(context, listen: false).students;
    for (var s in students) {
      _marksControllers[s.id] = TextEditingController(text: '88');
    }
  }

  @override
  void dispose() {
    for (var ctrl in _marksControllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _submitMarks() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Marks uploaded and grades computed successfully!'), backgroundColor: AppColors.success),
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    final students = studentProvider.students;

    return ResponsiveScaffold(
      currentRoute: '/faculty/marks',
      pageTitle: 'Upload Examination Marks & Grades',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedExam,
                    decoration: const InputDecoration(labelText: 'Examination'),
                    items: const [
                      DropdownMenuItem(value: 'Semester 5 Mid-Term Examinations', child: Text('Semester 5 Mid-Term Examinations')),
                      DropdownMenuItem(value: 'Semester 5 Lab Practical Assessment', child: Text('Semester 5 Lab Practical Assessment')),
                    ],
                    onChanged: (v) => setState(() => _selectedExam = v!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedSubject,
                    decoration: const InputDecoration(labelText: 'Subject'),
                    items: const [
                      DropdownMenuItem(value: 'Data Structures and Algorithms (CS301)', child: Text('Data Structures & Algorithms (CS301)')),
                      DropdownMenuItem(value: 'Computer Networks (CS303)', child: Text('Computer Networks (CS303)')),
                    ],
                    onChanged: (v) => setState(() => _selectedSubject = v!),
                  ),
                ),
              ],
            ),
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
                      const Text('Student Marks Entry (Max Marks: 100)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      ElevatedButton.icon(
                        onPressed: _submitMarks,
                        icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                        label: const Text('Save & Publish Marks'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    horizontalMargin: 20,
                    columnSpacing: 30,
                    columns: const [
                      DataColumn(label: Text('Student', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Roll Number', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Marks Obtained (out of 100)', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Grade', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Result', style: TextStyle(fontWeight: FontWeight.w700))),
                    ],
                    rows: students.map((s) {
                      final ctrl = _marksControllers[s.id] ?? TextEditingController(text: '85');
                      final marks = double.tryParse(ctrl.text) ?? 85.0;
                      final grade = marks >= 90 ? 'A+' : (marks >= 80 ? 'A' : (marks >= 70 ? 'B' : (marks >= 60 ? 'C' : 'D')));
                      final status = marks >= 40 ? 'Pass' : 'Fail';

                      return DataRow(
                        cells: [
                          DataCell(
                            Row(
                              children: [
                                CircleAvatar(radius: 16, backgroundImage: NetworkImage(s.avatar)),
                                const SizedBox(width: 10),
                                Text(s.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          DataCell(Text(s.rollNumber)),
                          DataCell(
                            SizedBox(
                              width: 100,
                              child: TextFormField(
                                controller: ctrl,
                                keyboardType: TextInputType.number,
                                onChanged: (v) => setState(() {}),
                                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                              ),
                            ),
                          ),
                          DataCell(
                            Text(grade, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 13)),
                          ),
                          DataCell(StatusBadge(status: status)),
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

