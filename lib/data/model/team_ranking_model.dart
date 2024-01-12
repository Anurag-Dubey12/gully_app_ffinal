import 'package:json_annotation/json_annotation.dart';

part 'team_ranking_model.g.dart';

@JsonSerializable()
class TeamRankingModel {
  final String teamName;
  final String teamLogo;
  final int numberOfWins;
  final DateTime registeredAt;

  TeamRankingModel({
    required this.teamName,
    required this.teamLogo,
    required this.numberOfWins,
    required this.registeredAt,
  });

  factory TeamRankingModel.fromJson(Map<String, dynamic> json) =>
      _$TeamRankingModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamRankingModelToJson(this);
}
