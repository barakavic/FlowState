import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/execution_unit.dart';
import '../../models/step.dart';
import '../../models/system_pressure.dart';

class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL', 
    defaultValue: 'http://localhost:8001'
  );
  
  final Duration timeout = const Duration(seconds: 8);

  Future<http.Response> _postWithRetry(Uri url, {Map<String, String>? headers, Object? body, bool retry = false}) async {
    int attempts = 0;
    while (attempts < (retry ? 2 : 1)) {
      try {
        final response = await http.post(url, headers: headers, body: body).timeout(timeout);
        return response;
      } catch (e) {
        attempts++;
        if (attempts >= (retry ? 2 : 1)) rethrow;
        print('DEBUG: Retrying $url after error: $e');
      }
    }
    throw Exception('Request failed');
  }

  Future<bool> checkHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health')).timeout(timeout);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<ExecutionUnit?> getFocus() async {
    final response = await http.get(Uri.parse('$baseUrl/focus')).timeout(timeout);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final unitId = data['current_focus_unit_id'];
      if (unitId == null) return null;
      
      final unitResponse = await http.get(Uri.parse('$baseUrl/units/$unitId')).timeout(timeout);
      if (unitResponse.statusCode == 200) {
        return ExecutionUnit.fromJson(jsonDecode(unitResponse.body));
      }
    }
    return null;
  }

  Future<List<Step>> getSteps(int unitId) async {
    final response = await http.get(Uri.parse('$baseUrl/units/$unitId/steps')).timeout(timeout);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Step.fromJson(json)).toList();
    }
    throw Exception('Failed to load steps');
  }

  Future<void> completeStep(int stepId) async {
    final response = await _postWithRetry(
      Uri.parse('$baseUrl/steps/$stepId/complete'),
      retry: true
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to complete step: ${response.body}');
    }
  }

  Future<void> setFocus(int unitId) async {
    final response = await _postWithRetry(
      Uri.parse('$baseUrl/units/$unitId/focus'),
      retry: true
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to set focus: ${response.body}');
    }
  }

  Future<SystemPressure> getPressure() async {
    final response = await http.get(Uri.parse('$baseUrl/system/pressure')).timeout(timeout);
    if (response.statusCode == 200) {
      return SystemPressure.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load system pressure');
  }

  Future<List<ExecutionUnit>> getUnits() async {
    final response = await http.get(Uri.parse('$baseUrl/units')).timeout(timeout);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ExecutionUnit.fromJson(json)).toList();
    }
    throw Exception('Failed to load units');
  }

  Future<void> activateAndFocus(int unitId) async {
    final response = await _postWithRetry(
      Uri.parse('$baseUrl/units/$unitId/activate-and-focus'),
      retry: false
    );
    
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

  Future<ExecutionUnit> createUnit({
    required String title,
    required String type,
    double totalHours = 0.0,
  }) async {
    final response = await _postWithRetry(
      Uri.parse('$baseUrl/units'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'type': type,
        'total_hours': totalHours,
      }),
    );
    if (response.statusCode == 200) {
      return ExecutionUnit.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create unit: ${response.body}');
  }

  Future<void> addStep(int unitId, {
    required String title,
    required int orderIndex,
    double weight = 1.0,
  }) async {
    final response = await _postWithRetry(
      Uri.parse('$baseUrl/units/$unitId/steps'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'order_index': orderIndex,
        'weight': weight,
        'allocated_hours': 0.0,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add step: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> parseRoadmap({
    required String title,
    String? text,
    List<int>? fileBytes,
    String? fileName,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/parse/roadmap'));
    request.fields['title'] = title;
    if (text != null) request.fields['text'] = text;
    if (fileBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName ?? 'roadmap.md',
      ));
    }
    
    final streamedResponse = await request.send().timeout(timeout);
    final response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to parse roadmap: ${response.body}');
  }

  Future<Map<String, dynamic>> parsePdf({
    required String title,
    required List<int> fileBytes,
    required String fileName,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/parse/pdf'));
    request.fields['title'] = title;
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      fileBytes,
      filename: fileName,
    ));
    
    final streamedResponse = await request.send().timeout(timeout);
    final response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to parse PDF: ${response.body}');
  }

  Future<void> scheduleUnit(int unitId, {
    required int duration,
    required String durationUnit,
    required double hoursPerDay,
  }) async {
    final response = await _postWithRetry(
      Uri.parse('$baseUrl/units/$unitId/schedule'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'duration': duration,
        'duration_unit': durationUnit,
        'hours_per_day': hoursPerDay,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to schedule unit: ${response.body}');
    }
  }
}
