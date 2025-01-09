import 'package:json_annotation/json_annotation.dart';

part 'points_table_model.g.dart';

@JsonSerializable()
class PointTableModel {
  @JsonKey(name: 'teamId')
  final String teamId;

  @JsonKey(name: 'rank')
  final int rank;

  @JsonKey(name: 'teamName')
  final String teamName;

  @JsonKey(name: 'teamLogo')
  final String teamLogo;

  @JsonKey(name: 'matchesPlayed')
  final int matchesPlayed;

  @JsonKey(name: 'wins')
  final int wins;

  @JsonKey(name: 'losses')
  final int losses;

  @JsonKey(name: 'ties')
  final int ties;

  @JsonKey(name: 'points')
  final int points;

  @JsonKey(name: 'netRunRate')
  final String? netRunRate;

  PointTableModel({
    required this.teamId,
    required this.rank,
    required this.teamName,
    required this.teamLogo,
    required this.matchesPlayed,
    required this.wins,
    required this.losses,
    required this.ties,
    required this.points,
    required this.netRunRate,
  });

  factory PointTableModel.fromJson(Map<String, dynamic> json) => _$PointTableModelFromJson(json);
  Map<String, dynamic> toJson() => _$PointTableModelToJson(this);
}
