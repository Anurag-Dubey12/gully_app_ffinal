import 'package:gully_app/data/model/business_hours_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shop_model.g.dart';

@JsonSerializable()
class ShopModel {
  @JsonKey(name: "locationHistory")
  LocationHistory locationHistory;
  @JsonKey(name: "shopTiming")
  final Map<String, business_hours_model> shopTiming;
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: "shopImage")
  List<String> shopImage;
  @JsonKey(name: "shopName")
  String shopName;
  @JsonKey(name: "shopDescription")
  String shopDescription;
  @JsonKey(name: "shopAddress")
  String shopAddress;
  @JsonKey(name: "shopContact")
  String shopContact;
  @JsonKey(name: "shopEmail")
  String shopEmail;
  @JsonKey(name: "ownerName")
  String ownerName;
  @JsonKey(name: "ownerPhoneNumber")
  String ownerPhoneNumber;
  @JsonKey(name: "ownerEmail")
  String ownerEmail;
  @JsonKey(name: "ownerAddress")
  String ownerAddress;
  @JsonKey(name: "ownerAddharImages")
  List<OwnerAddharImage> ownerAddharImages;
  @JsonKey(name: "ownerPanNumber")
  String ownerPanNumber;
  @JsonKey(name: "userId")
  String userId;
  @JsonKey(name: "isSubscriptionPurchased")
  bool isSubscriptionPurchased;
  @JsonKey(name: "AdditionalPackages")
  List<dynamic> additionalPackages;
  @JsonKey(name: "joinedAt")
  DateTime joinedAt;

  ShopModel({
    required this.locationHistory,
    required this.shopTiming,
    required this.id,
    required this.shopImage,
    required this.shopName,
    required this.shopDescription,
    required this.shopAddress,
    required this.shopContact,
    required this.shopEmail,
    required this.ownerName,
    required this.ownerPhoneNumber,
    required this.ownerEmail,
    required this.ownerAddress,
    required this.ownerAddharImages,
    required this.ownerPanNumber,
    required this.userId,
    required this.isSubscriptionPurchased,
    required this.additionalPackages,
    required this.joinedAt,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) =>
      _$ShopModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopModelToJson(this);
}

@JsonSerializable()
class LocationHistory {
  @JsonKey(name: "point")
  Point point;

  LocationHistory({
    required this.point,
  });

  factory LocationHistory.fromJson(Map<String, dynamic> json) =>
      _$LocationHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$LocationHistoryToJson(this);
}

@JsonSerializable()
class Point {
  @JsonKey(name: "type")
  String type;
  @JsonKey(name: "coordinates")
  List<double> coordinates;
  @JsonKey(name: "selectLocation")
  String selectLocation;

  Point({
    required this.type,
    required this.coordinates,
    required this.selectLocation,
  });

  factory Point.fromJson(Map<String, dynamic> json) => _$PointFromJson(json);

  Map<String, dynamic> toJson() => _$PointToJson(this);
}

@JsonSerializable()
class OwnerAddharImage {
  @JsonKey(name: "aadharFrontSide")
  String aadharFrontSide;
  @JsonKey(name: "aadharBackSide")
  String aadharBackSide;

  OwnerAddharImage({
    required this.aadharFrontSide,
    required this.aadharBackSide,
  });

  factory OwnerAddharImage.fromJson(Map<String, dynamic> json) =>
      _$OwnerAddharImageFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerAddharImageToJson(this);
}
