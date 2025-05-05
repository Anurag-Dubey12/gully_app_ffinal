// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Package _$PackageFromJson(Map<String, dynamic> json) => Package(
      id: json['_id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      duration: json['duration'] as String?,
      packageFor: json['packageFor'] as String,
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
      isActive: json['isActive'] as bool,
      startDate: DateTime.parse(json['startDate'] as String),
      maxMedia: (json['maxMedia'] as num?)?.toInt(),
      maxVideos: (json['maxVideos'] as num?)?.toInt(),
      sponsorshipDetails: json['sponsorshipDetails'] as String?,
      maxEditAllowed: (json['MaxEditAllowed'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PackageToJson(Package instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'duration': instance.duration,
      'packageFor': instance.packageFor,
      'features': instance.features,
      'description': instance.description,
      'isActive': instance.isActive,
      'startDate': instance.startDate.toIso8601String(),
      'maxMedia': instance.maxMedia,
      'maxVideos': instance.maxVideos,
      'sponsorshipDetails': instance.sponsorshipDetails,
      'MaxEditAllowed': instance.maxEditAllowed,
    };
