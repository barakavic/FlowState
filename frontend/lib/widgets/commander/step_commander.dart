import 'package:flutter/material.dart';
import '../../models/execution_unit.dart';
import '../../models/step.dart' as model;
import 'deadline_badge.dart';
import '../execution_plan/execution_plan_screen.dart';

class StepCommander extends StatelessWidget {
  final ExecutionUnit unit;
  final List<model.Step> steps;
  final VoidCallback? onComplete;

  const StepCommander({
    super.key, 
    required this.unit,
    required this.steps,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) return const Text('No steps available.', style: TextStyle(color: Colors.white24));

    // Logic for selection - kept strictly to deriving from input
    final nextStep = steps.firstWhere(
      (s) => s.status != 'done',
      orElse: () => steps.last,
    );
    final isAllDone = steps.every((s) => s.status == 'done');
    
    final doneCount = steps.where((s) => s.status == 'done').length;
    final totalCount = steps.length;
    final progress = totalCount > 0 ? doneCount / totalCount : 0.0;
    
    final now = DateTime.now().toUtc();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress Bar
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white10,
                color: Colors.blue,
                minHeight: 8,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(color: Colors.white60, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Step ${isAllDone ? totalCount : doneCount + 1} of $totalCount',
          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
        ),
        
        const Spacer(),
        
        if (!isAllDone) ...[
          Text(
            'DO THIS NEXT',
            style: TextStyle(
              color: Colors.blue.shade300,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            nextStep.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 24),
          
          if (nextStep.deadline != null) 
            DeadlineBadge(deadline: nextStep.deadline!, now: now),
            
          const SizedBox(height: 48),
          
          SizedBox(
            height: 64,
            width: 320,
            child: ElevatedButton(
              onPressed: onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline),
                  SizedBox(width: 12),
                  Text(
                    'Complete This Step',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ] else 
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.verified, color: Colors.green, size: 48),
              SizedBox(height: 16),
              Text('Completed ✔', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
          
        const Spacer(flex: 2),
        
        Row(
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExecutionPlanScreen()),
                );
              },
              icon: const Icon(Icons.list_alt, size: 18),
              label: const Text('View Execution Plan'),
              style: TextButton.styleFrom(foregroundColor: Colors.white38),
            ),
            const SizedBox(width: 20),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.swap_horiz, size: 18),
              label: const Text('Switch Focus'),
              style: TextButton.styleFrom(foregroundColor: Colors.white38),
            ),
          ],
        ),
      ],
    );
  }
}
