/// The kiosk's sales points and what they sell (`external-locations`, `external-catalog`), for the menu page.
library;

/// A sales point (Büfé, Kávézó, ...); the kiosk lists only active ones, never test ones.
class KioskLocation {
  const KioskLocation({required this.id, required this.name, this.address});

  final String id;
  final String name;
  final String? address;

  factory KioskLocation.fromJson(Map<String, dynamic> json) => KioskLocation(
    id: json['id'] as String,
    name: json['name'] as String? ?? '',
    address: (json['address'] as String?)?.trim().isEmpty ?? true ? null : (json['address'] as String).trim(),
  );
}

/// A category; categories form a tree through [parentId] (null = top level), ordered by [sortOrder].
class KioskCategory {
  const KioskCategory({
    required this.id,
    required this.name,
    this.parentId,
    this.imageUrl,
    this.icon,
    this.color,
    this.sortOrder = 0,
    this.showName = true,
  });

  final String id;
  final String name;
  final String? parentId;
  final String? imageUrl;
  final String? icon;

  /// "#RRGGBB" or null.
  final String? color;
  final int sortOrder;
  final bool showName;

  factory KioskCategory.fromJson(Map<String, dynamic> json) => KioskCategory(
    id: json['id'] as String,
    name: json['name'] as String? ?? '',
    parentId: json['parent_id'] as String?,
    imageUrl: json['image_url'] as String?,
    icon: json['icon'] as String?,
    color: json['color'] as String?,
    sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    showName: json['show_name'] as bool? ?? true,
  );
}

/// A product at one sales point. [price] is what that sales point charges now; [youthPrice] (if set) applies to
/// customers under 18; [minAge] (if set) is the age a customer must have reached to buy it.
class KioskProduct {
  const KioskProduct({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.imageUrl,
    this.youthPrice,
    this.minAge,
    this.returnable = false,
    this.categoryIds = const [],
  });

  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final num price;
  final num? youthPrice;
  final int? minAge;

  /// A bottle or can with a deposit.
  final bool returnable;
  final List<String> categoryIds;

  factory KioskProduct.fromJson(Map<String, dynamic> json) => KioskProduct(
    id: json['id'] as String,
    name: json['name'] as String? ?? '',
    description: (json['description'] as String?)?.trim().isEmpty ?? true ? null : json['description'] as String,
    imageUrl: json['image_url'] as String?,
    price: json['price'] as num? ?? 0,
    youthPrice: json['youth_price'] as num?,
    minAge: (json['min_age'] as num?)?.toInt(),
    returnable: json['is_returnable'] as bool? ?? false,
    categoryIds: [for (final id in (json['category_ids'] as List? ?? const [])) id as String],
  );

  /// What [age] pays: the youth price under 18 when there is one. Unknown age = the normal price.
  num priceFor(int? age) => youthPrice != null && age != null && age < 18 ? youthPrice! : price;

  /// Whether a customer of [age] may buy it: true without an age limit; false when the age is unknown, as the kiosk
  /// refuses age-restricted products to customers without a birth date.
  bool allowedFor(int? age) => minAge == null || (age != null && age >= minAge!);
}

class KioskCatalog {
  const KioskCatalog({required this.location, required this.categories, required this.products});

  final KioskLocation location;
  final List<KioskCategory> categories;
  final List<KioskProduct> products;

  factory KioskCatalog.fromJson(Map<String, dynamic> json) => KioskCatalog(
    location: KioskLocation.fromJson(json['location'] as Map<String, dynamic>),
    categories: [
      for (final c in (json['categories'] as List? ?? const [])) KioskCategory.fromJson(c as Map<String, dynamic>),
    ],
    products: [
      for (final p in (json['products'] as List? ?? const [])) KioskProduct.fromJson(p as Map<String, dynamic>),
    ],
  );

  List<KioskCategory> _childrenOf(String? parentId) =>
      categories.where((c) => c.parentId == parentId).toList()..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  /// The top-level categories that have products (in their own or their subcategories), in order.
  List<KioskCategory> get topCategories => [
    for (final c in _childrenOf(null))
      if (sections(c.id).isNotEmpty) c,
  ];

  /// Products without a category (shown under "other").
  List<KioskProduct> get uncategorized => products.where((p) => p.categoryIds.isEmpty).toList();

  /// What a top-level category shows: its own products first, then each subcategory (at any depth, depth first, in
  /// order) with its products; categories without products are left out.
  List<KioskSection> sections(String topId) {
    final result = <KioskSection>[];
    void visit(String id, KioskCategory? category, int depth) {
      final own = products.where((p) => p.categoryIds.contains(id)).toList();
      if (own.isNotEmpty) result.add(KioskSection(category: category, depth: depth, products: own));
      for (final child in _childrenOf(id)) {
        visit(child.id, child, depth + 1);
      }
    }

    visit(topId, null, 0);
    return result;
  }

  /// Products whose name or description contains [query] (any case), for the search field.
  List<KioskProduct> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return products
        .where((p) => p.name.toLowerCase().contains(q) || (p.description?.toLowerCase().contains(q) ?? false))
        .toList();
  }
}

/// A heading (null = the top-level category itself) and its products.
class KioskSection {
  const KioskSection({required this.category, required this.depth, required this.products});

  final KioskCategory? category;
  final int depth;
  final List<KioskProduct> products;
}

/// Age in whole years on [today] (a birthday counts from that day); null without a birth date.
int? ageOn(DateTime? birthDate, DateTime today) {
  if (birthDate == null) return null;
  var age = today.year - birthDate.year;
  if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) age--;
  return age;
}
