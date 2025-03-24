// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

shop_model _$shop_modelFromJson(Map<String, dynamic> json) => shop_model(
      id: (json['_id'] as num?)?.toInt(),
      shopName: json['shop_name'] as String?,
      shopAddress: json['shop_address'] as String?,
      shopNumber: json['shop_number'] as String?,
      shopEmail: json['shop_email'] as String?,
      gstNumber: json['gst_number'] as String?,
      gstCertificate: json['gst_certificate'] as String?,
      registrationCertificate: json['registration_certificate'] as String?,
      shopLogo: json['shop_logo'] as String?,
      businessHours: (json['business_hours'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, business_hours_model.fromJson(e as Map<String, dynamic>)),
      ),
      websiteUrl: json['website_url'] as String?,
      description: json['description'] as String?,
      locationProof: json['location_proof'] as String?,
      businessLicense: json['business_license'] as String?,
      taxCertificate: json['tax_certificate'] as String?,
      vendor: json['vendor'] == null
          ? null
          : vendor_model.fromJson(json['vendor'] as Map<String, dynamic>),
      socialLinks: (json['socialLinks'] as List<dynamic>?)
              ?.map((e) => e as String?)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$shop_modelToJson(shop_model instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'shop_name': instance.shopName,
      'shop_address': instance.shopAddress,
      'shop_number': instance.shopNumber,
      'shop_email': instance.shopEmail,
      'gst_number': instance.gstNumber,
      'gst_certificate': instance.gstCertificate,
      'registration_certificate': instance.registrationCertificate,
      'shop_logo': instance.shopLogo,
      'business_hours':
          instance.businessHours?.map((k, e) => MapEntry(k, e.toJson())),
      'website_url': instance.websiteUrl,
      'description': instance.description,
      'location_proof': instance.locationProof,
      'business_license': instance.businessLicense,
      'tax_certificate': instance.taxCertificate,
      'vendor': instance.vendor?.toJson(),
      'socialLinks': instance.socialLinks,
    };
