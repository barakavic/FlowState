class SystemPressure {
  final int overdueSteps;
  final int staleUnits;
  final bool noProgressToday;

  SystemPressure({
    required this.overdueSteps,
    required this.staleUnits,
    required this.noProgressToday,
  });

  factory SystemPressure.fromJson(Map<String, dynamic> json) {
    return SystemPressure(
      overdueSteps: json['overdue_steps'],
      staleUnits: json['stale_units'],
      noProgressToday: json['no_progress_today'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overdue_steps': overdueSteps,
      'stale_units': staleUnits,
      'no_progress_today': noProgressToday,
    };
  }
}
