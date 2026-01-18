import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager/core/constants/common_colors.dart';


class TaskItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final DateTime dueDate;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onMarkCompleted;

  const TaskItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.dueDate,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onMarkCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = status.toLowerCase() == 'pending';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                _StatusChip(status: status),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
              ),
            ),

            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 6),
                Text(
                  _formatDate(dueDate),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
                const Spacer(),

                PopupMenuButton<_TaskMenuAction>(
                  color: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Color(0xFF94A3B8),
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case _TaskMenuAction.edit:
                        onEdit?.call();
                        break;
                      case _TaskMenuAction.complete:
                        onMarkCompleted?.call();
                        break;
                      case _TaskMenuAction.delete:
                        onDelete?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    _popupItem(
                      icon: Icons.edit_outlined,
                      text: 'Edit Task',
                      color: const Color(0xFF2563EB),
                      value: _TaskMenuAction.edit,
                    ),

                    if (isPending)
                      _popupItem(
                        icon: Icons.check_circle_outline,
                        text: 'Mark as Completed',
                        color: const Color(0xFF16A34A),
                        value: _TaskMenuAction.complete,
                      ),

                    _popupItem(
                      icon: Icons.delete_outline,
                      text: 'Delete',
                      color: Colors.red,
                      value: _TaskMenuAction.delete,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  PopupMenuItem<_TaskMenuAction> _popupItem({
    required IconData icon,
    required String text,
    required Color color,
    required _TaskMenuAction value,
  }) {
    return PopupMenuItem<_TaskMenuAction>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }


}

enum _TaskMenuAction {
  edit,
  delete,
  complete,
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final isPending = status.toLowerCase() == 'pending';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPending
            ? const Color(0xFFEFF6FF)
            : const Color(0xFFECFDF3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isPending
              ? const Color(0xFF2563EB)
              : const Color(0xFF16A34A),
        ),
      ),
    );
  }
}