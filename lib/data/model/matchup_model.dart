import 'package:gully_app/data/model/team_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'matchup_model.g.dart';

@JsonSerializable()
class MatchupModel {
  final TeamModel team1;
  final TeamModel team2;
  @JsonKey(name: 'dateTime')
  final String matchDate;

  MatchupModel(
      {required this.matchDate, required this.team1, required this.team2});

  factory MatchupModel.fromJson(Map<String, dynamic> json) =>
      _$MatchupModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchupModelToJson(this);
}
