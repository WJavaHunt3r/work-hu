import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/user_provider.dart';
import 'package:work_hu/dukapp.dart';
import 'package:work_hu/features/admin/data/state/admin_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

final adminDataProvider = StateNotifierProvider<AdminDataNotifier, AdminState>(
    (ref) => AdminDataNotifier(ref.read(routerProvider), ref.read(userDataProvider)));

class AdminDataNotifier extends StateNotifier<AdminState> {
  AdminDataNotifier(
    this.router,
    this.currentUser,
  ) : super(const AdminState()) {
    descriptionController = TextEditingController(text: "");
    dateController = TextEditingController(text: "");

    descriptionController.addListener(_updateState);
    dateController.addListener(_updateState);
  }

  final GoRouter router;
  late final TextEditingController descriptionController;
  late final TextEditingController dateController;
  final UserModel? currentUser;

  String getTitle({required Account account, required TransactionType transactionType}) {
    return account == Account.OTHER
        ? transactionType == TransactionType.BMM_PERFECT_WEEK
            ? "Tökéletes BMM hét"
            : "Points"
        : account == Account.SAMVIRK
            ? "Samvirk credits"
            : account == Account.MYSHARE
                ? transactionType == TransactionType.HOURS
                    ? "MyShare hours"
                    : "MyShare credits"
                : "";
  }

  void _updateState() {
    state = state.copyWith(
        transactionDate: DateTime.tryParse(dateController.value.text), description: descriptionController.value.text);
  }

  bool isEmpty() {
    return descriptionController.value.text.isEmpty;
  }
}
