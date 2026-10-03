import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';

void main() {
  const byName = SortOption(label: "name", properties: ["lastname", "firstname"]);
  const byStatus = SortOption(label: "status", properties: ["status"]);

  Future<List<SortOrder>?> pick(WidgetTester tester, {required List<SortOrder> current, required int itemIndex}) async {
    List<SortOrder>? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PagedSortButton(options: const [byName, byStatus], current: current, onSelected: (s) => selected = s),
        ),
      ),
    );
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pumpAndSettle();

    expect(find.byType(PopupMenuItem<List<SortOrder>>), findsNWidgets(4));
    // Only the current sort is checked.
    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(find.byType(PopupMenuItem<List<SortOrder>>).at(itemIndex));
    await tester.pumpAndSettle();
    return selected;
  }

  testWidgets('lists every option in both directions and returns the picked orders', (tester) async {
    final selected = await pick(tester, current: byName.orders(SortDir.asc), itemIndex: 3);
    expect(selected, [const SortOrder("status", SortDir.desc)]);
  });

  testWidgets('applies the direction to every property of an option', (tester) async {
    final selected = await pick(tester, current: byStatus.orders(SortDir.asc), itemIndex: 1);
    expect(selected, [const SortOrder("lastname", SortDir.desc), const SortOrder("firstname", SortDir.desc)]);
  });
}
