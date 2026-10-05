/// A user with jobs that are over but still wait for their hours.
class OverdueJobsModel {
  const OverdueJobsModel({required this.userId, required this.userName, required this.jobs});

  final num userId;
  final String userName;
  final List<OverdueJobModel> jobs;

  factory OverdueJobsModel.fromJson(Map<String, dynamic> json) => OverdueJobsModel(
    userId: json['userId'] as num,
    userName: json['userName'] as String? ?? '',
    jobs: (json['jobs'] as List? ?? []).map((e) => OverdueJobModel.fromJson(e as Map<String, dynamic>)).toList(),
  );
}

class OverdueJobModel {
  const OverdueJobModel({required this.id, required this.description, required this.jobDateTime});

  final num id;
  final String description;
  final DateTime? jobDateTime;

  factory OverdueJobModel.fromJson(Map<String, dynamic> json) => OverdueJobModel(
    id: json['id'] as num,
    description: json['description'] as String? ?? '',
    jobDateTime: json['jobDateTime'] == null ? null : DateTime.tryParse(json['jobDateTime'] as String),
  );
}
