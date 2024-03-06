import 'package:gully_app/data/model/team_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'matchup_model.g.dart';

@JsonSerializable()
class MatchupModel {
  @JsonKey(name: '_id')
  final String id;
  final TeamModel team1;
  final TeamModel team2;
  @JsonKey(name: 'dateTime')
  final DateTime matchDate;
  @JsonKey(disallowNullValue: false)
  @JsonKey(name: 'scoreBoard', disallowNullValue: false)
  final Map<String, dynamic>? scoreBoard;
  @JsonKey(name: 'tournamentName', disallowNullValue: false)
  final String? tournamentName;
  @JsonKey(name: 'tournamentId', disallowNullValue: false)
  final String? tournamentId;

  MatchupModel({
    required this.matchDate,
    required this.team1,
    required this.team2,
    required this.tournamentName,
    required this.tournamentId,
    required this.scoreBoard,
    required this.id,
  });

  factory MatchupModel.fromJson(Map<String, dynamic> json) =>
      _$MatchupModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchupModelToJson(this);
}
