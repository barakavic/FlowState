import 'package:flutter/material.dart';
import '../../models/system_pressure.dart';
import 'pressure_card.dart';

class PressurePanel extends StatelessWidget {
  final SystemPressure pressure;

  const PressurePanel({super.key, required this.pressure});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SYSTEM PRESSURE',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          PressureCard(
            label: 'Overdue Steps',
            value: pressure.overdueSteps.toString(),
            color: pressure.overdueSteps > 0 ? Colors.red : Colors.white10,
            isWarning: pressure.overdueSteps > 0,
          ),
          const SizedBox(height: 16),
          PressureCard(
            label: 'Stale Units',
            value: pressure.staleUnits.toString(),
            color: pressure.staleUnits > 0 ? Colors.amber : Colors.white10,
            isWarning: pressure.staleUnits > 0,
          ),
          const SizedBox(height: 16),
          PressureCard(
            label: 'Daily Progress',
            value: pressure.noProgressToday ? 'ZERO' : 'ACTIVE',
            color: pressure.noProgressToday ? Colors.amber : Colors.green.withOpacity(0.2),
            isWarning: pressure.noProgressToday,
          ),
        ],
      ),
    );
  }
}
