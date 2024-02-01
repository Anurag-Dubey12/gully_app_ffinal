import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String fullName;
  final String email;
  @JsonKey(disallowNullValue: false)
  final String? phoneNumber;
  @JsonKey(name: '_id')
  final String id;
  final bool isNewUser;
  final bool isOrganizer;
  @JsonKey(
    defaultValue: "",
  )
  String profilePhoto = "";
  UserModel(
      {required this.fullName,
      required this.email,
      required this.isOrganizer,
      required this.phoneNumber,
      required this.id,
      required this.isNewUser,
      required this.profilePhoto});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  String get captializedName => fullName.capitalize!;
}
