import 'package:json_annotation/json_annotation.dart';

part 'player_ranking_model.g.dart';

@JsonSerializable()
class PlayerRankingModel {
  final String playerName;
  final String? profilePhoto;
  @JsonKey(disallowNullValue: false, defaultValue: 0)
  final int? over;
  @JsonKey(disallowNullValue: false, defaultValue: 0)
  final int? wickets;
  @JsonKey(disallowNullValue: false, defaultValue: 0)
  final int? runs;
  @JsonKey(disallowNullValue: false, defaultValue: 0)
  final int? total;
  @JsonKey(disallowNullValue: false, defaultValue: 0)
  final int? average;
  @JsonKey(disallowNullValue: false, defaultValue: 0)
  final int? balls;
  @JsonKey(disallowNullValue: false, defaultValue: 0)
  final int? fours;
  @JsonKey(disallowNullValue: false, defaultValue: 0)
  final int? sixes;
  @JsonKey(disallowNullValue: false, defaultValue: 0.0)
  final double? strikeRate;

  PlayerRankingModel({
    required this.playerName,
    required this.balls,
    required this.fours,
    required this.sixes,
    required this.strikeRate,
    required this.profilePhoto,
    required this.over,
    required this.wickets,
    required this.runs,
    required this.total,
    required this.average,
  });

  factory PlayerRankingModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerRankingModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerRankingModelToJson(this);
}
