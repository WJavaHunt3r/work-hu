import 'package:flutter_test/flutter_test.dart';
import 'package:work_hu/app/models/permission.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

UserModel userWith(List<Permission> permissions, {Role role = Role.USER}) => UserModel(
  id: 1,
  firstname: 'T',
  lastname: 'U',
  role: role,
  changedPassword: true,
  permissions: [for (final p in permissions) p.name],
);

void main() {
  // The permissions the admin page has an entry for (lib/features/admin/view/admin_page.dart)
  const withAdminEntry = [
    Permission.USER_MANAGE,
    Permission.ROLE_MANAGE,
    Permission.TRANSACTION_MANAGE,
    Permission.GOAL_MANAGE,
    Permission.MENTOR_MANAGE,
    Permission.CAMP_MANAGE,
    Permission.DONATION_MANAGE,
    Permission.PAYMENT_MANAGE,
    Permission.SEASON_MANAGE,
    Permission.AUDIT_LOG_VIEW,
    Permission.JOB_CREATE,
    Permission.JOB_MANAGE_ALL,
    Permission.MAILING_SEND,
    Permission.STREAM_MANAGE,
    Permission.NOTIFICATION_SEND,
    Permission.NOTIFICATION_SCHEDULE_MANAGE,
    Permission.READING_PLAN_MANAGE,
  ];

  for (final permission in withAdminEntry) {
    test('${permission.name} alone shows the admin tab', () {
      expect(userWith([permission]).hasAdminAccess(), isTrue);
    });
  }

  test('a user with no admin permission does not see the admin tab', () {
    expect(userWith([]).hasAdminAccess(), isFalse);
    expect(userWith([Permission.READING_PLAN]).hasAdminAccess(), isFalse);
  });

  test('admins and team leaders always do', () {
    expect(userWith([], role: Role.ADMIN).hasAdminAccess(), isTrue);
    expect(userWith([], role: Role.TEAM_LEADER).hasAdminAccess(), isTrue);
  });
}
