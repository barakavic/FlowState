import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_provider.dart';

final healthProvider = FutureProvider<bool>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.checkHealth();
});
