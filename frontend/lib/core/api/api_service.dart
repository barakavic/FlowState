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

  Future<List<ExecutionUnit>> getUnits() async {
    final response = await http.get(Uri.parse('$baseUrl/units'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ExecutionUnit.fromJson(json)).toList();
    }
    throw Exception('Failed to load units');
  }

  Future<void> updateUnitStatus(int unitId, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/units/$unitId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );
    
    if (response.statusCode == 400) {
      final data = jsonDecode(response.body);
      final detail = data['detail']?.toString() ?? '';
      if (detail.contains('active') && detail.contains('allowed')) {
        throw Exception('Active limit reached');
      }
    }
    
    if (response.statusCode != 200) {
      throw Exception('Failed to update unit status: ${response.body}');
    }
  }

  Future<void> activateAndFocus(int unitId) async {
    final response = await http.post(Uri.parse('$baseUrl/units/$unitId/activate-and-focus'));
    
    if (response.statusCode == 400) {
      final data = jsonDecode(response.body);
      final detail = data['detail']?.toString() ?? '';
      if (detail.contains('Max 5 active units')) {
        throw Exception('Active limit reached (max 5)');
      }
      if (detail.contains('Max 2 active books')) {
        throw Exception('Book limit reached (max 2)');
      }
      throw Exception(detail);
    }
    
    if (response.statusCode != 200) {
      throw Exception('Failed to activate and focus: ${response.body}');
    }
  }
}
