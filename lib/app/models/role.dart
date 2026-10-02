/// The legacy single role of a user. The backend derives it from the user's roles; use
/// `UserModel.hasPermission` for access checks.
enum Role { USER, HELPER, TEAM_LEADER, ADMIN }
