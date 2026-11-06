import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/features/bufe/data/model/kiosk_catalog.dart';
import 'package:work_hu/features/bufe/providers/bufe_provider.dart';
import 'package:work_hu/features/bufe/view/kiosk_menu_page.dart';
import 'package:work_hu/features/login/data/model/user_model.dart';

/// The shape the kiosk answers with (taken from the live external-catalog): a tree of categories, products with
/// youth prices and age limits, and one product without a category.
Map<String, dynamic> _catalogJson() => {
  'location': {'id': 'loc-1', 'name': 'Büfé'},
  'categories': [
    {'id': 'sweets', 'name': 'Édesség', 'parent_id': null, 'icon': '🍬', 'sort_order': 1, 'show_name': true},
    {'id': 'drinks', 'name': 'Italok', 'parent_id': null, 'sort_order': 0, 'show_name': true},
    {'id': 'haribo', 'name': 'Haribo', 'parent_id': 'sweets', 'sort_order': 2, 'show_name': true},
    {'id': 'gold', 'name': 'Goldbären', 'parent_id': 'haribo', 'sort_order': 0, 'show_name': true},
    {'id': 'empty', 'name': 'Üres', 'parent_id': null, 'sort_order': 3, 'show_name': true},
  ],
  'products': [
    {
      'id': 'cola',
      'name': 'Coca-Cola 0,5L',
      'price': 450,
      'youth_price': null,
      'min_age': null,
      'is_returnable': true,
      'category_ids': ['drinks'],
    },
    {
      'id': 'energy',
      'name': 'Energiaital',
      'price': 600,
      'youth_price': null,
      'min_age': 18,
      'is_returnable': false,
      'category_ids': ['drinks'],
    },
    {
      'id': 'bueno',
      'name': 'Bueno',
      'price': 450,
      'youth_price': 350,
      'min_age': null,
      'is_returnable': false,
      'category_ids': ['sweets'],
    },
    {'id': 'bear', 'name': 'Gumimaci', 'price': 500, 'category_ids': ['gold']},
    {'id': 'coffee', 'name': 'Cappuccino', 'description': 'Espresso tejhabbal', 'price': 550, 'category_ids': []},
  ],
};

class _FakeUser extends ChangeNotifier implements UserProvider {
  _FakeUser(this.birthDate);

  final DateTime? birthDate;

  @override
  UserModel? get user =>
      UserModel(id: 1, firstname: 'T', lastname: 'U', role: Role.USER, changedPassword: true, birthDate: birthDate);

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  final catalog = KioskCatalog.fromJson(_catalogJson());

  group('catalog', () {
    test('top categories come in order, without empty ones, and products without a category are kept apart', () {
      expect(catalog.topCategories.map((c) => c.name), ['Italok', 'Édesség']);
      expect(catalog.uncategorized.single.name, 'Cappuccino');
    });

    test('a category shows its own products, then its subcategories at any depth', () {
      final sections = catalog.sections('sweets');
      expect(sections.map((s) => s.category?.name), [null, 'Goldbären']); // Haribo itself has no products
      expect(sections.first.products.single.name, 'Bueno');
      expect(sections.last.depth, 2);
    });

    test('the youth price is for under 18, and an age limit needs a known age', () {
      final bueno = catalog.products.firstWhere((p) => p.id == 'bueno');
      final energy = catalog.products.firstWhere((p) => p.id == 'energy');
      expect(bueno.priceFor(17), 350);
      expect(bueno.priceFor(18), 450);
      expect(bueno.priceFor(null), 450);
      expect(energy.allowedFor(18), isTrue);
      expect(energy.allowedFor(17), isFalse);
      expect(energy.allowedFor(null), isFalse); // the kiosk refuses age-restricted products without a birth date
    });

    test('the age counts from the birthday itself', () {
      expect(ageOn(DateTime(2008, 11, 6), DateTime(2026, 11, 6)), 18);
      expect(ageOn(DateTime(2008, 11, 7), DateTime(2026, 11, 6)), 17);
      expect(ageOn(null, DateTime(2026, 11, 6)), isNull);
    });

    test('search looks in names and descriptions, any case', () {
      expect(catalog.search('espresso').single.name, 'Cappuccino');
      expect(catalog.search('COLA').single.name, 'Coca-Cola 0,5L');
      expect(catalog.search('  '), isEmpty);
    });
  });

  group('page', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      LocalJsonLocalization.delegate.directories = ['lib/I18n'];
      await LocalJsonLocalization.delegate.load(const Locale('hu', 'HU'));
    });

    Future<void> pumpPage(WidgetTester tester, {DateTime? birthDate}) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userDataProvider.overrideWith((ref) => _FakeUser(birthDate)),
            kioskLocationsProvider.overrideWith(
              (ref) async => const [KioskLocation(id: 'loc-1', name: 'Büfé'), KioskLocation(id: 'loc-2', name: 'Kávézó')],
            ),
            kioskCatalogProvider.overrideWith((ref, id) async => catalog),
          ],
          child: ScreenUtilInit(
            designSize: const Size(360, 640),
            builder: (context, child) => const MaterialApp(home: KioskMenuPage()),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('an adult sees the normal prices and may buy the age-restricted drink', (tester) async {
      await pumpPage(tester, birthDate: DateTime(1990, 1, 1));

      expect(find.text('Büfé'), findsOneWidget); // two sales points: a chip each
      expect(find.text('Kávézó'), findsOneWidget);
      expect(find.text('Energiaital'), findsOneWidget); // the first category, Italok
      expect(find.text('18+'), findsOneWidget);
      expect(find.textContaining('születési dátum'), findsNothing);

      await tester.tap(find.text('Édesség'));
      await tester.pumpAndSettle();
      expect(find.text('Bueno'), findsOneWidget);
      expect(find.text('Ifjúsági ár'), findsNothing);
      expect(find.text('Goldbären'), findsOneWidget); // a subcategory heading
    });

    testWidgets('a teenager gets the youth price and is told about the age limit', (tester) async {
      await pumpPage(tester, birthDate: DateTime(DateTime.now().year - 15, 1, 1));

      expect(find.text('Csak 18 éves kortól'), findsOneWidget);
      await tester.tap(find.text('Édesség'));
      await tester.pumpAndSettle();
      expect(find.text('Ifjúsági ár'), findsOneWidget);
    });

    testWidgets('without a birth date the page says it is needed for age-restricted products', (tester) async {
      await pumpPage(tester);

      expect(find.textContaining('Személyes adatok'), findsOneWidget);
      expect(find.textContaining('születési dátum kell'), findsOneWidget);
    });

    testWidgets('search finds products in every category', (tester) async {
      await pumpPage(tester, birthDate: DateTime(1990, 1, 1));

      await tester.enterText(find.byType(TextField), 'cappu');
      await tester.pumpAndSettle();
      expect(find.text('Cappuccino'), findsOneWidget);
      expect(find.text('Energiaital'), findsNothing);
    });
  });
}
