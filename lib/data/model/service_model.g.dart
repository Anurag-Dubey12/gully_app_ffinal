// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceModel _$ServiceModelFromJson(Map<String, dynamic> json) => ServiceModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      identityProof: json['identityProof'] as String,
      category: json['category'] as String,
      experience: (json['experience'] as num).toInt(),
      description: json['description'] as String,
      duration: (json['duration'] as num).toInt(),
      fees: (json['fees'] as num).toInt(),
      serviceType: json['serviceType'] as String,
      serviceImages: (json['serviceImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ServiceModelToJson(ServiceModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'identityProof': instance.identityProof,
      'category': instance.category,
      'description': instance.description,
      'experience': instance.experience,
      'duration': instance.duration,
      'fees': instance.fees,
      'serviceType': instance.serviceType,
      'serviceImages': instance.serviceImages,
    };
