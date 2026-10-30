import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/academic_models.dart';
import '../../providers/academic_provider.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../widgets/status_badge.dart';

class StudentFeesScreen extends StatelessWidget {
  const StudentFeesScreen({Key? key}) : super(key: key);

  void _showPaymentDialog(BuildContext context, FeeModel fee) {
    String paymentMethod = 'Online / UPI';
    final amountToPay = fee.totalAmount - fee.paidAmount;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Pay ${fee.title}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Outstanding Dues: \$${amountToPay.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
              const SizedBox(height: 16),
              const Text('Select Payment Mode', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: paymentMethod,
                items: const [
                  DropdownMenuItem(value: 'Online / UPI', child: Text('UPI / QR Code')),
                  DropdownMenuItem(value: 'Credit/Debit Card', child: Text('Credit / Debit Card')),
                  DropdownMenuItem(value: 'Net Banking', child: Text('Net Banking Portal')),
                ],
                onChanged: (v) => setState(() => paymentMethod = v!),
              ),
              const SizedBox(height: 12),
              const Text('Secure 256-bit encrypted college payment gateway simulation', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final academic = Provider.of<AcademicProvider>(context, listen: false);
                academic.recordFeePayment(fee.id, amountToPay, paymentMethod);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment processed successfully! Fee cleared.'), backgroundColor: AppColors.success),
                );
              },
              child: Text('Pay \$${amountToPay.toStringAsFixed(0)}'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final academic = Provider.of<AcademicProvider>(context);
    final fees = academic.fees;

    return ResponsiveScaffold(
      currentRoute: '/student/fees',
      pageTitle: 'Fee Payment & Invoices',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  child: Text('Institutional Fee Schedule & Invoices', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
                const Divider(height: 1),
                DataTable(
                  horizontalMargin: 20,
                  columnSpacing: 28,
                  columns: const [
                    DataColumn(label: Text('Fee Title', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Term', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Due Date', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Amount', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Paid', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.w700))),
                  ],
                  rows: fees.map((fee) {
                    final isDue = fee.status != 'Paid';

                    return DataRow(
                      cells: [
                        DataCell(Text(fee.title, style: const TextStyle(fontWeight: FontWeight.w600))),
                        DataCell(Text('Sem ${fee.semester}')),
                        DataCell(Text(fee.dueDate)),
                        DataCell(Text('\$${fee.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700))),
                        DataCell(Text('\$${fee.paidAmount.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w600))),
                        DataCell(StatusBadge(status: fee.status)),
                        DataCell(
                          isDue
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  ),
                                  onPressed: () => _showPaymentDialog(context, fee),
                                  child: const Text('Pay Dues', style: TextStyle(fontSize: 12)),
                                )
                              : OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Downloaded Official Receipt #${fee.receiptNumber}'), backgroundColor: AppColors.primary),
                                    );
                                  },
                                  icon: const Icon(Icons.download, size: 14),
                                  label: const Text('Receipt', style: TextStyle(fontSize: 12)),
                                ),
                        ),
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

