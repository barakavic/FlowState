import 'package:flutter/material.dart';

class PressureCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isWarning;

  const PressureCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.isWarning,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14161F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isWarning ? color.withOpacity(0.5) : Colors.white05,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: isWarning ? color : Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
