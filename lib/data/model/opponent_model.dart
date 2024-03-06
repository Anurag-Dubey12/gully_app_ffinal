import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'opponent_model.g.dart';

@JsonSerializable(createToJson: false)
class OpponentModel {
  final TeamModel team;

  final TournamentModel tournament;

  OpponentModel({required this.team, required this.tournament});

  factory OpponentModel.fromJson(Map<String, dynamic> json) =>
      _$OpponentModelFromJson(json);
}
