import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'business_hours_model.g.dart';

@JsonSerializable(explicitToJson: true)
class business_hours_model {
  @JsonKey(name: 'is_open')
  final bool isOpen;
  @JsonKey(name: 'opening_time')
  final String? openTime;
  @JsonKey(name: '_shop_id')
  final String? id;
  @JsonKey(name: 'close_time')
  final String? closeTime;

  business_hours_model(
      {required this.isOpen, required this.id, this.openTime, this.closeTime});
  factory business_hours_model.fromJson(Map<String, dynamic> json) => _$business_hours_modelFromJson(json);

  Map<String, dynamic> toJson() => _$business_hours_modelToJson(this);

}
