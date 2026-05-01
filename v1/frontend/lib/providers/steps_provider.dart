import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/step.dart';
import 'api_provider.dart';

final stepsProvider = FutureProvider.family<List<Step>, int>((ref, unitId) async {
  final api = ref.watch(apiServiceProvider);
  return api.getSteps(unitId);
});
