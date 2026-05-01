import 'package:flutter/material.dart';
import '../../models/execution_unit.dart';

class CompletedItem extends StatelessWidget {
  final ExecutionUnit unit;

  const CompletedItem({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              unit.title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
          Text(
            unit.type.toUpperCase(),
            style: const TextStyle(
              color: Colors.white24,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
