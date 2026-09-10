import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';
import 'package:work_hu/features/transaction_items/data/models/transaction_item_model.dart';
import 'package:work_hu/features/user_rounds/data/model/user_round_head_model.dart';
import 'package:work_hu/features/user_rounds/data/model/user_round_model.dart';
import 'package:work_hu/features/user_status/data/model/user_status_model.dart';

part 'status_state.freezed.dart';

@freezed
abstract class StatusState with _$StatusState {
  const factory StatusState({
    @Default([]) List<UserModel> children,
    @Default([]) List<UserStatusModel> statuses,
    @Default([]) List<UserRoundModel> userRounds,
    @Default(UserRoundHeadModel(onTrackCount: 0, goalCount: 0, churchGoal: 0, toOnTrackCount: 0))
    UserRoundHeadModel userRoundHead,
    @Default([]) List<TransactionItemModel> transactions,
    @Default(BaseState()) BaseState status,
  }) = _StatusState;

  const StatusState._();
}
