import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_response.g.dart';

part 'paginated_response.freezed.dart';

@Freezed(genericArgumentFactories: true)
class PaginatedResponse<T> with _$PaginatedResponse<T> {

  const factory PaginatedResponse({
    required List<T> content,
    required Page page
  }) = _PaginatedResponse;

  factory PaginatedResponse.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$PaginatedResponseFromJson(json, fromJsonT);

}

@freezed
class Page with _$Page {
  const factory Page({
    required int totalPages,
    required int totalElements,
    required int number,
    required int size,
}) = _Page;

  factory Page.fromJson(Map<String, dynamic> json) =>
      _$PageFromJson(json);

}