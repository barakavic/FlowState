import 'package:flutter/material.dart';
import '../../models/execution_unit.dart';
import '../../models/step.dart' as model;
import 'step_commander.dart';
import '../../screens/backlog_screen.dart';
import '../focus/focus_indicator.dart';
import '../../screens/create_unit_screen.dart';

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
              'No active focus',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select a unit from your active list or create a new one.',
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
                    backgroundColor: Colors.white10,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('GO TO BACKLOG'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CreateUnitScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('CREATE NEW'),
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
          FocusIndicator(unit: unit!),
          const SizedBox(height: 48),
          
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
