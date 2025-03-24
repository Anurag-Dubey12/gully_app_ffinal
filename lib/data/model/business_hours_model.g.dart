// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_hours_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

business_hours_model _$business_hours_modelFromJson(
        Map<String, dynamic> json) =>
    business_hours_model(
      isOpen: json['is_open'] as bool,
      id: json['_shop_id'] as String?,
      openTime: json['opening_time'] as String?,
      closeTime: json['close_time'] as String?,
    );

Map<String, dynamic> _$business_hours_modelToJson(
        business_hours_model instance) =>
    <String, dynamic>{
      'is_open': instance.isOpen,
      'opening_time': instance.openTime,
      '_shop_id': instance.id,
      'close_time': instance.closeTime,
    };
