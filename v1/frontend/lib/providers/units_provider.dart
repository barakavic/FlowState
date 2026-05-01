import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/execution_unit.dart';
import 'api_provider.dart';

final unitsProvider = FutureProvider<List<ExecutionUnit>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getUnits();
});

final backlogUnitsProvider = Provider<List<ExecutionUnit>>((ref) {
  final unitsAsync = ref.watch(unitsProvider);
  return unitsAsync.when(
    data: (units) {
      final filtered = units.where((u) => u.status == 'backlog').toList();
      filtered.sort((a, b) {
        int cmp = a.lastActivityAt.compareTo(b.lastActivityAt);
        if (cmp != 0) return cmp;
        return a.createdAt.compareTo(b.createdAt);
      });
      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

final completedUnitsProvider = Provider<List<ExecutionUnit>>((ref) {
  final unitsAsync = ref.watch(unitsProvider);
  return unitsAsync.when(
    data: (units) {
      final filtered = units.where((u) => u.status == 'completed').toList();
      filtered.sort((a, b) {
        int cmp = b.lastActivityAt.compareTo(a.lastActivityAt);
        if (cmp != 0) return cmp;
        return b.createdAt.compareTo(a.createdAt);
      });
      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
