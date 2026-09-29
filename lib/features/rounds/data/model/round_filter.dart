import 'package:freezed_annotation/freezed_annotation.dart';

part 'round_filter.freezed.dart';
part 'round_filter.g.dart';

@freezed
abstract class RoundFilter with _$RoundFilter {
  const factory RoundFilter({int? seasonYear, bool? activeRound}) = _RoundFilter;

  factory RoundFilter.fromJson(Map<String, dynamic> json) => _$RoundFilterFromJson(json);
}
