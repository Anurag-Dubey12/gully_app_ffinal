import 'package:json_annotation/json_annotation.dart';

part 'authority_user_model.g.dart';

@JsonSerializable(createToJson: false)
class AuthorityModel {
  final String id;
  final String fullName;

  AuthorityModel({required this.id, required this.fullName});

  factory AuthorityModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorityModelFromJson(json);
}
