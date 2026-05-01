import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/commander/commander_panel.dart';
import '../widgets/pressure/pressure_panel.dart';
import '../widgets/common/bottom_placeholder.dart';
import '../providers/focus_provider.dart';
import '../providers/steps_provider.dart';
import '../providers/pressure_provider.dart';
import '../providers/actions_provider.dart';

class CommanderScreen extends StatelessWidget {
  const CommanderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      body: Row(
        children: [
          // 1. MAIN COMMANDER AREA (Center/Left)
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final focusAsync = ref.watch(focusProvider);
                      
                      return focusAsync.when(
                        data: (unit) {
                          if (unit == null) {
                            return const CommanderPanel(unit: null, steps: null);
                          }
                          
                          // Inner consumer to isolate step updates from unit metadata updates
                          return Consumer(
                            builder: (context, ref, child) {
                              final stepsAsync = ref.watch(stepsProvider(unit.id));
                              return CommanderPanel(
                                unit: unit,
                                steps: stepsAsync.value,
                                onCompleteStep: (stepId) => ref.read(actionsProvider).completeStep(stepId),
                              );
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, stack) => Center(child: Text('Error: $err')),
                      );
                    },
                  ),
                ),
                const BottomPlaceholder(),
              ],
            ),
          ),
          
          // 2. SYSTEM PRESSURE (Right)
          const VerticalDivider(width: 1, color: Colors.white10),
          SizedBox(
            width: 280,
            child: Consumer(
              builder: (context, ref, child) {
                final pressureAsync = ref.watch(pressureProvider);
                
                return pressureAsync.when(
                  data: (pressure) => PressurePanel(pressure: pressure),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
