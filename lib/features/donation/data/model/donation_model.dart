import 'package:freezed_annotation/freezed_annotation.dart';

part 'donation_model.freezed.dart';

part 'donation_model.g.dart';

@freezed
class DonationModel with _$DonationModel {
  const factory DonationModel({
    num? id,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? description,
    String? descriptionNO,
    num? sum
  }) = _DonationModel;

  factory DonationModel.fromJson(Map<String, dynamic> json) => _$DonationModelFromJson(json);
}
