import 'package:flutter/material.dart';
import '../../models/execution_unit.dart';

class FocusItem extends StatelessWidget {
  final ExecutionUnit unit;
  final bool isCurrent;
  final bool isSwitching;
  final VoidCallback onTap;

  const FocusItem({
    super.key,
    required this.unit,
    required this.isCurrent,
    this.isSwitching = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isCurrent ? Colors.blue.withOpacity(0.1) : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCurrent ? Colors.blue : Colors.white10,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unit.title,
                    style: TextStyle(
                      color: isCurrent ? Colors.white : Colors.white70,
                      fontSize: 16,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      unit.type.toUpperCase(),
                      style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            if (isCurrent)
              const Icon(Icons.check_circle, color: Colors.blue, size: 20),
            if (isSwitching)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
              ),
          ],
        ),
      ),
    );
  }
}
