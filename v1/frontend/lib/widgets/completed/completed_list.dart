import 'package:flutter/material.dart';
import '../../models/execution_unit.dart';
import 'completed_item.dart';

class CompletedList extends StatelessWidget {
  final List<ExecutionUnit> units;

  const CompletedList({super.key, required this.units});

  @override
  Widget build(BuildContext context) {
    if (units.isEmpty) {
      return const Center(
        child: Text(
          'No completed work yet',
          style: TextStyle(color: Colors.white38),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: units.length,
      itemBuilder: (context, index) {
        return CompletedItem(unit: units[index]);
      },
    );
  }
}
