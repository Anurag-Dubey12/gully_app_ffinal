// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PromotionalBannerModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromotionalBanner _$PromotionalBannerFromJson(Map<String, dynamic> json) =>
    PromotionalBanner(
      id: json['_id'] as String,
      bannerTitle: json['banner_title'] as String,
      bannerImage: json['banner_image'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      bannerlocationaddress: json['bannerlocationaddress'] as String,
      packageId: const PackageConverter().fromJson(json['packageId']),
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$PromotionalBannerToJson(PromotionalBanner instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'banner_title': instance.bannerTitle,
      'banner_image': instance.bannerImage,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'bannerlocationaddress': instance.bannerlocationaddress,
      'packageId': const PackageConverter().toJson(instance.packageId),
      'userId': instance.userId,
    };
