import 'package:json_annotation/json_annotation.dart';

part 'coupon_model.g.dart';

@JsonSerializable()
class Coupon {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String description;
  @JsonKey(name: 'couponName')
  final String code;

  Coupon(
      {required this.id,
      required this.title,
      required this.description,
      required this.code});

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);

  Map<String, dynamic> toJson() => _$CouponToJson(this);
}
