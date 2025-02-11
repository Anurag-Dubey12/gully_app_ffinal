import 'package:json_annotation/json_annotation.dart';

part 'package_model.g.dart';

@JsonSerializable()
class Package {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "price")
  final int price;
  @JsonKey(name: "duration")
  final String? duration;
  @JsonKey(name: "packageFor")
  final String packageFor;
  @JsonKey(name: "features")
  final List<String>? features;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "isActive")
  final bool isActive;
  @JsonKey(name: "startDate")
  final DateTime startDate;

  Package({
    required this.id,
    required this.name,
    required this.price,
    this.duration,
    required this.packageFor,
    this.features,
    this.description,
    required this.isActive,
    required this.startDate,
  });

  factory Package.fromJson(Map<String, dynamic> json) => _$PackageFromJson(json);

  Map<String, dynamic> toJson() => _$PackageToJson(this);
}
