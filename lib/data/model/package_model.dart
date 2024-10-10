import 'package:json_annotation/json_annotation.dart';

part 'package_model.g.dart';

@JsonSerializable()
class PackageModel {
  final String name;
  final String duration;
  final double price;
  final String endDate;

  PackageModel({
    required this.name,
    required this.duration,
    required this.price,
    required this.endDate,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) => _$PackageModelFromJson(json);

  Map<String, dynamic> toJson() => _$PackageModelToJson(this);

  @override
  String toString() {
    return '$name - $duration - ₹$price';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PackageModel &&
        other.name == name &&
        other.duration == duration &&
        other.price == price &&
        other.endDate == endDate;
  }

  @override
  int get hashCode => name.hashCode ^ duration.hashCode ^ price.hashCode;
}
