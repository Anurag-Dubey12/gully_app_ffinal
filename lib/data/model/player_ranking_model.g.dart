// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_ranking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerRankingModel _$PlayerRankingModelFromJson(Map<String, dynamic> json) =>
    PlayerRankingModel(
      playerName: json['playerName'] as String,
      balls: (json['balls'] as num?)?.toInt() ?? 0,
      fours: (json['fours'] as num?)?.toInt() ?? 0,
      sixes: (json['sixes'] as num?)?.toInt() ?? 0,
      strikeRate: (json['strikeRate'] as num?)?.toDouble() ?? 0.0,
      profilePhoto: json['profilePhoto'] as String? ?? '',
      over: (json['over'] as num?)?.toInt() ?? 0,
      wickets: (json['wickets'] as num?)?.toInt() ?? 0,
      runs: (json['runs'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      average: (json['average'] as num?)?.toInt() ?? 0,
      economy: (json['economy'] as num?)?.toDouble() ?? 0.0,
      innings: (json['innings'] as num?)?.toInt() ?? 0,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$PlayerRankingModelToJson(PlayerRankingModel instance) =>
    <String, dynamic>{
      'playerName': instance.playerName,
      'profilePhoto': instance.profilePhoto,
      'over': instance.over,
      'wickets': instance.wickets,
      'runs': instance.runs,
      'total': instance.total,
      'average': instance.average,
      'balls': instance.balls,
      'fours': instance.fours,
      'sixes': instance.sixes,
      'strikeRate': instance.strikeRate,
      'economy': instance.economy,
      'innings': instance.innings,
      'name': instance.name,
    };
