// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matchup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchupModel _$MatchupModelFromJson(Map<String, dynamic> json) => MatchupModel(
      matchDate: json['dateTime'] as String,
      team1: TeamModel.fromJson(json['team1'] as Map<String, dynamic>),
      team2: TeamModel.fromJson(json['team2'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MatchupModelToJson(MatchupModel instance) =>
    <String, dynamic>{
      'team1': instance.team1,
      'team2': instance.team2,
      'dateTime': instance.matchDate,
    };
