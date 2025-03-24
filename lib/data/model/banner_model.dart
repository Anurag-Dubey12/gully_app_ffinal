import 'package:json_annotation/json_annotation.dart';

part 'banner_model.g.dart';

@JsonSerializable(createToJson: false)
class BannerModel {
  @JsonKey(name: "banner_image")
  final String? promotionalImage;
  @JsonKey(name: "imageUrl")
  final String? regularImage;
  final String? link;
  @JsonKey(name: "banner_title")
  final String? bannerTitle;
  final String? title;
  @JsonKey(name: "bannerType")
  final String? type;

  BannerModel({
    this.promotionalImage,
    this.regularImage,
    this.link,
    this.bannerTitle,
    this.title,
    this.type,
  });

  String get imageUrl => promotionalImage ?? regularImage ?? '';
  String get displayTitle => bannerTitle ?? title ?? '';

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);
}