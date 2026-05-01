import 'package:flutter/material.dart';
import '../../models/step.dart' as model;
import 'execution_group.dart';

class ExecutionPlanList extends StatelessWidget {
  final List<model.Step> steps;
  final String unitType;

  const ExecutionPlanList({
    super.key, 
    required this.steps,
    required this.unitType,
  });

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) {
      return const Center(
        child: Text('No steps available.', style: TextStyle(color: Colors.white24)),
      );
    }

    // For now, we render a flat list as a single group since the backend 
    // doesn't return milestone grouping in the flat Step list yet.
    // In Phase 7 we can add smarter grouping.
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      children: [
        ExecutionGroup(
          title: '', // Flat list for now
          steps: steps,
          unitType: unitType,
        ),
      ],
    );
  }
}
