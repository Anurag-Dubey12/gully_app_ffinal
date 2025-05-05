// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_hours_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessHoursModel _$BusinessHoursModelFromJson(Map<String, dynamic> json) =>
    BusinessHoursModel(
      isOpen: json['isOpen'] as bool? ?? false,
      openTime: json['openTime'] as String?,
      closeTime: json['closeTime'] as String?,
    );

Map<String, dynamic> _$BusinessHoursModelToJson(BusinessHoursModel instance) =>
    <String, dynamic>{
      'isOpen': instance.isOpen,
      'openTime': instance.openTime,
      'closeTime': instance.closeTime,
    };
