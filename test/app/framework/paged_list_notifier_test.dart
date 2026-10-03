import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';
import 'package:work_hu/app/models/mode_state.dart';

class _Request {
  _Request(this.query, this.page);

  final ListQuery<String> query;
  final int page;
  final completer = Completer<PaginatedResponse<int>>();

  /// Answers with items `page*10 .. page*10+1` out of [totalPages].
  void respond({int totalPages = 3}) => completer.complete(
    PaginatedResponse(
      content: [page * 10, page * 10 + 1],
      page: Page(totalPages: totalPages, totalElements: totalPages * 2, number: page, size: 2),
    ),
  );
}

class _TestNotifier extends PagedListNotifier<int, String> {
  _TestNotifier() : super(const ListQuery(filter: "a", size: 2));

  final requests = <_Request>[];

  @override
  Future<PaginatedResponse<int>> fetch(ListQuery<String> query, int page) {
    final request = _Request(query, page);
    requests.add(request);
    return request.completer.future;
  }

  void removeWhereForTest(bool Function(int) test) => removeItems(test);
}

Future<void> _settle() => Future<void>.delayed(Duration.zero);

void main() {
  test('loads the first page on creation and appends later pages', () async {
    final notifier = _TestNotifier();
    expect(notifier.state.baseStatus.modelState, ModelState.backgroundLoading);

    notifier.requests.single.respond();
    await _settle();
    expect(notifier.state.items, [0, 1]);
    expect(notifier.state.hasMore, isTrue);

    notifier.loadMore();
    notifier.loadMore(); // ignored while the first one runs
    expect(notifier.requests.length, 2);
    notifier.requests.last.respond();
    await _settle();
    expect(notifier.state.items, [0, 1, 10, 11]);
  });

  test('reload replaces the items instead of appending', () async {
    final notifier = _TestNotifier();
    notifier.requests.last.respond();
    await _settle();
    notifier.loadMore();
    notifier.requests.last.respond();
    await _settle();

    notifier.reload();
    expect(notifier.requests.last.page, 0);
    notifier.requests.last.respond();
    await _settle();
    expect(notifier.state.items, [0, 1]);
  });

  test('filter and sort are kept in the query for later pages', () async {
    final notifier = _TestNotifier();
    notifier.requests.last.respond();
    await _settle();

    notifier.setFilter("b");
    notifier.requests.last.respond();
    await _settle();
    notifier.setSort(const [SortOrder("name", SortDir.desc)]);
    notifier.requests.last.respond();
    await _settle();
    notifier.loadMore();

    final query = notifier.requests.last.query;
    expect(notifier.requests.last.page, 1);
    expect(query.filter, "b");
    expect(query.pageParams(1), {
      "page": 1,
      "size": 2,
      "sort": ["name,desc"],
    });
  });

  test('sort is left out of the params when empty', () {
    expect(const ListQuery(filter: "a").pageParams(0), {"page": 0, "size": 30});
  });

  test('removeItems drops matching items and adjusts the total', () async {
    final notifier = _TestNotifier();
    notifier.requests.last.respond();
    await _settle();

    notifier.removeWhereForTest((item) => item == 1);
    expect(notifier.state.items, [0]);
    expect(notifier.state.totalElements, 5);
  });

  test('a superseded response is dropped and does not end the loading state', () async {
    final notifier = _TestNotifier();
    notifier.requests.last.respond();
    await _settle();

    notifier.loadMore();
    final stalePage = notifier.requests.last;
    notifier.setSort(const [SortOrder("name")]);
    final fresh = notifier.requests.last;

    stalePage.respond();
    await _settle();
    expect(notifier.state.items, [0, 1]);
    expect(notifier.state.baseStatus.modelState, ModelState.backgroundLoading);

    fresh.respond();
    await _settle();
    expect(notifier.state.items, [0, 1]);
    expect(notifier.state.baseStatus.modelState, ModelState.success);
  });
}
