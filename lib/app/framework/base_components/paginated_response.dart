import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_response.freezed.dart';
part 'paginated_response.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class PaginatedResponse<T> with _$PaginatedResponse<T> {
  const factory PaginatedResponse({required List<T> content, required Page page}) = _PaginatedResponse;

  /// A complete, unpaged list as a single page, for endpoints that return everything at once.
  factory PaginatedResponse.all(List<T> content) => PaginatedResponse(
    content: content,
    page: Page(totalPages: 1, totalElements: content.length, number: 0, size: content.length),
  );

  /// A page of an endpoint that pages by `offset`/`limit`/`total` instead of page numbers.
  factory PaginatedResponse.fromOffset({
    required List<T> content,
    required int offset,
    required int limit,
    required int total,
  }) => PaginatedResponse(
    content: content,
    page: Page(
      totalPages: limit <= 0 ? 1 : (total / limit).ceil(),
      totalElements: total,
      number: limit <= 0 ? 0 : offset ~/ limit,
      size: limit,
    ),
  );

  factory PaginatedResponse.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$PaginatedResponseFromJson(json, fromJsonT);
}

@freezed
abstract class Page with _$Page {
  const factory Page({required int totalPages, required int totalElements, required int number, required int size}) =
      _Page;

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
}
