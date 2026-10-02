/// Mirrors the backend's `Permission` enum. A user's effective permissions are the union over all of their roles.
///
/// The models keep permissions as plain strings so a permission added in the backend never breaks JSON parsing;
/// this enum is for checks and for the role editor. Names that aren't listed here are shown by name only.
enum Permission {
  USER_MANAGE,
  ROLE_MANAGE,
  PASSWORD_RESET,
  TRANSACTION_MANAGE,
  ACTIVITY_REGISTER,
  ACTIVITY_MANAGE_ALL,
  JOB_CREATE,
  JOB_MANAGE_ALL,
  GOAL_MANAGE,
  MENTOR_MANAGE,
  CAMP_MANAGE,
  DONATION_MANAGE,
  FRAKARE_MANAGE,
  PACE_TEAM_MANAGE,
  CHALLENGE_MANAGE,
  SEASON_MANAGE,
  PAYMENT_MANAGE,
  BOOKING_ADMIN,
  AUDIT_LOG_VIEW;

  /// i18n key of the permission's name.
  String get label => "permission_$name";
}
