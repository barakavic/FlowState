import 'package:flutter/material.dart';
import '../../models/execution_unit.dart';
import 'backlog_item.dart';

class BacklogList extends StatelessWidget {
  final List<ExecutionUnit> units;

  const BacklogList({super.key, required this.units});

  @override
  Widget build(BuildContext context) {
    if (units.isEmpty) {
      return const Center(
        child: Text(
          'No items in backlog',
          style: TextStyle(color: Colors.white38),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: units.length,
      itemBuilder: (context, index) {
        return BacklogItem(unit: units[index]);
      },
    );
  }
}
