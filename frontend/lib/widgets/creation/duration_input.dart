import 'package:flutter/material.dart';

class DurationInput extends StatelessWidget {
  final int value;
  final String unit;
  final Function(int) onValueStateChanged;
  final Function(String) onUnitStateChanged;

  const DurationInput({
    super.key,
    required this.value,
    required this.unit,
    required this.onValueStateChanged,
    required this.onUnitStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DURATION',
          style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.03),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white10),
                  ),
                ),
                onChanged: (v) => onValueStateChanged(int.tryParse(v) ?? 0),
                controller: TextEditingController(text: value.toString()),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: unit,
                    dropdownColor: const Color(0xFF1A1D25),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    items: ['days', 'weeks'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (v) => onUnitStateChanged(v!),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
