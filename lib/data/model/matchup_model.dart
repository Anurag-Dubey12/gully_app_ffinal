import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:json_annotation/json_annotation.dart';

part 'matchup_model.g.dart';

@JsonSerializable()
class MatchupModel {
  @JsonKey(name: '_id')
  final String id;
  final TeamModel team1;
  final TeamModel team2;
  @JsonKey(name: 'dateTime')
  final String matchDate;
  @JsonKey(disallowNullValue: false)
  @JsonKey(name: 'scoreBoard', disallowNullValue: false)
  final Map<String, dynamic>? scoreBoard;

  MatchupModel({
    required this.matchDate,
    required this.team1,
    required this.team2,
    required this.scoreBoard,
    required this.id,
  });

  factory MatchupModel.fromJson(Map<String, dynamic> json) =>
      _$MatchupModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchupModelToJson(this);

  static hasScoreBoardFromJson(Map<String, String> json) {
    logger.e(json['scoreBoard'] ?? "NULL");
    if (json['scoreBoard'] != null) {
      return true;
    } else {
      return false;
    }
  }
}
