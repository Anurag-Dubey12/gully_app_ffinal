import 'vendor_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'business_hours_model.dart';

part 'shop_model.g.dart';

@JsonSerializable(explicitToJson: true)
class shop_model {
  @JsonKey(name: '_id')
  final int? id;
  @JsonKey(name: 'shop_name')
  String? shopName;
  @JsonKey(name: 'shop_address')
  String? shopAddress;
  @JsonKey(name: 'shop_number')
  String? shopNumber;
  @JsonKey(name: 'shop_email')
  String? shopEmail;
  @JsonKey(name: 'gst_number')
  String? gstNumber;
  @JsonKey(name: 'gst_certificate')
  String? gstCertificate;
  @JsonKey(name: 'registration_certificate')
  String? registrationCertificate;
  @JsonKey(name: 'shop_logo')
  String? shopLogo;
  @JsonKey(name: 'business_hours')
  Map<String, business_hours_model>? businessHours;
  @JsonKey(name: 'website_url')
  String? websiteUrl;
  @JsonKey(name: 'description')
  String? description;
  @JsonKey(name: 'location_proof')
  String? locationProof;
  @JsonKey(name: 'business_license')
  String? businessLicense;
  @JsonKey(name: 'tax_certificate')
  String? taxCertificate;
  final vendor_model? vendor;
  final List<String?> socialLinks;

  shop_model({
    this.id,
    this.shopName,
    this.shopAddress,
    this.shopNumber,
    this.shopEmail,
    this.gstNumber,
    this.gstCertificate,
    this.registrationCertificate,
    this.shopLogo,
    this.businessHours,
    this.websiteUrl,
    this.description,
    this.locationProof,
    this.businessLicense,
    this.taxCertificate,
    this.vendor,
    this.socialLinks = const []

});

  factory shop_model.fromJson(Map<String, dynamic> json) => _$shop_modelFromJson(json);

  Map<String, dynamic> toJson() => _$shop_modelToJson(this);
}
