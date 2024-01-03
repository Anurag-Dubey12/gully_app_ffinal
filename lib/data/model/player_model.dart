import 'package:json_annotation/json_annotation.dart';

part 'player_model.g.dart';

@JsonSerializable(createToJson: false)
class PlayerModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String phoneNumber;
  final String role;

  PlayerModel(
      {required this.name,
      required this.id,
      required this.phoneNumber,
      required this.role});

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);
}
