  import 'package:json_annotation/json_annotation.dart';
  part 'business_hours_model.g.dart';

  @JsonSerializable(explicitToJson: true)
  class business_hours_model {
    @JsonKey(name: 'isOpen', defaultValue: false)
    bool isOpen;
    @JsonKey(name: 'openTime')
    String? openTime;
    @JsonKey(name: 'closeTime')
    String? closeTime;

    business_hours_model({required this.isOpen, this.openTime, this.closeTime});
    factory business_hours_model.fromJson(Map<String, dynamic> json) =>
        _$business_hours_modelFromJson(json);

    Map<String, dynamic> toJson() => _$business_hours_modelToJson(this);
  }
