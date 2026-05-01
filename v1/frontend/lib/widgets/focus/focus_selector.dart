import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/execution_unit.dart';
import '../../providers/actions_provider.dart';
import 'focus_item.dart';

class FocusSelector extends StatefulWidget {
  final List<ExecutionUnit> activeUnits;
  final int? currentFocusId;

  const FocusSelector({
    super.key,
    required this.activeUnits,
    this.currentFocusId,
  });

  @override
  State<FocusSelector> createState() => _FocusSelectorState();
}

class _FocusSelectorState extends State<FocusSelector> {
  int? _switchingToId;
  String? _error;

  @override
  Widget build(BuildContext context) {
    if (widget.activeUnits.isEmpty) {
      return const Center(
        child: Text(
          'No active units to focus.',
          style: TextStyle(color: Colors.white24),
        ),
      );
    }

    // Stable Sorting: current focus top, then lastActivityAt DESC
    final sortedUnits = List<ExecutionUnit>.from(widget.activeUnits)
      ..sort((a, b) {
        if (a.id == widget.currentFocusId) return -1;
        if (b.id == widget.currentFocusId) return 1;
        final aTime = a.lastActivityAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.lastActivityAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
          ),
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              return ListView.builder(
                itemCount: sortedUnits.length,
                itemBuilder: (context, index) {
                  final unit = sortedUnits[index];
                  final isCurrent = unit.id == widget.currentFocusId;
                  final isSwitching = unit.id == _switchingToId;

                  return FocusItem(
                    unit: unit,
                    isCurrent: isCurrent,
                    isSwitching: isSwitching,
                    onTap: (isCurrent || _switchingToId != null)
                        ? () {
                            if (isCurrent) Navigator.of(context).pop(); // No-op: just close
                          }
                        : () async {
                            setState(() {
                              _switchingToId = unit.id;
                              _error = null;
                            });
                            
                            try {
                              await ref.read(actionsProvider).setFocus(unit.id);
                              if (context.mounted) {
                                Navigator.of(context).pop(); // Fast close on success
                              }
                            } catch (e) {
                              if (mounted) {
                                setState(() {
                                  _switchingToId = null;
                                  _error = 'Switch failed: ${e.toString()}';
                                });
                              }
                            }
                          },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
