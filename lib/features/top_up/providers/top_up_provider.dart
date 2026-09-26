import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/src/providers/legacy/state_notifier_provider.dart' show StateNotifierProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/bufe/data/model/sumup_create_checkout_response.dart';
import 'package:work_hu/features/bufe/data/repository/bufe_repository.dart';
import 'package:work_hu/features/bufe/providers/bufe_provider.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/top_up/data/state/top_up_state.dart';

final topUpDataProvider =
    StateNotifierProvider.autoDispose<TopUpDataNotifier, TopUpState>((ref) => TopUpDataNotifier(ref.watch(bufeRepoProvider)));

class TopUpDataNotifier extends BaseDataNotifier<TopUpState> {
  TopUpDataNotifier(this._bufeRepository) : super(const TopUpState()) {}

  final BufeRepository _bufeRepository;
  final UserModel? currentUser = locator<UserProvider>().user;

  Future<void> topUp({required int amount}) async {
    await executeApiCall<SumupCreateCheckoutResponse?>(
        () => _bufeRepository.createSumupCheckout(
            dukappId: currentUser!.id,
            description: "top_up_customer_id:${currentUser!.id}",
            redirectUrl: "https://dukapp.bcc-ktk.org/balance/topUp/success/{checkout_reference}",
            returnUrl: "https://fngkzlmhfegroyulcgfc.supabase.co/functions/v1/sumup-webhook",
            amount: amount), onSuccess: (data) async {
      state = state.copyWith(hostedUrl: data?.hosted_url);
    });
  }

  @override
  TopUpState copyWithState(BaseState status) {
    return state.copyWith(status: status);
  }
}
