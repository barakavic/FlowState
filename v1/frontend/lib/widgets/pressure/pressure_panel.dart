import 'package:flutter/material.dart';
import '../../models/system_pressure.dart';
import '../../screens/backlog_screen.dart';
import '../../screens/completed_screen.dart';
import '../../screens/create_unit_screen.dart';
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
          if (pressure.overdueSteps == 0 && pressure.staleUnits == 0 && !pressure.noProgressToday)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 16),
                    SizedBox(width: 12),
                    Text('ALL CLEAR', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          const Spacer(),
          const Divider(color: Colors.white10),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreateUnitScreen()),
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('CREATE NEW UNIT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _NavButton(
            label: 'View Backlog',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BacklogScreen()),
            ),
          ),
          const SizedBox(height: 8),
          _NavButton(
            label: 'View Completed',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CompletedScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NavButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
