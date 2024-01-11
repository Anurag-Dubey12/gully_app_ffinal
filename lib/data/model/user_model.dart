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
  final String? profilePhoto;
  UserModel(
      {required this.fullName,
      required this.email,
      required this.phoneNumber,
      required this.id,
      required this.isNewUser,
      required this.profilePhoto});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  toImageUrl() {
    return "https://gully-team-bucket.s3.amazonaws.com/${profilePhoto ?? ""}";
  }
}
