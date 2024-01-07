import 'package:gully_app/data/model/player_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'team_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TeamModel {
  @JsonKey(name: 'teamName')
  final String name;
  @JsonKey(name: 'teamLogo')
  final String logo;
  @JsonKey(name: '_id')
  final String id;
  final int playersCount;
  @JsonKey(disallowNullValue: false)
  final List<PlayerModel>? players;

  TeamModel(this.playersCount,
      {required this.name,
      required this.logo,
      required this.id,
      required this.players});

  factory TeamModel.fromJson(Map<String, dynamic> json) =>
      _$TeamModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamModelToJson(this);
}
