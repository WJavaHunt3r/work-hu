import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/title_provider.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/features/activities/view/activities_layout.dart';
import 'package:work_hu/features/admin/providers/drawer_provider.dart';
import 'package:work_hu/features/create_transactions/providers/create_transactions_provider.dart';
import 'package:work_hu/features/create_transactions/view/create_bmm_transaction_layout.dart';
import 'package:work_hu/features/create_transactions/view/create_transactions_layout.dart';
import 'package:work_hu/features/goal/view/goals_layout.dart';
import 'package:work_hu/features/transactions/view/transactions_layout.dart';
import 'package:work_hu/features/user_status/view/user_status_layout.dart';
import 'package:work_hu/features/users/view/users_layout.dart';

class AdminPage extends BasePage {
  const AdminPage({super.key, super.title = "", super.isListView = true});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return _screenWidgets[ref.watch(drawerDataProvider)];
  }

  @override
  Drawer? buildDrawer(BuildContext context, WidgetRef ref) {
    var role = ref.watch(userDataProvider)!.role;
    return Drawer(
      child: ListView(
        children: createDrawerList(role, ref, context),
      ),
    );
  }

  List<Widget> createDrawerList(Role role, WidgetRef ref, BuildContext context) {
    List<Widget> list = [];
    list.add(DrawerHeader(child: Text("Admin", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800))));
    list.add(createListTile(context: context, ref: ref, drawerNm: 0, title: "Activities"));
    if (role != Role.USER) {
      list.add(createListTile(context: context, ref: ref, drawerNm: 1, title: "User status"));
      list.add(createListTile(
          context: context,
          ref: ref,
          drawerNm: 2,
          title: "BMM Perfect Weeks",
          onTap: () {
            ref
                .watch(createTransactionsDataProvider.notifier)
                .setTransactionTypeAndAccount(TransactionType.BMM_PERFECT_WEEK, Account.OTHER);
            ref.watch(createTransactionsDataProvider.notifier).getUsers();
          }));
    }
    if (role == Role.ADMIN) {
      list.addAll([
        createListTile(
            context: context,
            ref: ref,
            drawerNm: 3,
            title: "MyShare Credits",
            onTap: () {
              ref
                  .watch(createTransactionsDataProvider.notifier)
                  .setTransactionTypeAndAccount(TransactionType.CREDIT, Account.MYSHARE);
              ref.watch(createTransactionsDataProvider.notifier).getUsers();
            }),
        createListTile(
            context: context,
            ref: ref,
            drawerNm: 4,
            title: "MyShare Hours",
            onTap: () {
              ref
                  .watch(createTransactionsDataProvider.notifier)
                  .setTransactionTypeAndAccount(TransactionType.HOURS, Account.MYSHARE);
              ref.watch(createTransactionsDataProvider.notifier).getUsers();
            }),
        createListTile(
            context: context,
            ref: ref,
            drawerNm: 5,
            title: "Samvirk Credit",
            onTap: () {
              ref
                  .watch(createTransactionsDataProvider.notifier)
                  .setTransactionTypeAndAccount(TransactionType.CREDIT, Account.SAMVIRK);
              ref.watch(createTransactionsDataProvider.notifier).getUsers();
            }),
        createListTile(
            context: context,
            ref: ref,
            drawerNm: 6,
            title: "Work Points",
            onTap: () {
              ref
                  .watch(createTransactionsDataProvider.notifier)
                  .setTransactionTypeAndAccount(TransactionType.POINT, Account.OTHER);
              ref.watch(createTransactionsDataProvider.notifier).getUsers();
            }),
        createListTile(context: context, ref: ref, drawerNm: 7, title: "Users"),
        createListTile(context: context, ref: ref, drawerNm: 8, title: "Goals"),
        createListTile(context: context, ref: ref, drawerNm: 9, title: "Transactions")
      ]);
    }

    return list;
  }

  static const List<Widget> _screenWidgets = [
    ActivitiesLayout(),
    UserStatusLayout(),
    CreateBMMTransactionLayout(),
    CreateTransactionsLayout(),
    CreateTransactionsLayout(),
    CreateTransactionsLayout(),
    CreateTransactionsLayout(),
    UsersLayout(),
    GoalsLayout(),
    TransactionsLayout()
  ];

  ListTile createListTile(
      {required BuildContext context,
      required WidgetRef ref,
      required num drawerNm,
      required String title,
      Function()? onTap}) {
    bool isSelected = ref.watch(drawerDataProvider) == drawerNm;
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.w800 : FontWeight.normal)),
      selected: isSelected,
      onTap: () {
        if (onTap != null) onTap();
        ref.watch(titleDataProvider.notifier).setTitle(title);
        ref.watch(drawerDataProvider.notifier).setCurrentDrawer(drawerNm.toInt());
        context.pop();
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context, WidgetRef ref) {
    return [
      IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.close))
    ];
  }
}
