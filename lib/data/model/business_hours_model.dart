  import 'package:json_annotation/json_annotation.dart';
part 'business_hours_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BusinessHoursModel {
  @JsonKey(name: 'isOpen', defaultValue: false)
  bool isOpen;

  @JsonKey(name: 'openTime')
  String? openTime;

  @JsonKey(name: 'closeTime')
  String? closeTime;

  BusinessHoursModel({
    required this.isOpen,
    this.openTime,
    this.closeTime,
  });

  factory BusinessHoursModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessHoursModelFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessHoursModelToJson(this);
}
