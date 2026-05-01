import 'package:flutter/material.dart';
import 'step_input_list.dart';

class CreateCourseForm extends StatefulWidget {
  final List<String>? initialSteps;
  final Function(String title, List<String> steps) onSubmit;

  const CreateCourseForm({super.key, this.initialSteps, required this.onSubmit});

  @override
  State<CreateCourseForm> createState() => _CreateCourseFormState();
}

class _CreateCourseFormState extends State<CreateCourseForm> {
  final _titleController = TextEditingController();
  late List<String> _steps;

  @override
  void initState() {
    super.initState();
    _steps = widget.initialSteps ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'COURSE DETAILS',
          style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _titleController,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: 'Course Title',
            hintStyle: const TextStyle(color: Colors.white10),
            filled: true,
            fillColor: Colors.white.withOpacity(0.03),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 32),
        StepInputList(
          steps: _steps,
          onChanged: (steps) => setState(() => _steps = steps),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              if (_titleController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a course title'), backgroundColor: Colors.redAccent),
                );
                return;
              }
              if (_steps.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please add at least one step'), backgroundColor: Colors.redAccent),
                );
                return;
              }
              widget.onSubmit(_titleController.text, _steps);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('CREATE COURSE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
