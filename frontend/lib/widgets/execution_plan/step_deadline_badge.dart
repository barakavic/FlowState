import 'package:flutter/material.dart';

class StepDeadlineBadge extends StatelessWidget {
  final DateTime deadline;
  final DateTime now;

  const StepDeadlineBadge({
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
        : (isClose ? Colors.amber : Colors.white38);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.event, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          deadline.toLocal().toString().substring(5, 16),
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
