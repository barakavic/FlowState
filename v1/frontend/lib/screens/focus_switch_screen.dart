import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/units_provider.dart';
import '../providers/focus_provider.dart';
import '../widgets/focus/focus_selector.dart';

class FocusSwitchScreen extends ConsumerWidget {
  const FocusSwitchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeUnits = ref.watch(unitsProvider);
    final focusAsync = ref.watch(focusProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1116),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'SWITCH FOCUS',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: activeUnits.when(
          data: (units) => focusAsync.when(
            data: (currentFocus) => FocusSelector(
              activeUnits: units,
              currentFocusId: currentFocus?.id,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}
