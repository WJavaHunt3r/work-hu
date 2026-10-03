enum JobStatus {
  OPEN("jobs_status_open"),
  COMPLETED("jobs_status_completed"),
  CANCELLED("jobs_status_cancelled");

  /// i18n key.
  final String label;

  const JobStatus(this.label);
}

enum JobRegistrationStatus {
  REGISTERED("jobs_registration_registered"),
  WAITLISTED("jobs_registration_waitlisted"),
  CANCELLED("jobs_registration_cancelled");

  /// i18n key.
  final String label;

  const JobRegistrationStatus(this.label);
}
