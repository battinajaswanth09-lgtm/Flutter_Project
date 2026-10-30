import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/academic_provider.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/status_badge.dart';

class AdminFeesScreen extends StatefulWidget {
  const AdminFeesScreen({Key? key}) : super(key: key);

  @override
  State<AdminFeesScreen> createState() => _AdminFeesScreenState();
}

class _AdminFeesScreenState extends State<AdminFeesScreen> {
  String? _statusFilter;

  @override
  Widget build(BuildContext context) {
    final academic = Provider.of<AcademicProvider>(context);
    final allFees = academic.fees;

    final filteredFees = _statusFilter == null
        ? allFees
        : allFees.where((f) => f.status.toLowerCase() == _statusFilter!.toLowerCase()).toList();

    double totalCollected = 0;
    double totalPending = 0;
    for (var f in allFees) {
      totalCollected += f.paidAmount;
      totalPending += (f.totalAmount - f.paidAmount);
    }

    return ResponsiveScaffold(
      currentRoute: '/admin/fees',
      pageTitle: 'Fee Management & Accounts',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Total Fees Collected',
                  value: '\$${totalCollected.toStringAsFixed(0)}',
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                  trend: 'Current Term',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'Outstanding Pending Fees',
                  value: '\$${totalPending.toStringAsFixed(0)}',
                  icon: Icons.hourglass_top_outlined,
                  color: AppColors.warning,
                  trend: 'Action required',
                  isPositive: false,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'Total Invoices Issued',
                  value: '${allFees.length}',
                  icon: Icons.receipt_long,
                  color: AppColors.primary,
                  subtitle: 'Academic Year 2025-26',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

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
                      const Text('Student Fee Invoices', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      Row(
                        children: [
                          _filterChip(null, 'All Invoices'),
                          const SizedBox(width: 8),
                          _filterChip('Paid', 'Paid'),
                          const SizedBox(width: 8),
                          _filterChip('Partial', 'Partial'),
                          const SizedBox(width: 8),
                          _filterChip('Overdue', 'Overdue'),
                        ],
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
                      DataColumn(label: Text('Invoice Title', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Due Date', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Total Amount', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Paid Amount', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Receipt / Txn', style: TextStyle(fontWeight: FontWeight.w700))),
                      DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w700))),
                    ],
                    rows: filteredFees.map((fee) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(fee.studentName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                Text(fee.rollNumber, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          DataCell(Text(fee.title, style: const TextStyle(fontSize: 12))),
                          DataCell(Text(fee.dueDate, style: const TextStyle(fontSize: 12))),
                          DataCell(Text('\$${fee.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600))),
                          DataCell(Text('\$${fee.paidAmount.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w600))),
                          DataCell(Text(fee.receiptNumber.isNotEmpty ? fee.receiptNumber : 'Pending', style: const TextStyle(fontSize: 11, color: AppColors.textMuted))),
                          DataCell(StatusBadge(status: fee.status)),
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

  Widget _filterChip(String? value, String label) {
    final isSelected = _statusFilter == value;
    return InkWell(
      onTap: () => setState(() => _statusFilter = value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

