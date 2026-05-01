import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/system_pressure.dart';
import 'api_provider.dart';

final pressureProvider = FutureProvider<SystemPressure>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getPressure();
});
