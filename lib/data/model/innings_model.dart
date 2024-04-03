import 'package:gully_app/data/model/extras_model.dart';
import 'package:gully_app/data/model/overs_model.dart';
import 'package:gully_app/data/model/partnership_model.dart';
import 'package:gully_app/data/model/player_model.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'innings_model.g.dart';

@JsonSerializable(explicitToJson: true)
class InningsModel {
  final int totalScore;
  final TeamModel battingTeam;
  final TeamModel bowlingTeam;
  Map<String, OverModel> ballRecord;
  final PlayerModel openingStriker;
  final PlayerModel openingNonStriker;
  final PlayerModel openingBowler;
  final ExtraModel extras;
  final Map<String, PartnershipModel> partnerships;
  final int overs;
  final int balls;
  final int totalWickets;

  InningsModel(
      {required this.totalScore,
      required this.battingTeam,
      required this.bowlingTeam,
      required this.ballRecord,
      required this.openingStriker,
      required this.openingNonStriker,
      required this.openingBowler,
      required this.extras,
      required this.partnerships,
      required this.overs,
      required this.balls,
      required this.totalWickets});

  factory InningsModel.fromJson(Map<String, dynamic> json) =>
      _$InningsModelFromJson(json);

  Map<String, dynamic> toJson() => _$InningsModelToJson(this);
}
