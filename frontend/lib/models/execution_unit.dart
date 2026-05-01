class ExecutionUnit {
  final int id;
  final String title;
  final String type;
  final double totalHours;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status;
  final DateTime lastActivityAt;
  final int userId;

  ExecutionUnit({
    required this.id,
    required this.title,
    required this.type,
    required this.totalHours,
    this.startDate,
    this.endDate,
    required this.status,
    required this.lastActivityAt,
    required this.userId,
  });

  factory ExecutionUnit.fromJson(Map<String, dynamic> json) {
    return ExecutionUnit(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      totalHours: (json['total_hours'] as num).toDouble(),
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      status: json['status'],
      lastActivityAt: DateTime.parse(json['last_activity_at']),
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'total_hours': totalHours,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'status': status,
      'last_activity_at': lastActivityAt.toIso8601String(),
      'user_id': userId,
    };
  }
}
