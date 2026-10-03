import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';

import 'list_query.dart';

part 'paged_state.freezed.dart';

@freezed
abstract class PagedState<T, F> with _$PagedState<T, F> {
  const factory PagedState({
    required ListQuery<F> query,
    @Default([]) List<T> items,

    /// Last page loaded into [items]; -1 before the first load.
    @Default(-1) int page,

    /// Page of the latest request, so the UI can tell a reload (0) from loading more.
    @Default(0) int requestedPage,
    @Default(0) int totalElements,
    @Default(0) int totalPages,
    @Default(BaseState()) BaseState baseStatus,
  }) = _PagedState<T, F>;

  const PagedState._();

  bool get hasMore => page + 1 < totalPages;
}
