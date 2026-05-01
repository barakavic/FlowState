import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/focus_provider.dart';
import '../../providers/steps_provider.dart';
import 'execution_plan_list.dart';

class ExecutionPlanScreen extends ConsumerWidget {
  const ExecutionPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusAsync = ref.watch(focusProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1117),
        elevation: 0,
        title: focusAsync.when(
          data: (unit) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'EXECUTION PLAN',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              Text(
                unit?.title ?? 'No Focus',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Error'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: focusAsync.when(
        data: (unit) {
          if (unit == null) return const Center(child: Text('No focus unit.'));
          
          final stepsAsync = ref.watch(stepsProvider(unit.id));
          
          return stepsAsync.when(
            data: (steps) => ExecutionPlanList(steps: steps, unitType: unit.type),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, __) => Center(child: Text('Error: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, __) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
