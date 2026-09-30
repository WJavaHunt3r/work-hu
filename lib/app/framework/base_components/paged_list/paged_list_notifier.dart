import 'package:flutter/foundation.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/base_provider.dart';

import 'list_query.dart';
import 'paged_state.dart';

/// Owns the items, paging, filter and sort of a server-paged list.
///
/// Subclasses implement [fetch]; the query lives in the state, so every reload and every next page
/// uses the current filter and sort. Starts loading the first page on creation.
abstract class PagedListNotifier<T, F> extends BaseDataNotifier<PagedState<T, F>> {
  PagedListNotifier(ListQuery<F> initialQuery) : super(PagedState(query: initialQuery)) {
    reload();
  }

  /// Loads one page of [query].
  Future<PaginatedResponse<T>> fetch(ListQuery<F> query, int page);

  /// Offered in the sort menu; empty hides it.
  List<SortOption> get sortOptions => const [];

  int _latestRequest = 0;
  bool _latestPending = false;

  /// Loads the first page again, replacing the items.
  Future<void> reload() => _load(0);

  /// Appends the next page, unless there is none or a request is already running.
  Future<void> loadMore() async {
    if (!state.hasMore || state.baseStatus.modelState.isAnyLoading) return;
    await _load(state.page + 1);
  }

  /// Repeats the request that failed last.
  Future<void> retry() => _load(state.requestedPage);

  Future<void> setFilter(F filter) {
    state = state.copyWith(query: state.query.copyWith(filter: filter));
    return reload();
  }

  Future<void> setSort(List<SortOrder> sort) {
    state = state.copyWith(query: state.query.copyWith(sort: sort));
    return reload();
  }

  /// Drops matching items locally, e.g. after a delete, without reloading.
  @protected
  void removeItems(bool Function(T item) test) {
    final items = state.items.where((item) => !test(item)).toList();
    state = state.copyWith(items: items, totalElements: state.totalElements - (state.items.length - items.length));
  }

  /// Replaces the loaded items locally, e.g. to reflect an edit, without reloading.
  @protected
  void updateItems(List<T> Function(List<T> items) update) {
    state = state.copyWith(items: update(state.items));
  }

  Future<void> _load(int page) async {
    final request = ++_latestRequest;
    _latestPending = true;
    state = state.copyWith(requestedPage: page);

    await executeApiCall<PaginatedResponse<T>>(
      () => fetch(state.query, page),
      background: true,
      onSuccess: (data) async {
        // A newer request (e.g. a sort change during paging) supersedes this one.
        if (request != _latestRequest) return;
        state = state.copyWith(
          items: page == 0 ? data.content : [...state.items, ...data.content],
          page: data.page.number,
          totalElements: data.page.totalElements,
          totalPages: data.page.totalPages,
        );
      },
    );

    if (!mounted) return;
    if (request == _latestRequest) {
      _latestPending = false;
    } else if (_latestPending) {
      // executeApiCall marked the superseded request as done; the newer one is still running.
      state = copyWithModelState(ModelState.backgroundLoading);
    }
  }

  @override
  PagedState<T, F> copyWithState(BaseState status) => state.copyWith(baseStatus: status);
}
