import 'package:json_annotation/json_annotation.dart';

part 'looking_for_model.g.dart';

@JsonSerializable()
class LookingForPlayerModel {
  @JsonKey(name: '_id')
  final String id;
  final String fullName;
  final String? role;
  final DateTime createdAt;
  final String? phoneNumber;

  final String? location;

  LookingForPlayerModel(
      {required this.id,
      required this.createdAt,
      required this.location,
      required this.fullName,
      required this.phoneNumber,
      required this.role});

  factory LookingForPlayerModel.fromJson(Map<String, dynamic> json) =>
      _$LookingForPlayerModelFromJson(json);
}
