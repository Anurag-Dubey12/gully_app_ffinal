import 'package:flutter/foundation.dart';
import 'package:gully_app/data/model/package_model.dart';

class ServiceModel {
  final String id;
  final String name;
  final String providerName;
  final String providerimage;
  final String providerPhoneNumber;
  final int providerAge;
  final String description;
  final int yearsOfExperience;
  final List<String> offeredServices;
  final String location;
  final List<String> imageUrls;
  final List<String> documentUrls;
  final PackageModel package;

  ServiceModel({
    required this.id,
    required this.name,
    required this.providerName,
    required this.providerimage,
    required this.providerPhoneNumber,
    required this.providerAge,
    required this.description,
    required this.yearsOfExperience,
    required this.offeredServices,
    required this.location,
    required this.imageUrls,
    required this.documentUrls,
    required this.package,
  });
  factory ServiceModel.fromForm({
    required String name,
    required String providerName,
    required String providerimage,
    required String providerPhoneNumber,
    required int providerAge,
    required String description,
    required int yearsOfExperience,
    required List<String> offeredServices,
    required String address,
    required Map<String, dynamic> selectedPackage,
    required List<String> imageUrls,
    required List<String> documentUrls,
  }) {
    return ServiceModel(
      id: '',
      name: name,
      providerName: providerName,
      providerimage: providerimage,
      providerPhoneNumber: providerPhoneNumber,
      providerAge: providerAge,
      description: description,
      yearsOfExperience: yearsOfExperience,
      offeredServices: offeredServices,
      location: address,
      imageUrls: imageUrls,
      documentUrls: documentUrls,
      package: PackageModel(
        name: selectedPackage['package'] ?? '',
        duration: selectedPackage['Duration'] ?? '',
        price: (selectedPackage['price'] as num?)?.toDouble() ?? 0.0,
      ),
    );
  }

  ServiceModel copyWith({
    String? id,
    String? name,
    String? providerName,
    String? providerimage,
    String? providerPhoneNumber,
    int? providerAge,
    String? description,
    int? yearsOfExperience,
    List<String>? offeredServices,
    String? location,
    List<String>? imageUrls,
    List<String>? documentUrls,
    PackageModel? package,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      providerName: providerName ?? this.providerName,
      providerimage: providerimage ?? this.providerimage,
      providerPhoneNumber: providerPhoneNumber ?? this.providerPhoneNumber,
      providerAge: providerAge ?? this.providerAge,
      description: description ?? this.description,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      offeredServices: offeredServices ?? this.offeredServices,
      location: location ?? this.location,
      imageUrls: imageUrls ?? this.imageUrls,
      documentUrls: documentUrls ?? this.documentUrls,
      package: package ?? this.package,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          providerName == other.providerName &&
          providerimage == other.providerimage &&
          providerPhoneNumber == other.providerPhoneNumber &&
          providerAge == other.providerAge &&
          description == other.description &&
          yearsOfExperience == other.yearsOfExperience &&
          listEquals(offeredServices, other.offeredServices) &&
          location == other.location &&
          listEquals(imageUrls, other.imageUrls) &&
          listEquals(documentUrls, other.documentUrls) &&
          package == other.package;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      providerName.hashCode ^
      providerimage.hashCode ^
      providerPhoneNumber.hashCode ^
      providerAge.hashCode ^
      description.hashCode ^
      yearsOfExperience.hashCode ^
      offeredServices.hashCode ^
      location.hashCode ^
      imageUrls.hashCode ^
      documentUrls.hashCode ^
      package.hashCode;

  @override
  String toString() {
    return 'Service(id: $id, name: $name, providerName: $providerName,providerimage: $providerimage, providerPhoneNumber: $providerPhoneNumber, providerAge: $providerAge, description: $description, yearsOfExperience: $yearsOfExperience, offeredServices: $offeredServices, location: $location, imageUrls: $imageUrls, documentUrls: $documentUrls, package: $package)';
  }
}
