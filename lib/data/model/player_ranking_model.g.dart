// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_ranking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerRankingModel _$PlayerRankingModelFromJson(Map<String, dynamic> json) =>
    PlayerRankingModel(
      playerName: json['playerName'] as String,
      balls: json['balls'] as int? ?? 0,
      fours: json['fours'] as int? ?? 0,
      sixes: json['sixes'] as int? ?? 0,
      strikeRate: (json['strikeRate'] as num?)?.toDouble() ?? 0.0,
      profilePhoto: json['profilePhoto'] as String? ?? '',
      over: json['over'] as int? ?? 0,
      wickets: json['wickets'] as int? ?? 0,
      runs: json['runs'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
      average: json['average'] as int? ?? 0,
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
    };
