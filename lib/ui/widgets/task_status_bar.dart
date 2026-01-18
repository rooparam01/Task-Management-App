import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskStatusBar extends StatelessWidget {
  final int pendingCount;
  final int dueTodayCount;
  final int yesterdayCount;

  const TaskStatusBar({
    super.key,
    required this.pendingCount,
    required this.dueTodayCount,
    required this.yesterdayCount
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatusCard(
            title: 'PENDING',
            count: pendingCount,
            subtitle: '+${yesterdayCount} from yesterday',
            dotColor: const Color(0xFFFBBF24),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatusCard(
            title: 'DUE TODAY',
            count: dueTodayCount,
            subtitle: 'High priority',
            dotColor: const Color(0xFFFB7185),
          ),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String title;
  final int count;
  final String subtitle;
  final Color dotColor;

  const _StatusCard({
    required this.title,
    required this.count,
    required this.subtitle,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Row(
            children: [
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Count
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 6),

          // Subtitle
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}