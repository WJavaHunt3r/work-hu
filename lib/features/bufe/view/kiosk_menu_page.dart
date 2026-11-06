import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/features/bufe/data/model/kiosk_catalog.dart';
import 'package:work_hu/features/bufe/providers/bufe_provider.dart';
import 'package:work_hu/features/utils.dart';

/// What the kiosk's sales points sell (`/balance/menu`): pick a sales point, then a category; prices are the ones that
/// sales point charges, the youth price for users under 18, and products the user is too young for (or, without a
/// birth date, any age-restricted one) are marked. Read only: buying happens at the kiosk.
class KioskMenuPage extends ConsumerStatefulWidget {
  const KioskMenuPage({super.key});

  @override
  ConsumerState<KioskMenuPage> createState() => _KioskMenuPageState();
}

class _KioskMenuPageState extends ConsumerState<KioskMenuPage> {
  static const _locationKey = 'kiosk_menu_location';
  static const _other = '';

  String? _locationId;
  String? _categoryId;
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _loadLocation() async {
    try {
      final saved = (await SharedPreferences.getInstance()).getString(_locationKey);
      if (saved != null && mounted && _locationId == null) setState(() => _locationId = saved);
    } catch (_) {
      // the first sales point then
    }
  }

  void _pickLocation(String id) {
    setState(() {
      _locationId = id;
      _categoryId = null;
    });
    SharedPreferences.getInstance().then((p) => p.setString(_locationKey, id)).catchError((_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locations = ref.watch(kioskLocationsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("kiosk_menu_title".i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: locations.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (_, _) =>
            _Message(text: "kiosk_menu_error".i18n(), onRetry: () => ref.invalidate(kioskLocationsProvider)),
        data: (list) {
          if (list.isEmpty) return _Message(text: "kiosk_menu_no_locations".i18n());
          final location = list.firstWhere((l) => l.id == _locationId, orElse: () => list.first);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (list.length > 1)
                Padding(
                  padding: EdgeInsets.fromLTRB(16.sp, 8.sp, 16.sp, 0),
                  child: Wrap(
                    spacing: 8.sp,
                    children: [
                      for (final l in list)
                        ChoiceChip(
                          label: Text(l.name),
                          selected: l.id == location.id,
                          onSelected: (_) => _pickLocation(l.id),
                        ),
                    ],
                  ),
                ),
              Expanded(child: _catalog(theme, location)),
            ],
          );
        },
      ),
    );
  }

  Widget _catalog(ThemeData theme, KioskLocation location) {
    final catalog = ref.watch(kioskCatalogProvider(location.id));
    final age = ageOn(ref.watch(userDataProvider).user?.birthDate, DateTime.now());
    return catalog.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (_, _) =>
          _Message(text: "kiosk_menu_error".i18n(), onRetry: () => ref.invalidate(kioskCatalogProvider(location.id))),
      data: (data) {
        final tops = data.topCategories;
        final other = data.uncategorized;
        final query = _search.text;
        final found = data.search(query);
        final selected = _categoryId != null && (tops.any((c) => c.id == _categoryId) || _categoryId == _other)
            ? _categoryId!
            : (tops.isNotEmpty ? tops.first.id : _other);
        return RefreshIndicator.adaptive(
          onRefresh: () async => ref.refresh(kioskCatalogProvider(location.id).future),
          child: ListView(
            padding: EdgeInsets.all(16.sp),
            children: [
              TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "kiosk_menu_search".i18n(),
                  border: const OutlineInputBorder(),
                  isDense: true,
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: "kiosk_menu_search_clear".i18n(),
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(_search.clear),
                        ),
                ),
              ),
              SizedBox(height: 12.sp),
              if (age == null && data.products.any((p) => p.minAge != null)) ...[
                _AgeHint(text: "kiosk_menu_no_birth_date".i18n()),
                SizedBox(height: 12.sp),
              ],
              if (query.trim().isNotEmpty) ...[
                if (found.isEmpty)
                  Padding(padding: EdgeInsets.all(16.sp), child: Text("kiosk_menu_nothing_found".i18n()))
                else
                  _ProductList(products: found, age: age),
              ] else ...[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final c in tops)
                        Padding(
                          padding: EdgeInsets.only(right: 8.sp),
                          child: ChoiceChip(
                            avatar: c.icon == null ? null : Text(c.icon!),
                            label: Text(c.name),
                            selected: c.id == selected,
                            onSelected: (_) => setState(() => _categoryId = c.id),
                          ),
                        ),
                      if (other.isNotEmpty)
                        ChoiceChip(
                          label: Text("kiosk_menu_other".i18n()),
                          selected: selected == _other,
                          onSelected: (_) => setState(() => _categoryId = _other),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 12.sp),
                if (tops.isEmpty && other.isEmpty)
                  Padding(padding: EdgeInsets.all(16.sp), child: Text("kiosk_menu_empty".i18n()))
                else if (selected == _other)
                  _ProductList(products: other, age: age)
                else
                  for (final section in data.sections(selected)) ...[
                    if (section.category != null)
                      Padding(
                        padding: EdgeInsets.fromLTRB(4.sp, 12.sp, 4.sp, 8.sp),
                        child: Text(
                          section.category!.name,
                          style: (section.depth > 1 ? theme.textTheme.titleSmall : theme.textTheme.titleMedium)
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    _ProductList(products: section.products, age: age),
                  ],
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList({required this.products, required this.age});

  final List<KioskProduct> products;
  final int? age;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BaseContainer(
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 4.sp),
      child: Column(
        children: [
          for (var i = 0; i < products.length; i++)
            Container(
              decoration: i == products.length - 1
                  ? null
                  : BoxDecoration(
                      border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
                    ),
              child: _ProductRow(product: products[i], age: age),
            ),
        ],
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.product, required this.age});

  final KioskProduct product;
  final int? age;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allowed = product.allowedFor(age);
    final price = product.priceFor(age);
    final youth = price != product.price;
    final hint = theme.textTheme.bodySmall?.copyWith(color: theme.hintColor);
    return Opacity(
      opacity: allowed ? 1 : 0.55,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.sp),
              child: SizedBox(
                width: 56.sp,
                height: 56.sp,
                child: product.imageUrl == null
                    ? ColoredBox(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(Icons.fastfood_outlined, color: theme.hintColor),
                      )
                    : Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => ColoredBox(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Icon(Icons.fastfood_outlined, color: theme.hintColor),
                        ),
                      ),
              ),
            ),
            SizedBox(width: 12.sp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                  if (product.description != null) Text(product.description!, style: hint),
                  SizedBox(height: 4.sp),
                  Wrap(
                    spacing: 6.sp,
                    runSpacing: 4.sp,
                    children: [
                      if (product.minAge != null)
                        _Tag(
                          text: allowed
                              ? "kiosk_menu_min_age".i18n([product.minAge.toString()])
                              : (age == null
                                    ? "kiosk_menu_min_age_unknown".i18n([product.minAge.toString()])
                                    : "kiosk_menu_too_young".i18n([product.minAge.toString()])),
                          color: allowed ? theme.colorScheme.secondary : theme.colorScheme.error,
                        ),
                      if (youth) _Tag(text: "kiosk_menu_youth_price".i18n(), color: theme.colorScheme.primary),
                      if (product.returnable) _Tag(text: "kiosk_menu_returnable".i18n(), color: theme.hintColor),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.sp),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(Utils.creditFormatting(price), style: const TextStyle(fontWeight: FontWeight.bold)),
                if (youth)
                  Text(
                    Utils.creditFormatting(product.price),
                    style: hint?.copyWith(decoration: TextDecoration.lineThrough),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 6.sp, vertical: 2.sp),
    decoration: BoxDecoration(
      border: Border.all(color: color),
      borderRadius: BorderRadius.circular(6.sp),
    ),
    child: Text(text, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color)),
  );
}

class _AgeHint extends StatelessWidget {
  const _AgeHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BaseContainer(
      padding: EdgeInsets.all(12.sp),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: theme.colorScheme.primary),
          SizedBox(width: 10.sp),
          Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.onRetry});

  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(24.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            SizedBox(height: 12.sp),
            FilledButton.tonal(onPressed: onRetry, child: Text("kiosk_menu_retry".i18n())),
          ],
        ],
      ),
    ),
  );
}
