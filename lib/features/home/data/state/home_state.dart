import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';
import 'package:work_hu/features/bufe/data/model/sumup_user_model.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    SumupUserModel? account,
    @Default([]) List<OrderEntry> orders,
    @Default([]) List<DonationModel> donations,
    @Default([]) List<SumupUserModel> familiyAccounts,
    @Default(BaseState()) BaseState status,
  }) = _HomeState;

  const HomeState._();
}
