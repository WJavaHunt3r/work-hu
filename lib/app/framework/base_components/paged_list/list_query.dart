import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_query.freezed.dart';

enum SortDir { asc, desc }

/// One `property,direction` term of a Spring `sort` parameter.
@freezed
abstract class SortOrder with _$SortOrder {
  const factory SortOrder(String property, [@Default(SortDir.asc) SortDir dir]) = _SortOrder;

  const SortOrder._();

  String toParam() => "$property,${dir.name}";
}

/// A choice in the sort menu. The menu offers every option in both directions.
class SortOption {
  const SortOption({required this.label, required this.properties});

  /// i18n key.
  final String label;

  /// Sorted by in this order, e.g. `["user.lastname", "user.firstname"]`.
  final List<String> properties;

  List<SortOrder> orders(SortDir dir) => [for (final p in properties) SortOrder(p, dir)];
}

/// Everything a list request needs apart from the page number: the filter, the sort and the page size.
@freezed
abstract class ListQuery<F> with _$ListQuery<F> {
  const factory ListQuery({required F filter, @Default([]) List<SortOrder> sort, @Default(30) int size}) =
      _ListQuery<F>;

  const ListQuery._();

  /// The `page`, `size` and `sort` query parameters. Filters serialize themselves and are merged in by the API.
  /// Without a sort, `sort` is left out so the server's default order applies.
  Map<String, dynamic> pageParams(int page) => {
    "page": page,
    "size": size,
    if (sort.isNotEmpty) "sort": [for (final s in sort) s.toParam()],
  };
}
