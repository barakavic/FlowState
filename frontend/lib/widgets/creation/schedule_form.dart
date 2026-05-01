import 'package:flutter/material.dart';
import 'duration_input.dart';
import 'hours_input.dart';

class ScheduleForm extends StatefulWidget {
  final Function(int duration, String unit, double hoursPerDay, bool autoFocus) onSubmit;

  const ScheduleForm({super.key, required this.onSubmit});

  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  int _duration = 2;
  String _unit = 'weeks';
  double _hoursPerDay = 2.0;
  bool _autoFocus = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SCHEDULING',
          style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        const SizedBox(height: 24),
        DurationInput(
          value: _duration,
          unit: _unit,
          onValueStateChanged: (v) => setState(() => _duration = v),
          onUnitStateChanged: (v) => setState(() => _unit = v),
        ),
        const SizedBox(height: 32),
        HoursInput(
          value: _hoursPerDay,
          onChanged: (v) => setState(() => _hoursPerDay = v),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Auto-Focus on Start', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Set as current focus immediately', style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12)),
                  ],
                ),
              ),
              Switch(
                value: _autoFocus,
                onChanged: (v) => setState(() => _autoFocus = v),
                activeColor: Colors.blue,
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              if (_duration <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Duration must be greater than zero'), backgroundColor: Colors.redAccent),
                );
                return;
              }
              if (_hoursPerDay <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Hours per day must be greater than zero'), backgroundColor: Colors.redAccent),
                );
                return;
              }
              widget.onSubmit(_duration, _unit, _hoursPerDay, _autoFocus);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('FINALIZE & SCHEDULE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
