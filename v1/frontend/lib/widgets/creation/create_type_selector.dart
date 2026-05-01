import 'package:flutter/material.dart';

class CreateTypeSelector extends StatelessWidget {
  final Function(String) onSelected;

  const CreateTypeSelector({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SELECT TYPE',
          style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        const SizedBox(height: 24),
        _TypeCard(
          title: 'Project',
          description: 'Parse a roadmap from Markdown',
          icon: Icons.assignment_outlined,
          onTap: () => onSelected('project'),
        ),
        const SizedBox(height: 16),
        _TypeCard(
          title: 'Book',
          description: 'Extract chapters from a PDF TOC',
          icon: Icons.menu_book_outlined,
          onTap: () => onSelected('book'),
        ),
        const SizedBox(height: 16),
        _TypeCard(
          title: 'Course',
          description: 'Manual step-by-step definition',
          icon: Icons.school_outlined,
          onTap: () => onSelected('course'),
        ),
      ],
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _TypeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white10),
          ],
        ),
      ),
    );
  }
}
