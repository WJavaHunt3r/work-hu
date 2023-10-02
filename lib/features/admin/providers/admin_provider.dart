import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/features/admin/data/api/admin_api.dart';
import 'package:work_hu/features/admin/data/models/transaction_model.dart';
import 'package:work_hu/features/admin/data/repository/admin_repository.dart';
import 'package:work_hu/features/admin/data/state/admin_state.dart';

import '../../../work_hu_app.dart';

final adminApiProvider = Provider<AdminApi>((ref) => AdminApi());

final adminRepoProvider = Provider<AdminRepository>((ref) => AdminRepository(ref.read(adminApiProvider)));

final adminDataProvider = StateNotifierProvider<AdminDataNotifier, AdminState>(
    (ref) => AdminDataNotifier(ref.read(adminRepoProvider), ref.read(routerProvider)));

class AdminDataNotifier extends StateNotifier<AdminState> {
  AdminDataNotifier(this.adminRepository, this.router) : super(const AdminState()) {
    descriptionController = TextEditingController(text: "");

    descriptionController.addListener(_updateState);
  }

  final AdminRepository adminRepository;
  final GoRouter router;
  late final TextEditingController descriptionController;

  Future<void> createTransaction(TransactionType transactionType, Account account, [String? name]) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await adminRepository
          .createTransaction(TransactionModel(name: name ?? descriptionController.value.text, account: account))
          .then((data) async {
        state = state.copyWith(modelState: ModelState.empty);
        descriptionController.clear();
        router.push("/createTransaction", extra: {
          "transactionType": transactionType,
          "account": account,
          "description": data.name,
          "transactionId": data.id
        }).then((success) async {
          success != null && success == false ? await deleteTransaction(data.id!) : null;
        });
      });
    } on DioError catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.message);
    }
  }

  Future<void> deleteTransaction(num transactionId) async {
    state = state.copyWith(modelState: ModelState.processing);
    try {
      await adminRepository.deleteTransaction(transactionId).then((data) async {
        state = state.copyWith(modelState: ModelState.empty);
      });
    } on DioError catch (e) {
      state = state.copyWith(modelState: ModelState.error, message: e.message);
    }
  }

  void _updateState() {
    state = state.copyWith();
  }
}
