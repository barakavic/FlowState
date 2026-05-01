import 'package:flutter/material.dart';

class StepStatusBadge extends StatelessWidget {
  final String status;

  const StepStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isDone = status == 'done';
    
    final color = isDone ? Colors.green : Colors.white24;
    final icon = isDone ? Icons.check_circle : Icons.radio_button_unchecked;
    final label = isDone ? 'DONE' : 'PENDING';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
