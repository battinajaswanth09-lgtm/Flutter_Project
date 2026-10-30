import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/performance_chart.dart';
import '../../widgets/status_badge.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dash = Provider.of<DashboardProvider>(context);

    return ResponsiveScaffold(
      currentRoute: '/admin/dashboard',
      pageTitle: 'Admin Executive Dashboard',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 900;
              final isTablet = constraints.maxWidth > 600 && constraints.maxWidth <= 900;

              return GridView.count(
                crossAxisCount: isDesktop ? 4 : (isTablet ? 2 : 1),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isDesktop ? 1.5 : (isTablet ? 1.8 : 2.1),
                children: [
                  StatCard(
                    title: 'Total Enrolled Students',
                    value: '${dash.totalStudents}',
                    icon: Icons.people_alt_rounded,
                    color: AppColors.primary,
                    trend: '+12% this year',
                    isPositive: true,
                  ),
                  StatCard(
                    title: 'Faculty & Professors',
                    value: '${dash.totalFaculty}',
                    icon: Icons.school_rounded,
                    color: const Color(0xFF0EA5E9),
                    subtitle: '4 Departments active',
                  ),
                  StatCard(
                    title: 'Tuition Fees Collected',
                    value: '\$${dash.totalFeeCollected.toStringAsFixed(0)}',
                    icon: Icons.account_balance_wallet_rounded,
                    color: AppColors.success,
                    trend: '85% collected',
                    isPositive: true,
                  ),
                  StatCard(
                    title: 'Fees Pending / Dues',
                    value: '\$${dash.totalFeePending.toStringAsFixed(0)}',
                    icon: Icons.pending_actions_rounded,
                    color: AppColors.warning,
                    trend: 'Due by Nov 30',
                    isPositive: false,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Chart & Quick Attendance Shortage Section
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 950;
              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(flex: 3, child: PerformanceChartWidget()),
                        const SizedBox(width: 20),
                        Expanded(flex: 2, child: _buildShortageCard(dash, context)),
                      ],
                    )
                  : Column(
                      children: [
                        const PerformanceChartWidget(),
                        const SizedBox(height: 20),
                        _buildShortageCard(dash, context),
                      ],
                    );
            },
          ),
          const SizedBox(height: 24),

          // Recent Announcements & Department Overview
          _buildAnnouncementsSection(dash),
        ],
      ),
    );
  }

  Widget _buildShortageCard(DashboardProvider dash, BuildContext context) {
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
              const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Attendance Shortage Alert',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.dangerBg, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  '${dash.shortageStudents.length} Students < 75%',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.danger),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Students ineligible for end-term examinations unless compensated:',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const Divider(height: 24),
          if (dash.shortageStudents.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text('All student attendance is in good standing (>75%)', style: TextStyle(color: AppColors.success)),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dash.shortageStudents.length,
              separatorBuilder: (_, __) => const Divider(height: 16),
              itemBuilder: (ctx, index) {
                final student = dash.shortageStudents[index];
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(student.avatar),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(student.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          Text('${student.rollNumber} • ${student.departmentCode}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.dangerBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${student.overallAttendance}%',
                        style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsSection(DashboardProvider dash) {
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Campus Announcements & Notices',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              Text(
                'Live Feed',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dash.announcements.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, index) {
              final a = dash.announcements[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.campaign, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  a.title,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
                                ),
                              ),
                              StatusBadge(status: a.priority),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            a.content,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Published by ${a.authorName} • ${a.date}',
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
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

