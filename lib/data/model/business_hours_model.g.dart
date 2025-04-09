// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_hours_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

business_hours_model _$business_hours_modelFromJson(
        Map<String, dynamic> json) =>
    business_hours_model(
      isOpen: json['isOpen'] as bool? ?? true,
      openTime: json['openTime'] as String?,
      closeTime: json['closeTime'] as String?,
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$business_hours_modelToJson(
        business_hours_model instance) =>
    <String, dynamic>{
      'isOpen': instance.isOpen,
      'openTime': instance.openTime,
      'closeTime': instance.closeTime,
      '_id': instance.id,
    };
