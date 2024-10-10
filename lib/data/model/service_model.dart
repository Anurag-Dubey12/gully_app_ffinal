import 'package:flutter/foundation.dart';
import 'package:gully_app/data/model/package_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'service_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceModel {
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(name: 'service_name')
  final String name;

  @JsonKey(name: 'Username')
  final String providerName;

  @JsonKey(name: 'provider_image')
  final String providerimage;

  @JsonKey(name: 'provider_phone_number')
  final String providerPhoneNumber;

  @JsonKey(name: 'provider_age')
  final int providerAge;

  @JsonKey(name: 'service_charges')
  final int serviceCharges;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'years_of_experience')
  final int yearsOfExperience;

  @JsonKey(name: 'offered_services')
  final List<String> offeredServices;

  @JsonKey(name: 'location')
  final String location;

  @JsonKey(name: 'image_urls')
  final List<String> imageUrls;

  @JsonKey(name: 'document_urls')
  final List<String> documentUrls;

  @JsonKey(name: 'package')
  final PackageModel package;

  ServiceModel({
    required this.id,
    required this.name,
    required this.providerName,
    required this.providerimage,
    required this.providerPhoneNumber,
    required this.providerAge,
    required this.serviceCharges,
    required this.description,
    required this.yearsOfExperience,
    required this.offeredServices,
    required this.location,
    required this.imageUrls,
    required this.documentUrls,
    required this.package,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => _$ServiceModelFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);
}
