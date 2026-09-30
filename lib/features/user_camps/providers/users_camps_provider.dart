import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/features/user_camps/data/api/user_camp_api.dart';
import 'package:work_hu/features/user_camps/data/model/user_camp_model.dart';
import 'package:work_hu/features/user_camps/data/repository/user_camp_repository.dart';

final userCampApiProvider = Provider<UserCampApi>((ref) => UserCampApi());

final userCampRepoProvider = Provider<UserCampRepository>((ref) => UserCampRepository(ref.read(userCampApiProvider)));

/// Filtered by season year.
final userCampDataProvider = StateNotifierProvider.autoDispose<UserCampDataNotifier, PagedState<UserCampModel, int>>(
  (ref) => UserCampDataNotifier(ref.read(userCampRepoProvider)),
);

class UserCampDataNotifier extends PagedListNotifier<UserCampModel, int> {
  UserCampDataNotifier(this.userCampRepository) : super(ListQuery(filter: DateTime.now().year));

  final UserCampRepository userCampRepository;

  /// Not paged by the server: returns the whole season at once, sorted by name.
  @override
  Future<PaginatedResponse<UserCampModel>> fetch(ListQuery<int> query, int page) async {
    final userCamps = await userCampRepository.getUserCamps(seasonYear: query.filter);
    userCamps.sort((a, b) => a.userModel.getFullName().compareTo(b.userModel.getFullName()));
    return PaginatedResponse.all(userCamps);
  }
}
