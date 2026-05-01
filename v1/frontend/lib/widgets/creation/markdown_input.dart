import 'package:flutter/material.dart';

class MarkdownInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const MarkdownInput({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          maxLines: 10,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'monospace'),
          decoration: InputDecoration(
            hintText: '# Project Roadmap\n- [ ] Task 1\n- [ ] Task 2',
            hintStyle: const TextStyle(color: Colors.white10),
            filled: true,
            fillColor: Colors.white.withOpacity(0.03),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white10),
            ),
          ),
        ),
      ],
    );
  }
}
