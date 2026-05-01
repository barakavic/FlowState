import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/execution_unit.dart';
import 'api_provider.dart';

final focusProvider = FutureProvider<ExecutionUnit?>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getFocus();
});
