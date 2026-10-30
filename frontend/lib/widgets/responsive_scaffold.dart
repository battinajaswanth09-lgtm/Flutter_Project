import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../providers/auth_provider.dart';

class NavItem {
  final String title;
  final IconData icon;
  final String route;

  const NavItem({required this.title, required this.icon, required this.route});
}

class ResponsiveScaffold extends StatefulWidget {
  final String currentRoute;
  final String pageTitle;
  final Widget body;
  final List<Widget>? actions;

  const ResponsiveScaffold({
    Key? key,
    required this.currentRoute,
    required this.pageTitle,
    required this.body,
    this.actions,
  }) : super(key: key);

  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  bool _isSidebarCollapsed = false;

  List<NavItem> _getNavItems(String role) {
    if (role == 'admin') {
      return const [
        NavItem(title: 'Overview', icon: Icons.dashboard_outlined, route: '/admin/dashboard'),
        NavItem(title: 'Students', icon: Icons.people_outline, route: '/admin/students'),
        NavItem(title: 'Faculty', icon: Icons.school_outlined, route: '/admin/faculty'),
        NavItem(title: 'Departments', icon: Icons.account_balance_outlined, route: '/admin/departments'),
        NavItem(title: 'Attendance', icon: Icons.fact_check_outlined, route: '/admin/attendance'),
        NavItem(title: 'Examinations', icon: Icons.assignment_outlined, route: '/admin/exams'),
        NavItem(title: 'Fee Management', icon: Icons.payment_outlined, route: '/admin/fees'),
        NavItem(title: 'Timetable', icon: Icons.calendar_month_outlined, route: '/admin/timetables'),
        NavItem(title: 'Announcements', icon: Icons.campaign_outlined, route: '/admin/announcements'),
        NavItem(title: 'Academic Reports', icon: Icons.analytics_outlined, route: '/admin/reports'),
      ];
    } else if (role == 'faculty') {
      return const [
        NavItem(title: 'Dashboard', icon: Icons.dashboard_outlined, route: '/faculty/dashboard'),
        NavItem(title: 'Take Attendance', icon: Icons.check_box_outlined, route: '/faculty/attendance'),
        NavItem(title: 'Upload Marks', icon: Icons.grade_outlined, route: '/faculty/marks'),
        NavItem(title: 'Assignments', icon: Icons.task_outlined, route: '/faculty/assignments'),
        NavItem(title: 'My Timetable', icon: Icons.schedule_outlined, route: '/faculty/timetable'),
      ];
    } else {
      return const [
        NavItem(title: 'Dashboard', icon: Icons.dashboard_outlined, route: '/student/dashboard'),
        NavItem(title: 'My Attendance', icon: Icons.verified_user_outlined, route: '/student/attendance'),
        NavItem(title: 'Exam Results', icon: Icons.workspace_premium_outlined, route: '/student/results'),
        NavItem(title: 'Class Timetable', icon: Icons.date_range_outlined, route: '/student/timetable'),
        NavItem(title: 'Fees & Invoices', icon: Icons.receipt_long_outlined, route: '/student/fees'),
        NavItem(title: 'Assignments', icon: Icons.assignment_turned_in_outlined, route: '/student/assignments'),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;
    final role = auth.userRole;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= AppConstants.tabletBreakpoint;
    final navItems = _getNavItems(role);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: !isDesktop ? _buildDrawer(navItems, user, role) : null,
      appBar: !isDesktop
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.textPrimary),
              title: Text(
                widget.pageTitle,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              actions: [
                _buildRoleBadge(role),
                const SizedBox(width: 8),
                _buildUserAvatar(user, auth),
                const SizedBox(width: 14),
              ],
            )
          : null,
      body: Row(
        children: [
          // Desktop permanent sidebar
          if (isDesktop) _buildSidebar(navItems, user, role),

          // Main page body
          Expanded(
            child: Column(
              children: [
                if (isDesktop) _buildTopNavbar(user, role, auth),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isDesktop ? 28.0 : 16.0),
                    child: widget.body,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNavbar(user, String role, AuthProvider auth) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _isSidebarCollapsed ? Icons.menu_open : Icons.menu,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  setState(() {
                    _isSidebarCollapsed = !_isSidebarCollapsed;
                  });
                },
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.pageTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'CampusPulse Portal / ${role.toUpperCase()}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _buildRoleBadge(role),
              const SizedBox(width: 16),
              // Notification Bell
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textSecondary),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No new notifications today')),
                  );
                },
              ),
              const SizedBox(width: 12),
              const VerticalDivider(width: 1, indent: 20, endIndent: 20),
              const SizedBox(width: 14),
              _buildUserAvatar(user, auth),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    Color color;
    switch (role.toLowerCase()) {
      case 'admin':
        color = const Color(0xFF8B5CF6);
        break;
      case 'faculty':
        color = const Color(0xFF0EA5E9);
        break;
      default:
        color = const Color(0xFF10B981);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildUserAvatar(user, AuthProvider auth) {
    return PopupMenuButton<String>(
      tooltip: 'User menu',
      onSelected: (val) {
        if (val == 'profile') {
          Navigator.of(context).pushNamed('/profile');
        } else if (val == 'logout') {
          auth.logout();
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      itemBuilder: (ctx) => [
        PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user?.name ?? 'Campus User', style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(user?.email ?? '', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              const Divider(),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person_outline, size: 18),
              SizedBox(width: 10),
              Text('My Profile'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 18, color: AppColors.danger),
              SizedBox(width: 10),
              Text('Sign Out', style: TextStyle(color: AppColors.danger)),
            ],
          ),
        ),
      ],
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary.withOpacity(0.2),
            backgroundImage: NetworkImage(
              user?.avatar ??
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80',
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary, size: 20),
        ],
      ),
    );
  }

  Widget _buildSidebar(List<NavItem> navItems, user, String role) {
    final width = _isSidebarCollapsed ? 80.0 : 260.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      decoration: const BoxDecoration(
        color: AppColors.sidebarBg,
      ),
      child: Column(
        children: [
          // Header / Branding
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.school, color: Colors.white, size: 22),
                ),
                if (!_isSidebarCollapsed) ...[
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CampusPulse',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'CMS Platform',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Navigation Links
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              itemCount: navItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (ctx, index) {
                final item = navItems[index];
                final isSelected = widget.currentRoute == item.route;

                return InkWell(
                  onTap: () {
                    if (widget.currentRoute != item.route) {
                      Navigator.of(context).pushReplacementNamed(item.route);
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                          size: 20,
                        ),
                        if (!_isSidebarCollapsed) ...[
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Logout
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF1E293B))),
            ),
            child: InkWell(
              onTap: () {
                final auth = Provider.of<AuthProvider>(context, listen: false);
                auth.logout();
                Navigator.of(context).pushReplacementNamed('/login');
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: Colors.redAccent, size: 20),
                    if (!_isSidebarCollapsed) ...[
                      const SizedBox(width: 12),
                      const Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(List<NavItem> navItems, user, String role) {
    return Drawer(
      backgroundColor: AppColors.sidebarBg,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF0F172A)),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(
                    user?.avatar ??
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'User',
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      _buildRoleBadge(role),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemCount: navItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (ctx, index) {
                final item = navItems[index];
                final isSelected = widget.currentRoute == item.route;

                return ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  selected: isSelected,
                  selectedTileColor: AppColors.primary,
                  leading: Icon(
                    item.icon,
                    color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFFE2E8F0),
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(); // close drawer
                    if (widget.currentRoute != item.route) {
                      Navigator.of(context).pushReplacementNamed(item.route);
                    }
                  },
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
            onTap: () {
              final auth = Provider.of<AuthProvider>(context, listen: false);
              auth.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
    );
  }
}
