import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/features/create_transactions/view/create_transaction_page.dart';

class CreatePointsTransactionPage extends CreateTransactionPage {
  const CreatePointsTransactionPage({super.key})
    : super(title: "admin_points", transactionType: TransactionType.POINT, account: Account.OTHER);
}
