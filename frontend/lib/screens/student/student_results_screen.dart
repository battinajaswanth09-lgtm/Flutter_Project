import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/academic_provider.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../widgets/status_badge.dart';

class StudentResultsScreen extends StatelessWidget {
  const StudentResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final academic = Provider.of<AcademicProvider>(context);
    final results = academic.examResults;

    double totalMarksObtained = 0;
    double totalMaxMarks = 0;
    for (var r in results) {
      totalMarksObtained += r.marksObtained;
      totalMaxMarks += r.maxMarks;
    }
    final pct = totalMaxMarks > 0 ? (totalMarksObtained / totalMaxMarks * 100) : 0.0;

    return ResponsiveScaffold(
      currentRoute: '/student/results',
      pageTitle: 'Academic Grades & Performance',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CGPA Summary Banner
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Semester 5 Academic Grade Card', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('Aggregate Score: ${totalMarksObtained.toInt()} / ${totalMaxMarks.toInt()} (${pct.toStringAsFixed(1)}%) • CGPA: 8.75', style: const TextStyle(fontSize: 13, color: Colors.white70)),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Downloading official semester transcript PDF...'), backgroundColor: AppColors.success),
                    );
                  },
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('Download Grade Card'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Marks Table
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Mid-Term Examination Results', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
                const Divider(height: 1),
                DataTable(
                  horizontalMargin: 20,
                  columnSpacing: 28,
                  columns: const [
                    DataColumn(label: Text('Course Name', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Code', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Marks', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Max', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Letter Grade', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Faculty Remarks', style: TextStyle(fontWeight: FontWeight.w700))),
                  ],
                  rows: results.map((r) {
                    return DataRow(
                      cells: [
                        DataCell(Text(r.subjectName, style: const TextStyle(fontWeight: FontWeight.w600))),
                        DataCell(Text(r.subjectCode)),
                        DataCell(Text('${r.marksObtained.toInt()}', style: const TextStyle(fontWeight: FontWeight.w700))),
                        DataCell(Text('${r.maxMarks.toInt()}')),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                            child: Text(r.grade, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
                          ),
                        ),
                        DataCell(StatusBadge(status: r.status)),
                        DataCell(Text(r.remarks, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

