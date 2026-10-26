import 'package:flutter_test/flutter_test.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/utils.dart';

void main() {
  // Tests run on the Dart VM like the apps: a double whole number prints as "4000.0" here, as it did on Android
  test('the MyShare credit CSV has whole-number amounts, also from hours in doubles', () {
    final user = UserModel(
      id: 255,
      firstname: 'André',
      lastname: 'Wagner',
      role: Role.USER,
      changedPassword: true,
      myShareID: 28163,
      birthDate: DateTime(2000, 1, 18),
    );
    final item = TransactionItemModel(
      transactionDate: DateTime(2026, 10, 25),
      description: 'Takarítás',
      createUserId: 1,
      userName: 'Wagner André',
      points: 16,
      transactionType: TransactionType.DUKA_MUNKA,
      account: Account.MYSHARE,
      credit: 4.0 * 1000,
      hours: 4.0,
      userId: 255,
    );

    final csv = Utils.creditCsv([item], DateTime(2026, 10, 25), 'Takarítás', [user]);
    final row = csv.split(RegExp(r'\r?\n'))[1].split(',');

    expect(row[0], '28163');
    expect(row[6], '4000');
    expect(csv, isNot(contains('.0')));
  });
}
