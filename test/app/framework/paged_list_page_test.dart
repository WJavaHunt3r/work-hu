import 'dart:async';

import 'package:flutter/material.dart' hide Page;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_list_page.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_notifier.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_state.dart';
import 'package:work_hu/app/framework/base_components/paginated_response.dart';

const _pageSize = 20;
const _tileHeight = 100.0;
const _totalPages = 10;

class _Request {
  _Request(this.page);

  final int page;
  final completer = Completer<PaginatedResponse<int>>();

  void respond() => completer.complete(
    PaginatedResponse(
      content: [for (var i = 0; i < _pageSize; i++) page * _pageSize + i],
      page: Page(totalPages: _totalPages, totalElements: _totalPages * _pageSize, number: page, size: _pageSize),
    ),
  );
}

class _TestNotifier extends PagedListNotifier<int, void> {
  _TestNotifier(this.requests) : super(const ListQuery(filter: null, size: _pageSize));

  final List<_Request> requests;

  @override
  Future<PaginatedResponse<int>> fetch(ListQuery<void> query, int page) {
    final request = _Request(page);
    requests.add(request);
    return request.completer.future;
  }
}

final _requests = <_Request>[];

final _testProvider = StateNotifierProvider.autoDispose<_TestNotifier, PagedState<int, void>>(
  (ref) => _TestNotifier(_requests),
);

class _TestPage extends BaseListPage {
  const _TestPage() : super(title: "test");

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestPageState();
}

class _TestPageState extends PagedListPageState<_TestPage, int, void, _TestNotifier> {
  @override
  get provider => _testProvider;

  @override
  Widget buildListTile(int item, int index) => SizedBox(height: _tileHeight, child: Text("$item"));
}

Future<void> _pumpPage(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: ScreenUtilInit(
        designSize: const Size(360, 640),
        builder: (context, child) => const MaterialApp(home: _TestPage()),
      ),
    ),
  );
}

/// Lets the response travel through the notifier without drawing a frame, so the list isn't laid out again.
Future<void> _settleMicrotasks() async {
  for (var i = 0; i < 20; i++) {
    await Future<void>.value();
  }
}

ScrollController _controller(WidgetTester tester) =>
    tester.state<_TestPageState>(find.byType(_TestPage)).getController();

void main() {
  setUp(_requests.clear);

  testWidgets('loads only the first page when it fills the screen', (tester) async {
    await _pumpPage(tester);
    _requests.single.respond();
    await tester.pumpAndSettle();

    expect(_requests.map((r) => r.page), [0]);
  });

  testWidgets('does not prefetch on load, even when the first page is less than the prefetch distance', (tester) async {
    // 1400px tall: page 0 (about 2000px) fills the screen but ends within 1.5 screens.
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await _pumpPage(tester);
    _requests.single.respond();
    await tester.pump();
    await tester.pump();

    expect(_requests.map((r) => r.page), [0]);
  });

  testWidgets('loads the next page when the first one does not fill the screen', (tester) async {
    // 2600px tall: page 0 (about 2000px) leaves empty space and can't be scrolled.
    tester.view.physicalSize = const Size(800, 2600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await _pumpPage(tester);
    _requests.single.respond();
    await tester.pump();
    await tester.pump();
    expect(_requests.map((r) => r.page), [0, 1]);

    // With page 1 the screen is full: stop.
    _requests.last.respond();
    await tester.pump();
    await tester.pump();
    expect(_requests.map((r) => r.page), [0, 1]);
  });

  testWidgets('a scroll right after a page arrives does not load the next one early', (tester) async {
    await _pumpPage(tester);
    _requests.single.respond();
    await tester.pumpAndSettle();

    // Near the end of page 0: prefetches page 1.
    final controller = _controller(tester);
    controller.jumpTo(controller.position.maxScrollExtent - 100);
    await tester.pump();
    expect(_requests.map((r) => r.page), [0, 1]);

    // Page 1 arrives, and the user keeps scrolling before the next frame lays it out.
    _requests.last.respond();
    await _settleMicrotasks();
    controller.jumpTo(controller.position.pixels + 10);
    await tester.pump();
    await tester.pump();

    // With page 1 laid out, 20 more tiles (2000px) are below: nothing to prefetch yet.
    expect(_requests.map((r) => r.page), [0, 1]);
  });
}
