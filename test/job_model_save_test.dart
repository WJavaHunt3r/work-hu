import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:work_hu/features/jobs/data/model/job_model.dart';

void main() {
  test('an existing job with a comment serializes for the PUT request', () {
    final json = {
      'id': 5,
      'jobDateTime': '2026-10-20T09:00:00',
      'jobEndDateTime': '2026-10-20T11:00:00',
      'description': 'Moving',
      'comment': null,
      'employerId': 3,
      'responsibleId': 2,
      'account': 'MYSHARE',
      'transactionType': 'HOURS',
      'status': 'OPEN',
    };
    final job = JobModel.fromJson(json);
    final edited = job.copyWith(comment: 'Bring gloves', registrationDeadline: null, cancellationDeadline: null);
    final encoded = jsonEncode(edited.toJson());
    expect(jsonDecode(encoded)['comment'], 'Bring gloves');
  });
}
