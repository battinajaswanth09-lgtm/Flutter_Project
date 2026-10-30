import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SearchFilterBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onSearchChanged;
  final String? selectedDepartment;
  final ValueChanged<String?>? onDepartmentChanged;
  final VoidCallback? onAddNew;
  final String addNewLabel;

  const SearchFilterBar({
    Key? key,
    this.hintText = 'Search by name, roll number...',
    required this.onSearchChanged,
    this.selectedDepartment,
    this.onDepartmentChanged,
    this.onAddNew,
    this.addNewLabel = 'Add Record',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: isDesktop
          ? Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    onChanged: onSearchChanged,
                    decoration: InputDecoration(
                      hintText: hintText,
                      prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textMuted),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                if (onDepartmentChanged != null) ...[
                  const SizedBox(width: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedDepartment,
                        hint: const Text('All Departments', style: TextStyle(fontSize: 13)),
                        items: const [
                          DropdownMenuItem(value: null, child: Text('All Departments')),
                          DropdownMenuItem(value: 'CSE', child: Text('Computer Science (CSE)')),
                          DropdownMenuItem(value: 'ECE', child: Text('Electronics (ECE)')),
                          DropdownMenuItem(value: 'MECH', child: Text('Mechanical (MECH)')),
                        ],
                        onChanged: onDepartmentChanged,
                      ),
                    ),
                  ),
                ],
                if (onAddNew != null) ...[
                  const SizedBox(width: 14),
                  ElevatedButton.icon(
                    onPressed: onAddNew,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(addNewLabel),
                  ),
                ],
              ],
            )
          : Column(
              children: [
                TextField(
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: hintText,
                    prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textMuted),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                if (onDepartmentChanged != null || onAddNew != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (onDepartmentChanged != null)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedDepartment,
                                hint: const Text('Department', style: TextStyle(fontSize: 13)),
                                items: const [
                                  DropdownMenuItem(value: null, child: Text('All Depts')),
                                  DropdownMenuItem(value: 'CSE', child: Text('CSE')),
                                  DropdownMenuItem(value: 'ECE', child: Text('ECE')),
                                  DropdownMenuItem(value: 'MECH', child: Text('MECH')),
                                ],
                                onChanged: onDepartmentChanged,
                              ),
                            ),
                          ),
                        ),
                      if (onDepartmentChanged != null && onAddNew != null)
                        const SizedBox(width: 10),
                      if (onAddNew != null)
                        ElevatedButton.icon(
                          onPressed: onAddNew,
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(addNewLabel),
                        ),
                    ],
                  ),
                ],
              ],
            ),
    );
  }
}
