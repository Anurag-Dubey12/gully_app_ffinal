// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_ranking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerRankingModel _$PlayerRankingModelFromJson(Map<String, dynamic> json) =>
    PlayerRankingModel(
      playerName: json['playerName'] as String,
      balls: json['balls'] as int?,
      fours: json['fours'] as int?,
      sixes: json['sixes'] as int?,
      strikeRate: (json['strikeRate'] as num?)?.toDouble(),
      profilePhoto: json['profilePhoto'] as String,
      over: json['over'] as int?,
      wickets: json['wickets'] as int?,
      runs: json['runs'] as int?,
      total: json['total'] as int?,
      average: json['average'] as int?,
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
