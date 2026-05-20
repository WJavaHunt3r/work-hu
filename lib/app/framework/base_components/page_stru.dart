import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_stru.freezed.dart';

part 'page_stru.g.dart';

@freezed
abstract class PageStru with _$PageStru {
  const factory PageStru({
    @Default(0) int page,
    @Default(30) int size,
    @Default([]) List<String> sort,
  }) = _PageStru;

  factory PageStru.fromJson(Map<String, dynamic> json) => _$PageStruFromJson(json);
}
