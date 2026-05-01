import 'package:flutter/material.dart';

class StepInputList extends StatefulWidget {
  final List<String> steps;
  final Function(List<String>) onChanged;

  const StepInputList({
    super.key,
    required this.steps,
    required this.onChanged,
  });

  @override
  State<StepInputList> createState() => _StepInputListState();
}

class _StepInputListState extends State<StepInputList> {
  final TextEditingController _controller = TextEditingController();

  void _addStep() {
    if (_controller.text.isNotEmpty) {
      final newSteps = [...widget.steps, _controller.text];
      widget.onChanged(newSteps);
      _controller.clear();
    }
  }

  void _removeStep(int index) {
    final newSteps = List<String>.from(widget.steps)..removeAt(index);
    widget.onChanged(newSteps);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MANUAL STEPS',
          style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...widget.steps.asMap().entries.map((entry) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text('${entry.key + 1}.', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(entry.value, style: const TextStyle(color: Colors.white, fontSize: 14)),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20),
                  onPressed: () => _removeStep(entry.key),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Add a step...',
                  hintStyle: const TextStyle(color: Colors.white10),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.03),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white10),
                  ),
                ),
                onSubmitted: (_) => _addStep(),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.blue, size: 32),
              onPressed: _addStep,
            ),
          ],
        ),
      ],
    );
  }
}
