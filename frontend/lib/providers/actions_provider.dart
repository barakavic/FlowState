import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_provider.dart';
import 'focus_provider.dart';
import 'steps_provider.dart';
import 'pressure_provider.dart';
import 'units_provider.dart';

final actionsProvider = Provider((ref) => FlowstateActions(ref));

class FlowstateActions {
  final Ref ref;

  FlowstateActions(this.ref);

  Future<void> completeStep(int stepId) async {
    final api = ref.read(apiServiceProvider);
    await api.completeStep(stepId);
    print('TELEMETRY: {"event": "step_completed", "step_id": $stepId, "timestamp": "${DateTime.now().toUtc().toIso8601String()}"}');
    _invalidateAll();
  }

  Future<void> setFocus(int unitId) async {
    final api = ref.read(apiServiceProvider);
    await api.setFocus(unitId);
    print('TELEMETRY: {"event": "focus_changed", "unit_id": $unitId, "timestamp": "${DateTime.now().toUtc().toIso8601String()}"}');
    _invalidateAll();
  }

  Future<void> activateUnit(int unitId) async {
    final api = ref.read(apiServiceProvider);
    await api.activateAndFocus(unitId);
    print('TELEMETRY: {"event": "unit_activated", "unit_id": $unitId, "timestamp": "${DateTime.now().toUtc().toIso8601String()}"}');
    _invalidateAll();
  }

  void _invalidateAll() {
    ref.invalidate(focusProvider);
    ref.invalidate(pressureProvider);
    ref.invalidate(unitsProvider);
    ref.invalidate(stepsProvider);
  }
}
