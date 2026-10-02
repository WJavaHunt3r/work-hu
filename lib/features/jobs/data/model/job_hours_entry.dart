/// Hours worked by one registered user, submitted when a job is completed (0 for no-shows).
class JobHoursEntry {
  const JobHoursEntry({required this.userId, required this.hours, this.description});

  final num userId;
  final double hours;

  /// Optional; the backend uses the job description when empty.
  final String? description;

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "hours": hours,
    if (description != null && description!.isNotEmpty) "description": description,
  };
}
