import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status.toLowerCase()) {
      case 'paid':
      case 'present':
      case 'pass':
      case 'active':
        bg = AppColors.successBg;
        fg = AppColors.success;
        break;
      case 'pending':
      case 'late':
      case 'partial':
      case 'upcoming':
        bg = AppColors.warningBg;
        fg = AppColors.warning;
        break;
      case 'absent':
      case 'overdue':
      case 'fail':
      case 'suspended':
      case 'urgent':
        bg = AppColors.dangerBg;
        fg = AppColors.danger;
        break;
      default:
        bg = AppColors.infoBg;
        fg = AppColors.info;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(0.2), width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
