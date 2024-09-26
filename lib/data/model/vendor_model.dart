import 'package:json_annotation/json_annotation.dart';
part 'vendor_model.g.dart';

@JsonSerializable(explicitToJson: true)
class vendor_model {
  @JsonKey(name: 'vendor_name')
  final String name;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'alternate_vendor_number')
  final int? alternatePhoneNumber;
  @JsonKey(name: 'shop_address')
  final String? address;
  @JsonKey(name: 'id_proof')
  final String? id_proof;
  vendor_model({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.id,
    this.alternatePhoneNumber,
    this.address,
    this.id_proof,
  });
  factory vendor_model.fromJson(Map<String, dynamic> json) =>
      _$vendor_modelFromJson(json);

  Map<String, dynamic> toJson() => _$vendor_modelToJson(this);
}