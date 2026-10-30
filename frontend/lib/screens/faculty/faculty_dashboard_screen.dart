import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/academic_provider.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../widgets/stat_card.dart';

class FacultyDashboardScreen extends StatelessWidget {
  const FacultyDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;
    final academic = Provider.of<AcademicProvider>(context);

    return ResponsiveScaffold(
      currentRoute: '/faculty/dashboard',
      pageTitle: 'Faculty Instruction Portal',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Banner
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    user?.avatar ??
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=250&q=80',
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, ${user?.name ?? "Professor"}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Department of Computer Science & Engineering • Academic Term 2025-26',
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/faculty/attendance'),
                  icon: const Icon(Icons.check_box, size: 18),
                  label: const Text('Take Attendance Now'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stat Cards
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Assigned Subjects',
                  value: '3 Courses',
                  icon: Icons.menu_book,
                  color: AppColors.primary,
                  subtitle: 'DSA, Networks, Computing Lab',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'Assigned Class Sections',
                  value: 'Semester 5-A',
                  icon: Icons.groups,
                  color: const Color(0xFF0EA5E9),
                  subtitle: '42 Enrolled Students',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'Active Assignments',
                  value: '${academic.assignments.length}',
                  icon: Icons.assignment_turned_in,
                  color: AppColors.success,
                  trend: 'Submissions ongoing',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Next lectures & Announcements
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Today's Lecture Schedule", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 16),
                      ...academic.timetable.map((period) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  period.startTime,
                                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(period.subjectName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                    Text('${period.subjectCode} • ${period.roomNumber}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                  ],
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () => Navigator.of(context).pushReplacementNamed('/faculty/attendance'),
                                child: const Text('Log Attendance', style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Quick Faculty Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 16),
                      _quickActionButton(
                        context,
                        'Upload Exam Marks',
                        'Input student mid-term or internal marks',
                        Icons.grade_outlined,
                        AppColors.primary,
                        () => Navigator.of(context).pushReplacementNamed('/faculty/marks'),
                      ),
                      const SizedBox(height: 12),
                      _quickActionButton(
                        context,
                        'Publish Assignment',
                        'Set homework or project due dates',
                        Icons.task_alt,
                        AppColors.success,
                        () => Navigator.of(context).pushReplacementNamed('/faculty/assignments'),
                      ),
                      const SizedBox(height: 12),
                      _quickActionButton(
                        context,
                        'My Teaching Timetable',
                        'View full weekly lecture hours',
                        Icons.calendar_month,
                        const Color(0xFF0EA5E9),
                        () => Navigator.of(context).pushReplacementNamed('/faculty/timetable'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickActionButton(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: color)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: color),
          ],
        ),
      ),
    );
  }
}

