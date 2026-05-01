import 'package:flutter/material.dart';

class HoursInput extends StatelessWidget {
  final double value;
  final Function(double) onChanged;

  const HoursInput({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'HOURS PER DAY',
              style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              '${value.toStringAsFixed(1)} hrs',
              style: const TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.blue,
            inactiveTrackColor: Colors.white10,
            thumbColor: Colors.blue,
            overlayColor: Colors.blue.withOpacity(0.2),
          ),
          child: Slider(
            value: value,
            min: 0.5,
            max: 12.0,
            divisions: 23,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
