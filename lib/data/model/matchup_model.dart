import 'package:gully_app/data/model/team_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'matchup_model.g.dart';

@JsonSerializable(explicitToJson: true)
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
  @JsonKey(name: 'Round')
  final String? round;
  @JsonKey(name: 'winningTeamId')
  final String? winningTeam;

  final String? tournament;
  MatchupModel({
    required this.matchDate,
    required this.team1,
    required this.team2,
    required this.tournamentName,
    required this.tournamentId,
    required this.scoreBoard,
    required this.id,
    required this.tournament,
    required this.round,
    required this.winningTeam
  });

  String? get displayName =>
      (tournamentId != null && tournamentId!.isNotEmpty)
          ? tournamentId
          : tournament ?? ' ';


  factory MatchupModel.fromJson(Map<String, dynamic> json) =>
      _$MatchupModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchupModelToJson(this);
  MatchupModel clear() {
    return MatchupModel(
      matchDate: DateTime.now(),
      team1: TeamModel(0, name: '', logo: '', id: '', players: []),
      team2: TeamModel(0, name: '', logo: '', id: '', players: []),
      tournamentName: null,
      tournamentId: null,
      scoreBoard: null,
      tournament: null,
      round: null,
      winningTeam: null,
      id: '',
    );
  }
}
