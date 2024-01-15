// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matchup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchupModel _$MatchupModelFromJson(Map<String, dynamic> json) => MatchupModel(
      matchDate: json['dateTime'] as String,
      team1: TeamModel.fromJson(json['team1'] as Map<String, dynamic>),
      team2: TeamModel.fromJson(json['team2'] as Map<String, dynamic>),
      scoreBoard: json['scoreBoard'] as Map<String, dynamic>?,
      id: json['_id'] as String,
    );

Map<String, dynamic> _$MatchupModelToJson(MatchupModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'team1': instance.team1,
      'team2': instance.team2,
      'dateTime': instance.matchDate,
      'scoreBoard': instance.scoreBoard,
    };
