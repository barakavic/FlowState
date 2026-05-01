import 'package:flutter/material.dart';

class DeadlineBadge extends StatelessWidget {
  final DateTime deadline;
  final DateTime now;

  const DeadlineBadge({
    super.key, 
    required this.deadline,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = deadline.isBefore(now);
    final isClose = deadline.difference(now).inHours < 24;
    
    final color = isOverdue 
        ? Colors.red 
        : (isClose ? Colors.amber : Colors.white24);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            isOverdue ? 'OVERDUE' : 'DEADLINE: ${deadline.toLocal().toString().substring(0, 16)}',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
