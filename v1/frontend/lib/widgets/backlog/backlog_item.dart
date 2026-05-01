import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/execution_unit.dart';
import '../../providers/actions_provider.dart';

class BacklogItem extends ConsumerStatefulWidget {
  final ExecutionUnit unit;

  const BacklogItem({super.key, required this.unit});

  @override
  ConsumerState<BacklogItem> createState() => _BacklogItemState();
}

class _BacklogItemState extends ConsumerState<BacklogItem> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.unit.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.unit.type.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isLoading 
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : TextButton(
                onPressed: () async {
                  setState(() => _isLoading = true);
                  try {
                    await ref.read(actionsProvider).activateUnit(widget.unit.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Activated'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    if (context.mounted) {
                      setState(() => _isLoading = false);
                      String message = 'Failed to activate unit';
                      if (e.toString().contains('Active limit reached')) {
                        message = 'Active limit reached (max 5)';
                      } else if (e.toString().contains('Book limit reached')) {
                        message = 'Book limit reached (max 2)';
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message), backgroundColor: Colors.red),
                      );
                    }
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                ),
                child: const Text('ACTIVATE'),
              ),
        ],
      ),
    );
  }
}
