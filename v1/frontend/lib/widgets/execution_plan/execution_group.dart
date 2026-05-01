import 'package:flutter/material.dart';
import '../../models/step.dart' as model;
import 'execution_step_tile.dart';

class ExecutionGroup extends StatelessWidget {
  final String title;
  final List<model.Step> steps;
  final String unitType;

  const ExecutionGroup({
    super.key, 
    required this.title, 
    required this.steps,
    required this.unitType,
  });

  @override
  Widget build(BuildContext context) {
    // Find first incomplete step for locking logic
    final firstIncompleteIndex = steps.indexWhere((s) => s.status != 'done');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                color: Colors.blue.withOpacity(0.7),
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
        ...steps.map((step) {
          final int indexInList = steps.indexOf(step);
          
          // Course locking: any step after the first incomplete one is "locked"
          final bool isLocked = unitType == 'course' && 
                                firstIncompleteIndex != -1 && 
                                indexInList > firstIncompleteIndex;
                                
          final bool isCurrent = firstIncompleteIndex != -1 && 
                                indexInList == firstIncompleteIndex;

          return ExecutionStepTile(
            step: step,
            isLocked: isLocked,
            isCurrent: isCurrent,
          );
        }).toList(),
      ],
    );
  }
}
