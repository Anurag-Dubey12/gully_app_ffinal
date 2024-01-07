import 'package:gully_app/data/model/batting_model.dart';
import 'package:gully_app/data/model/bowling_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PlayerModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String phoneNumber;
  final String role;
  final BattingModel batting;
  final BowlingModel bowling;
  PlayerModel(
      {required this.name,
      required this.id,
      required this.batting,
      required this.bowling,
      required this.phoneNumber,
      required this.role});

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerModelToJson(this);
}
