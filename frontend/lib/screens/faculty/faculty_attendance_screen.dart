import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/academic_provider.dart';
import '../../providers/student_provider.dart';
import '../../widgets/responsive_scaffold.dart';

class FacultyAttendanceScreen extends StatefulWidget {
  const FacultyAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<FacultyAttendanceScreen> createState() => _FacultyAttendanceScreenState();
}

class _FacultyAttendanceScreenState extends State<FacultyAttendanceScreen> {
  String _selectedSubject = 'Data Structures and Algorithms (CS301)';
  String _selectedSection = 'Semester 5 - Section A';
  DateTime _selectedDate = DateTime.now();

  void _markAllPresent(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context, listen: false);
    final academic = Provider.of<AcademicProvider>(context, listen: false);
    for (var s in studentProvider.students) {
      academic.setStudentAttendanceStatus(s.id, 'Present');
    }
  }

  void _saveAttendance() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Attendance recorded and synced to student academic records successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    final academic = Provider.of<AcademicProvider>(context);
    final students = studentProvider.students;
    final sheet = academic.attendanceSheet;

    return ResponsiveScaffold(
      currentRoute: '/faculty/attendance',
      pageTitle: 'Daily Attendance Management',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Controls Card
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
                    value: _selectedSubject,
                    decoration: const InputDecoration(labelText: 'Subject Course'),
                    items: const [
                      DropdownMenuItem(value: 'Data Structures and Algorithms (CS301)', child: Text('Data Structures & Algorithms (CS301)')),
                      DropdownMenuItem(value: 'Computer Networks (CS303)', child: Text('Computer Networks (CS303)')),
                    ],
                    onChanged: (v) => setState(() => _selectedSubject = v!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedSection,
                    decoration: const InputDecoration(labelText: 'Class Section'),
                    items: const [
                      DropdownMenuItem(value: 'Semester 5 - Section A', child: Text('Semester 5 - Section A')),
                      DropdownMenuItem(value: 'Semester 5 - Section B', child: Text('Semester 5 - Section B')),
                    ],
                    onChanged: (v) => setState(() => _selectedSection = v!),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                  onPressed: () => _markAllPresent(context),
                  icon: const Icon(Icons.done_all, size: 18),
                  label: const Text('Mark All Present'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Attendance Marking Table
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Student Attendance Roster (${students.length} Students)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text('Date: ${_selectedDate.toString().split(" ")[0]} • Tap status to update student record', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: _saveAttendance,
                        icon: const Icon(Icons.save_outlined, size: 18),
                        label: const Text('Save & Submit Attendance'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: students.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, index) {
                    final s = students[index];
                    final currentStatus = sheet[s.id] ?? 'Present';

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          CircleAvatar(radius: 18, backgroundImage: NetworkImage(s.avatar)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                                Text('${s.rollNumber} • Sec ${s.section}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              _attendanceChoiceChip(academic, s.id, 'Present', currentStatus == 'Present', AppColors.success),
                              const SizedBox(width: 8),
                              _attendanceChoiceChip(academic, s.id, 'Absent', currentStatus == 'Absent', AppColors.danger),
                              const SizedBox(width: 8),
                              _attendanceChoiceChip(academic, s.id, 'Late', currentStatus == 'Late', AppColors.warning),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendanceChoiceChip(AcademicProvider academic, String studentId, String status, bool isSelected, Color color) {
    return InkWell(
      onTap: () => academic.setStudentAttendanceStatus(studentId, status),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
