import 'package:json_annotation/json_annotation.dart';

part 'banner_model.g.dart';

@JsonSerializable(createToJson: false)
class BannerModel {
  final String imageUrl;
  final String link;

  BannerModel({required this.imageUrl, required this.link});

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);
}
