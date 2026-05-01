import 'package:flowstate/providers/pressure_provider.dart';
import 'package:flowstate/providers/units_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/api/api_service.dart';
import '../providers/actions_provider.dart';
import '../widgets/creation/create_type_selector.dart';
import '../widgets/creation/create_project_form.dart';
import '../widgets/creation/create_book_form.dart';
import '../widgets/creation/create_course_form.dart';
import '../widgets/creation/schedule_form.dart';

class CreateUnitScreen extends ConsumerStatefulWidget {
  const CreateUnitScreen({super.key});

  @override
  ConsumerState<CreateUnitScreen> createState() => _CreateUnitScreenState();
}

class _CreateUnitScreenState extends ConsumerState<CreateUnitScreen> {
  int _currentStep = 0;
  String? _selectedType;
  int? _createdUnitId;
  bool _isLoading = false;

  void _nextStep() => setState(() => _currentStep++);
  void _prevStep() => setState(() => _currentStep--);

  Future<void> _handleProjectSubmit(String title, String? text, dynamic file) async {
    setState(() => _isLoading = true);
    try {
      final api = ApiService();
      final result = await api.parseRoadmap(
        title: title,
        text: text,
        fileBytes: file?.bytes,
        fileName: file?.name,
      );
      setState(() {
        _createdUnitId = result['unit_id'];
        _isLoading = false;
      });
      _nextStep();
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Parsing failed: ${e.toString()}');
    }
  }

  Future<void> _handleBookSubmit(String title, dynamic file) async {
    setState(() => _isLoading = true);
    try {
      final api = ApiService();
      final result = await api.parsePdf(
        title: title,
        fileBytes: file.bytes,
        fileName: file.name,
      );
      
      if (result['requires_manual_input'] == true) {
        setState(() {
          _selectedType = 'course'; // Fallback to manual chapter input
          _isLoading = false;
        });
        _showError("No table of contents found. Add chapters manually.");
      } else {
        setState(() {
          _createdUnitId = result['unit_id'];
          _isLoading = false;
        });
        _nextStep();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('PDF Parsing failed: ${e.toString()}');
    }
  }

  Future<void> _handleCourseSubmit(String title, List<String> steps) async {
    setState(() => _isLoading = true);
    try {
      final api = ApiService();
      final unit = await api.createUnit(title: title, type: 'course');
      for (int i = 0; i < steps.length; i++) {
        await api.addStep(unit.id, title: steps[i], orderIndex: i + 1);
      }
      setState(() {
        _createdUnitId = unit.id;
        _isLoading = false;
      });
      _nextStep();
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Creation failed: ${e.toString()}');
    }
  }

  Future<void> _handleScheduleSubmit(int duration, String unit, double hoursPerDay, bool autoFocus) async {
    if (_createdUnitId == null) return;
    
    setState(() => _isLoading = true);
    try {
      final api = ApiService();
      await api.scheduleUnit(_createdUnitId!, 
        duration: duration, 
        durationUnit: unit, 
        hoursPerDay: hoursPerDay
      );
      
      if (autoFocus) {
        await ref.read(actionsProvider).activateUnit(_createdUnitId!);
        if (mounted) {
          // Closure: Return to Commander
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } else {
        // Explicit Invalidation
        ref.invalidate(unitsProvider);
        ref.invalidate(pressureProvider);
        
        if (mounted) {
          // Closure: Return to Backlog (or whatever was before)
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Scheduling failed. Please retry. Error: ${e.toString()}');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message), 
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1116),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _currentStep == 0 ? 'NEW EXECUTION UNIT' : 'STEP $_currentStep OF 2',
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: _buildCurrentStep(),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    if (_currentStep == 0) {
      return CreateTypeSelector(onSelected: (type) {
        setState(() => _selectedType = type);
        _nextStep();
      });
    }

    if (_currentStep == 1) {
      switch (_selectedType) {
        case 'project':
          return CreateProjectForm(onSubmit: _handleProjectSubmit);
        case 'book':
          return CreateBookForm(onSubmit: _handleBookSubmit);
        case 'course':
          return CreateCourseForm(
            initialSteps: _selectedType == 'book' ? ['Chapter 1'] : null,
            onSubmit: _handleCourseSubmit,
          );
        default:
          return const Text('Unknown type');
      }
    }

    if (_currentStep == 2) {
      return ScheduleForm(onSubmit: _handleScheduleSubmit);
    }

    return const SizedBox();
  }
}
