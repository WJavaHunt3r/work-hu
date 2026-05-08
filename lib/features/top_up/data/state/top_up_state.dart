import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';
import 'package:work_hu/features/bufe/data/model/sumup_user_model.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';

part 'top_up_state.freezed.dart';

@freezed
abstract class TopUpState with _$TopUpState {
  const factory TopUpState({
    String? hostedUrl,
    @Default(BaseState()) BaseState status,
  }) = _TopUpState;

  const TopUpState._();
}
