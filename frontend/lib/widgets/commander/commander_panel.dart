import 'package:flutter/material.dart';
import '../../models/execution_unit.dart';
import '../../models/step.dart' as model;
import 'step_commander.dart';
import '../../screens/backlog_screen.dart';

class CommanderPanel extends StatelessWidget {
  final ExecutionUnit? unit;
  final List<model.Step>? steps;
  final Function(int)? onCompleteStep;

  const CommanderPanel({
    super.key, 
    required this.unit,
    required this.steps,
    this.onCompleteStep,
  });

  @override
  Widget build(BuildContext context) {
    if (unit == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.rocket_launch_outlined, size: 64, color: Colors.white10),
            const SizedBox(height: 24),
            const Text(
              'Pick something to focus',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your execution plan is waiting.',
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const BacklogScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('GO TO BACKLOG'),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.blue.withOpacity(0.5)),
                ),
                child: Text(
                  unit!.type.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.circle, size: 8, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                'ACTIVE',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            unit!.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 32),
          
          // Step Content
          Expanded(
            child: steps == null 
              ? const Center(child: CircularProgressIndicator())
              : StepCommander(
                  unit: unit!,
                  steps: steps!,
                  onComplete: () {
                    // Logic for finding current step is in StepCommander,
                    // but we pass the action up
                    final nextStep = steps!.firstWhere(
                      (s) => s.status != 'done',
                      orElse: () => steps!.last,
                    );
                    onCompleteStep?.call(nextStep.id);
                  },
                ),
          ),
        ],
      ),
    );
  }
}
