import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';

part 'admin_state.freezed.dart';

@freezed
abstract class AdminState with _$AdminState {
  const factory AdminState({@Default("") String description, DateTime? transactionDate, @Default(BaseState()) BaseState status}) =
      _AdminState;

  const AdminState._();
}
