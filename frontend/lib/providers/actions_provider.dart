import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_provider.dart';
import 'focus_provider.dart';
import 'steps_provider.dart';
import 'pressure_provider.dart';

final actionsProvider = Provider((ref) => FlowstateActions(ref));

class FlowstateActions {
  final Ref ref;

  FlowstateActions(this.ref);

  Future<void> completeStep(int stepId) async {
    final api = ref.read(apiServiceProvider);
    await api.completeStep(stepId);
    _invalidateAll();
  }

  Future<void> setFocus(int unitId) async {
    final api = ref.read(apiServiceProvider);
    await api.setFocus(unitId);
    _invalidateAll();
  }

  void _invalidateAll() {
    ref.invalidate(focusProvider);
    ref.invalidate(pressureProvider);
    // Since stepsProvider is a family, we might not know which unitId to invalidate,
    // so we can invalidate all of them if needed, or just let it be.
    // Riverpod 2.x handles invalidating families better.
    ref.invalidate(stepsProvider);
  }
}
