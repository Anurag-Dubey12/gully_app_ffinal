// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'co_host_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoHostModel _$CoHostModelFromJson(Map<String, dynamic> json) => CoHostModel(
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );

Map<String, dynamic> _$CoHostModelToJson(CoHostModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
    };
