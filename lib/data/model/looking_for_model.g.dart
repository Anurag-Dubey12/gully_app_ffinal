// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'looking_for_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LookingForPlayerModel _$LookingForPlayerModelFromJson(
        Map<String, dynamic> json) =>
    LookingForPlayerModel(
      id: json['_id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      location: json['location'] as String?,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$LookingForPlayerModelToJson(
        LookingForPlayerModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'fullName': instance.fullName,
      'role': instance.role,
      'createdAt': instance.createdAt.toIso8601String(),
      'phoneNumber': instance.phoneNumber,
      'location': instance.location,
    };
