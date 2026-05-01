class Step {
  final int id;
  final int executionUnitId;
  final String title;
  final int orderIndex;
  final double weight;
  final double allocatedHours;
  final DateTime? deadline;
  final String status;
  final DateTime? completedAt;

  Step({
    required this.id,
    required this.executionUnitId,
    required this.title,
    required this.orderIndex,
    required this.weight,
    required this.allocatedHours,
    this.deadline,
    required this.status,
    this.completedAt,
  });

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      id: json['id'],
      executionUnitId: json['execution_unit_id'],
      title: json['title'],
      orderIndex: json['order_index'],
      weight: (json['weight'] as num).toDouble(),
      allocatedHours: (json['allocated_hours'] as num).toDouble(),
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      status: json['status'],
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'execution_unit_id': executionUnitId,
      'title': title,
      'order_index': orderIndex,
      'weight': weight,
      'allocated_hours': allocatedHours,
      'deadline': deadline?.toIso8601String(),
      'status': status,
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}
