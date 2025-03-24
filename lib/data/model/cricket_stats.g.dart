// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cricket_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CricketStats _$CricketStatsFromJson(Map<String, dynamic> json) => CricketStats(
      aggregatedData: AggregatedData.fromJson(
          json['aggregatedData'] as Map<String, dynamic>),
      matches: (json['matches'] as List<dynamic>)
          .map((e) => MatchupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      bestBattingPerformance:
          json['bestBattingPerformance'] as Map<String, dynamic>?,
      bestBowlingPerformance:
          json['bestBowlingPerformance'] as Map<String, dynamic>?,
      latestMatchesData: (json['latestMatchesData'] as List<dynamic>?)
          ?.map((e) => LatestMatch.fromJson(e as Map<String, dynamic>))
          .toList(),
      userPlayedTournament: (json['userPlayedTournament'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$CricketStatsToJson(CricketStats instance) =>
    <String, dynamic>{
      'aggregatedData': instance.aggregatedData,
      'matches': instance.matches,
      'bestBattingPerformance': instance.bestBattingPerformance,
      'bestBowlingPerformance': instance.bestBowlingPerformance,
      'latestMatchesData': instance.latestMatchesData,
      'userPlayedTournament': instance.userPlayedTournament,
    };

AggregatedData _$AggregatedDataFromJson(Map<String, dynamic> json) =>
    AggregatedData(
      batting: json['batting'] as Map<String, dynamic>,
      bowling: json['bowling'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$AggregatedDataToJson(AggregatedData instance) =>
    <String, dynamic>{
      'batting': instance.batting,
      'bowling': instance.bowling,
    };

BestPerformance _$BestPerformanceFromJson(Map<String, dynamic> json) =>
    BestPerformance(
      runs: (json['runs'] as num?)?.toInt(),
      performance: json['performance'] as String?,
      team: json['team'] as String?,
      id: json['_id'] as String,
    );

Map<String, dynamic> _$BestPerformanceToJson(BestPerformance instance) =>
    <String, dynamic>{
      'runs': instance.runs,
      'performance': instance.performance,
      'team': instance.team,
      '_id': instance.id,
    };

MatchSummary _$MatchSummaryFromJson(Map<String, dynamic> json) => MatchSummary(
      tournamentId: json['tournamentId'] as String,
      matches: (json['matches'] as List<dynamic>)
          .map((e) => Match.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MatchSummaryToJson(MatchSummary instance) =>
    <String, dynamic>{
      'tournamentId': instance.tournamentId,
      'matches': instance.matches.map((e) => e.toJson()).toList(),
    };

Match _$MatchFromJson(Map<String, dynamic> json) => Match(
      matchId: json['matchId'] as String,
      matchDate: DateTime.parse(json['matchDate'] as String),
      against: json['against'] as String,
      batting: json['batting'] as Map<String, dynamic>,
      bowling: json['bowling'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$MatchToJson(Match instance) => <String, dynamic>{
      'matchId': instance.matchId,
      'matchDate': instance.matchDate.toIso8601String(),
      'against': instance.against,
      'batting': instance.batting,
      'bowling': instance.bowling,
    };

LatestMatch _$LatestMatchFromJson(Map<String, dynamic> json) => LatestMatch(
      id: json['_id'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      playerData: json['playerData'] == null
          ? null
          : PlayerData.fromJson(json['playerData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LatestMatchToJson(LatestMatch instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'dateTime': instance.dateTime.toIso8601String(),
      'playerData': instance.playerData,
    };

PlayerData _$PlayerDataFromJson(Map<String, dynamic> json) => PlayerData(
      batting: json['batting'] as Map<String, dynamic>,
      bowling: json['bowling'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$PlayerDataToJson(PlayerData instance) =>
    <String, dynamic>{
      'batting': instance.batting,
      'bowling': instance.bowling,
    };
