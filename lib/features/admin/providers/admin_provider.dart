import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/src/providers/legacy/state_notifier_provider.dart' show StateNotifierProvider;
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/providers/base_provider.dart';
import 'package:work_hu/features/admin/data/state/admin_state.dart';

final adminDataProvider = StateNotifierProvider.autoDispose<AdminDataNotifier, AdminState>(
  (ref) => AdminDataNotifier(),
);

class AdminDataNotifier extends BaseDataNotifier<AdminState> {
  AdminDataNotifier() : super(const AdminState()) {}

  @override
  AdminState copyWithState(BaseState status) {
    return state.copyWith(status: status);
  }
}
