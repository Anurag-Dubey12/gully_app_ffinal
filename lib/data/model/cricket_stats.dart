import 'package:gully_app/data/model/matchup_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cricket_stats.g.dart';

@JsonSerializable()
class CricketStats {
  final AggregatedData aggregatedData;
  final List<MatchupModel> matches;
  final BestPerformance? bestBattingPerformance;
  final BestPerformance? bestBowlingPerformance;
  final List<MatchSummary> matchsummary;
  final List<LatestMatch> latestMatchesData;

  CricketStats({
    required this.aggregatedData,
    required this.matches,
    this.bestBattingPerformance,
    this.bestBowlingPerformance,
    required this.matchsummary,
    required this.latestMatchesData,
  });

  factory CricketStats.fromJson(Map<String, dynamic> json) => _$CricketStatsFromJson(json);
  Map<String, dynamic> toJson() => _$CricketStatsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AggregatedData {
  final Map<String, dynamic> batting;
  final Map<String, dynamic> bowling;

  AggregatedData({
    required this.batting,
    required this.bowling,
  });

  factory AggregatedData.fromJson(Map<String, dynamic> json) => _$AggregatedDataFromJson(json);
  Map<String, dynamic> toJson() => _$AggregatedDataToJson(this);
}

@JsonSerializable()
class BestPerformance {
  final int? runs;
  final String? performance;
  final String? team;
  @JsonKey(name: '_id')
  final String id;

  BestPerformance({
    this.runs,
    this.performance,
    this.team,
    required this.id,
  });

  factory BestPerformance.fromJson(Map<String, dynamic> json) => _$BestPerformanceFromJson(json);
  Map<String, dynamic> toJson() => _$BestPerformanceToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MatchSummary {
  final String tournamentId;
  final List<Match> matches;

  MatchSummary({
    required this.tournamentId,
    required this.matches,
  });

  factory MatchSummary.fromJson(Map<String, dynamic> json) => _$MatchSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$MatchSummaryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Match {
  final String matchId;
  final DateTime matchDate;
  final String against;
  final Map<String, dynamic> batting;
  final Map<String, dynamic> bowling;

  Match({
    required this.matchId,
    required this.matchDate,
    required this.against,
    required this.batting,
    required this.bowling,
  });

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
  Map<String, dynamic> toJson() => _$MatchToJson(this);
}

@JsonSerializable()
class LatestMatch {
  @JsonKey(name: '_id')
  final String id;
  final DateTime dateTime;
  final PlayerData? playerData; // nullable

  LatestMatch({
    required this.id,
    required this.dateTime,
    this.playerData, // nullable
  });

  factory LatestMatch.fromJson(Map<String, dynamic> json) => _$LatestMatchFromJson(json);
  Map<String, dynamic> toJson() => _$LatestMatchToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PlayerData {
  final Map<String, dynamic> batting;
  final Map<String, dynamic> bowling;

  PlayerData({
    required this.batting,
    required this.bowling,
  });

  factory PlayerData.fromJson(Map<String, dynamic> json) => _$PlayerDataFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerDataToJson(this);
}
