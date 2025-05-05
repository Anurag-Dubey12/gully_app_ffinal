// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopModel _$ShopModelFromJson(Map<String, dynamic> json) => ShopModel(
      locationHistory: LocationHistory.fromJson(
          json['locationHistory'] as Map<String, dynamic>),
      shopTiming: (json['shopTiming'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, BusinessHoursModel.fromJson(e as Map<String, dynamic>)),
      ),
      id: json['_id'] as String,
      shopImage:
          (json['shopImage'] as List<dynamic>).map((e) => e as String).toList(),
      shopName: json['shopName'] as String,
      shopDescription: json['shopDescription'] as String,
      shopAddress: json['shopAddress'] as String,
      shopContact: json['shopContact'] as String,
      shopEmail: json['shopEmail'] as String,
      ownerName: json['ownerName'] as String,
      ownerPhoneNumber: json['ownerPhoneNumber'] as String,
      ownerEmail: json['ownerEmail'] as String,
      ownerAddress: json['ownerAddress'] as String,
      ownerAddharImages: (json['ownerAddharImages'] as List<dynamic>)
          .map((e) => OwnerAddharImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      ownerPanNumber: json['ownerPanNumber'] as String,
      userId: json['userId'] as String,
      isSubscriptionPurchased: json['isSubscriptionPurchased'] as bool,
      additionalPackages: (json['AdditionalPackages'] as List<dynamic>?)
          ?.map((e) => Package.fromJson(e as Map<String, dynamic>))
          .toList(),
      package: json['packageId'] == null
          ? null
          : Package.fromJson(json['packageId'] as Map<String, dynamic>),
      packageStartDate: json['packageStartDate'] == null
          ? null
          : DateTime.parse(json['packageStartDate'] as String),
      packageEndDate: json['packageEndDate'] == null
          ? null
          : DateTime.parse(json['packageEndDate'] as String),
      joinedAt: DateTime.parse(json['joinedAt'] as String),
    );

Map<String, dynamic> _$ShopModelToJson(ShopModel instance) => <String, dynamic>{
      'locationHistory': instance.locationHistory,
      'shopTiming': instance.shopTiming,
      '_id': instance.id,
      'shopImage': instance.shopImage,
      'shopName': instance.shopName,
      'shopDescription': instance.shopDescription,
      'shopAddress': instance.shopAddress,
      'shopContact': instance.shopContact,
      'shopEmail': instance.shopEmail,
      'ownerName': instance.ownerName,
      'ownerPhoneNumber': instance.ownerPhoneNumber,
      'ownerEmail': instance.ownerEmail,
      'ownerAddress': instance.ownerAddress,
      'ownerAddharImages': instance.ownerAddharImages,
      'ownerPanNumber': instance.ownerPanNumber,
      'userId': instance.userId,
      'isSubscriptionPurchased': instance.isSubscriptionPurchased,
      'AdditionalPackages': instance.additionalPackages,
      'packageStartDate': instance.packageStartDate?.toIso8601String(),
      'packageEndDate': instance.packageEndDate?.toIso8601String(),
      'packageId': instance.package,
      'joinedAt': instance.joinedAt.toIso8601String(),
    };

LocationHistory _$LocationHistoryFromJson(Map<String, dynamic> json) =>
    LocationHistory(
      point: Point.fromJson(json['point'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LocationHistoryToJson(LocationHistory instance) =>
    <String, dynamic>{
      'point': instance.point,
    };

Point _$PointFromJson(Map<String, dynamic> json) => Point(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      selectLocation: json['selectLocation'] as String,
    );

Map<String, dynamic> _$PointToJson(Point instance) => <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
      'selectLocation': instance.selectLocation,
    };

OwnerAddharImage _$OwnerAddharImageFromJson(Map<String, dynamic> json) =>
    OwnerAddharImage(
      aadharFrontSide: json['aadharFrontSide'] as String,
      aadharBackSide: json['aadharBackSide'] as String,
    );

Map<String, dynamic> _$OwnerAddharImageToJson(OwnerAddharImage instance) =>
    <String, dynamic>{
      'aadharFrontSide': instance.aadharFrontSide,
      'aadharBackSide': instance.aadharBackSide,
    };
