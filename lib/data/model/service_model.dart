import 'package:gully_app/data/model/package_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceModel {
  @JsonKey(name: 'id')
  final String serviceId;

  @JsonKey(name: 'provider_name')
  final String providerName;

  @JsonKey(name: 'provider_image')
  final String providerImageUrl;

  @JsonKey(name: 'provider_phone_number')
  final String providerPhoneNumber;

  @JsonKey(name: 'provider_age')
  final String email;

  @JsonKey(name: 'service_charges')
  final int serviceCharges;

  @JsonKey(name: 'description')
  final String serviceDescription;

  @JsonKey(name: 'years_of_experience')
  final int yearsOfExperience;

  @JsonKey(name: 'offered_services')
  final List<String> offeredServiceList;

  @JsonKey(name: 'location')
  final String providerLocation;

  @JsonKey(name: 'image_urls')
  final List<String> galleryImages;

  @JsonKey(name: 'document_urls')
  final List<String> documentUrls;

  @JsonKey(name: 'package')
  final PackageModel servicePackage;

  ServiceModel({
    required this.serviceId,
    required this.providerName,
    required this.providerImageUrl,
    required this.providerPhoneNumber,
    required this.email,
    required this.serviceCharges,
    required this.serviceDescription,
    required this.yearsOfExperience,
    required this.offeredServiceList,
    required this.providerLocation,
    required this.galleryImages,
    required this.documentUrls,
    required this.servicePackage,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => _$ServiceModelFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);
}
