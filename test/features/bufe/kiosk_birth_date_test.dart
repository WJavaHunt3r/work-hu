import 'package:flutter_test/flutter_test.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/features/bufe/data/api/bufe_api.dart';
import 'package:work_hu/features/bufe/data/model/sumup_user_model.dart';
import 'package:work_hu/features/bufe/data/repository/bufe_repository.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

/// Records what the app sends to the kiosk's external-create-customer.
class _FakeKiosk implements BufeApi {
  final calls = <Map<String, dynamic>>[];

  @override
  Future<dynamic> createCustomer({
    required String fullname,
    required num dukappId,
    required String email,
    String? birthDate,
  }) async {
    calls.add({'full_name': fullname, 'dukapp_id': '$dukappId', 'email': email, 'birth_date': birthDate});
    return {'full_name': fullname, 'balance': 0, 'dukapp_id': '$dukappId', 'spent': 0, 'birth_date': birthDate};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

UserModel _user({DateTime? birthDate}) => UserModel(
  id: 42,
  firstname: 'Éva',
  lastname: 'Kovács',
  role: Role.USER,
  changedPassword: true,
  email: 'eva@example.com',
  birthDate: birthDate,
);

SumupUserModel _account({String? birthDate}) =>
    SumupUserModel(full_name: 'Kovács Éva', balance: 100, dukapp_id: '42', spent: 0, birth_date: birthDate);

void main() {
  test('the kiosk gets the calendar date as entered, and nothing for a date that is not in the past', () {
    final today = DateTime(2026, 11, 6);
    expect(kioskBirthDate(DateTime(1990, 5, 7), today: today), '1990-05-07');
    // a date parsed from the backend as UTC midnight stays the same day
    expect(kioskBirthDate(DateTime.utc(2010, 12, 31), today: today), '2010-12-31');
    expect(kioskBirthDate(null, today: today), isNull);
    expect(kioskBirthDate(DateTime(2026, 11, 6), today: today), isNull); // today is not in the past
    expect(kioskBirthDate(DateTime(2027, 1, 1), today: today), isNull);
  });

  test('a customer without a birth date gets it, one with the same date is left alone', () async {
    final kiosk = _FakeKiosk();
    final repo = BufeRepository(kiosk);
    final user = _user(birthDate: DateTime(1990, 5, 7));

    final updated = await repo.syncBirthDate(user, _account());
    expect(kiosk.calls.single['birth_date'], '1990-05-07');
    expect(kiosk.calls.single['dukapp_id'], '42');
    expect(updated?.birth_date, '1990-05-07');

    expect(await repo.syncBirthDate(user, _account(birthDate: '1990-05-07')), isNull);
    expect(kiosk.calls, hasLength(1)); // nothing sent the second time
  });

  test('a changed birth date is sent again, and a user without one sends nothing', () async {
    final kiosk = _FakeKiosk();
    final repo = BufeRepository(kiosk);

    await repo.syncBirthDate(_user(birthDate: DateTime(1991, 1, 2)), _account(birthDate: '1990-05-07'));
    expect(kiosk.calls.single['birth_date'], '1991-01-02');

    expect(await repo.syncBirthDate(_user(), _account()), isNull);
    expect(kiosk.calls, hasLength(1));
  });

  test('a new customer is created with the birth date', () async {
    final kiosk = _FakeKiosk();
    await BufeRepository(kiosk).createCustomer(
      fullname: 'Kovács Éva',
      dukappId: 42,
      email: 'eva@example.com',
      birthDate: DateTime(1990, 5, 7),
    );
    expect(kiosk.calls.single['birth_date'], '1990-05-07');
  });
}
