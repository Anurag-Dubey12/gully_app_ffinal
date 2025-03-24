// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

vendor_model _$vendor_modelFromJson(Map<String, dynamic> json) => vendor_model(
      name: json['vendor_name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      id: json['_id'] as String,
      alternatePhoneNumber: (json['alternate_vendor_number'] as num?)?.toInt(),
      address: json['shop_address'] as String?,
      id_proof: json['id_proof'] as String?,
    );

Map<String, dynamic> _$vendor_modelToJson(vendor_model instance) =>
    <String, dynamic>{
      'vendor_name': instance.name,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      '_id': instance.id,
      'alternate_vendor_number': instance.alternatePhoneNumber,
      'shop_address': instance.address,
      'id_proof': instance.id_proof,
    };
