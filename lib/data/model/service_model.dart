import 'package:gully_app/data/model/package_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceModel {
  @JsonKey(name: 'id')
  final String serviceId;
  final String name;
  final String address;
  final String phoneNumber;
  final String email;
  final String? identityProof;
  final List<String> category;
  final String description;
  final int experience;
  final String duration;
  final int fees;
  final String serviceType;
  final List<String> serviceImages;
  // final String userId;
  final PackageModel servicePackage;

  ServiceModel({
    required this.serviceId,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.identityProof,
    required this.category,
    required this.experience,
    required this.description,
    required this.duration,
    required this.fees,
    required this.serviceType,
    required this.serviceImages,
    required this.servicePackage,
    // required this.userId,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => _$ServiceModelFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);
}
