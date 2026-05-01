import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/execution_unit.dart';
import '../../models/step.dart';
import '../../models/system_pressure.dart';

class ApiService {
  final String baseUrl = 'http://localhost:8001';

  Future<ExecutionUnit?> getFocus() async {
    final response = await http.get(Uri.parse('$baseUrl/focus'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final unitId = data['current_focus_unit_id'];
      if (unitId == null) return null;
      
      // Fetch the full unit details
      final unitResponse = await http.get(Uri.parse('$baseUrl/units/$unitId'));
      if (unitResponse.statusCode == 200) {
        return ExecutionUnit.fromJson(jsonDecode(unitResponse.body));
      }
    }
    return null;
  }

  Future<List<Step>> getSteps(int unitId) async {
    final response = await http.get(Uri.parse('$baseUrl/units/$unitId/steps'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Step.fromJson(json)).toList();
    }
    throw Exception('Failed to load steps');
  }

  Future<void> completeStep(int stepId) async {
    final response = await http.post(Uri.parse('$baseUrl/steps/$stepId/complete'));
    if (response.statusCode != 200) {
      throw Exception('Failed to complete step: ${response.body}');
    }
  }

  Future<void> setFocus(int unitId) async {
    final response = await http.post(Uri.parse('$baseUrl/focus/$unitId'));
    if (response.statusCode != 200) {
      throw Exception('Failed to set focus: ${response.body}');
    }
  }

  Future<SystemPressure> getPressure() async {
    final response = await http.get(Uri.parse('$baseUrl/system/pressure'));
    if (response.statusCode == 200) {
      return SystemPressure.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load system pressure');
  }
}
