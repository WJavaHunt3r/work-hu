import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/features/create_transactions/view/create_transaction_page.dart';

class CreateSamvirkTransactionPage extends CreateTransactionPage {
  const CreateSamvirkTransactionPage({super.key})
    : super(title: "admin_samvirk_credit", transactionType: TransactionType.CREDIT, account: Account.SAMVIRK);
}
