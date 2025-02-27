import 'package:gully_app/data/model/package_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'PromotionalBannerModel.g.dart';
@JsonSerializable(explicitToJson: true)
class PromotionalBanner {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'banner_title')
  final String bannerTitle;
  @JsonKey(name: 'banner_image')
  final String bannerImage;
  @JsonKey(name: 'startDate')
  final DateTime startDate;
  @JsonKey(name: 'endDate')
  final DateTime endDate;
  @JsonKey(name: 'bannerlocationaddress')
  final String bannerlocationaddress;
  @JsonKey(disallowNullValue: false)
  @PackageConverter()
  final Package packageId;
  @JsonKey(disallowNullValue: false)
  final String userId;

  PromotionalBanner({
    required this.id,
    required this.bannerTitle,
    required this.bannerImage,
    required this.startDate,
    required this.endDate,
    required this.bannerlocationaddress,
    required this.packageId,
    required this.userId,
  });

  factory PromotionalBanner.fromJson(Map<String, dynamic> json) => _$PromotionalBannerFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionalBannerToJson(this);
}
class PackageConverter implements JsonConverter<Package, dynamic> {
  const PackageConverter();

  @override
  Package fromJson(dynamic json) {
    if (json is String) {
      // Return Package using the string (you may implement logic to fetch or parse the Package if necessary)
      return Package(id: json, name: "", price: 0, packageFor: "", startDate: DateTime.now(), isActive: true);
    } else if (json is Map<String, dynamic>) {
      return Package.fromJson(json);
    } else {
      throw ArgumentError("Invalid type for Package");
    }
  }

  @override
  dynamic toJson(Package package) => package.toJson();
}
