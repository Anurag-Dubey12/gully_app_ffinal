// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      isOrganizer: json['isOrganizer'] as bool,
      phoneNumber: json['phoneNumber'] as String?,
      id: json['_id'] as String,
      isNewUser: json['isNewUser'] as bool,
      profilePhoto: json['profilePhoto'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      '_id': instance.id,
      'isNewUser': instance.isNewUser,
      'isOrganizer': instance.isOrganizer,
      'profilePhoto': instance.profilePhoto,
    };
