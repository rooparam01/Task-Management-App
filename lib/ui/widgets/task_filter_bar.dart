import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/common_colors.dart';
import '../../providers/task_provider.dart';

class TaskFilterBar extends StatelessWidget {
  const TaskFilterBar();

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _FilterChip(
                label: 'All Tasks',
                isSelected: provider.filter == TaskFilter.all,
                onTap: () => provider.setFilter(TaskFilter.all),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Completed',
                isSelected: provider.filter == TaskFilter.completed,
                onTap: () => provider.setFilter(TaskFilter.completed),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Pending',
                isSelected: provider.filter == TaskFilter.pending,
                onTap: () => provider.setFilter(TaskFilter.pending),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.buttonBackground
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ),
    );
  }
}