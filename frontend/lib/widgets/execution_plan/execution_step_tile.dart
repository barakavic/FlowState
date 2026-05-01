import 'package:flutter/material.dart';
import '../../models/step.dart' as model;
import 'step_status_badge.dart';
import 'step_deadline_badge.dart';

class ExecutionStepTile extends StatelessWidget {
  final model.Step step;
  final bool isLocked;
  final bool isCurrent;

  const ExecutionStepTile({
    super.key, 
    required this.step,
    this.isLocked = false,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDone = step.status == 'done';
    final now = DateTime.now().toUtc();

    return Opacity(
      opacity: isLocked || (isDone && !isCurrent) ? 0.5 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCurrent ? Colors.blue.withOpacity(0.05) : const Color(0xFF14161F),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCurrent ? Colors.blue.withOpacity(0.3) : Colors.white,
          ),
        ),
        child: Row(
          children: [
            // Order & Status
            Column(
              children: [
                Text(
                  step.orderIndex.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    color: Colors.white24,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (isLocked)
                  const Icon(Icons.lock_outline, size: 16, color: Colors.white24)
                else
                  Icon(
                    isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                    size: 16,
                    color: isDone ? Colors.green : Colors.white24,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      decorationColor: Colors.white24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (step.deadline != null) ...[
                        StepDeadlineBadge(deadline: step.deadline!, now: now),
                        const SizedBox(width: 16),
                      ],
                      Icon(Icons.timer_outlined, size: 14, color: Colors.white24),
                      const SizedBox(width: 4),
                      Text(
                        '${step.allocatedHours.toStringAsFixed(1)}h',
                        style: const TextStyle(color: Colors.white24, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Status Badge
            StepStatusBadge(status: step.status),
          ],
        ),
      ),
    );
  }
}
