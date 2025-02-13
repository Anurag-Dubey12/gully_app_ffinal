import 'package:gully_app/data/model/package_model.dart';
import 'package:gully_app/data/model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'PromotionalBannerModel.g.dart';

@JsonSerializable()
class PromotionalBanner {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey(name: "banner_title")
  final String bannerTitle;
  @JsonKey(name: "banner_image")
  final String bannerImage;
  @JsonKey(name: "startDate")
  final DateTime startDate;
  @JsonKey(name: "endDate")
  final DateTime endDate;
  @JsonKey(name: "bannerlocationaddress")
  final String bannerlocationaddress;
  @JsonKey(name: "packageId")
  final Package packageId;
  @JsonKey(name: "userId")
  final String user;

  PromotionalBanner({
    required this.id,
    required this.bannerTitle,
    required this.bannerImage,
    required this.startDate,
    required this.endDate,
    required this.bannerlocationaddress,
    required this.packageId,
    required this.user,
  });

  factory PromotionalBanner.fromJson(Map<String, dynamic> json) => _$PromotionalBannerFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionalBannerToJson(this);
}

