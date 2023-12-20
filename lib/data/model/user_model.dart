import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String fullName;
  final String email;
  final String phone;
  @JsonKey(name: '_id')
  final String id;

  UserModel(
      {required this.fullName,
      required this.email,
      required this.phone,
      required this.id});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
