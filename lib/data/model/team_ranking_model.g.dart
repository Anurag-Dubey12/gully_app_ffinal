// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_ranking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamRankingModel _$TeamRankingModelFromJson(Map<String, dynamic> json) =>
    TeamRankingModel(
      teamName: json['teamName'] as String,
      teamLogo: json['teamLogo'] as String?,
      numberOfWins: (json['numberOfWins'] as num).toInt(),
      registeredAt: DateTime.parse(json['registeredAt'] as String),
    );

Map<String, dynamic> _$TeamRankingModelToJson(TeamRankingModel instance) =>
    <String, dynamic>{
      'teamName': instance.teamName,
      'teamLogo': instance.teamLogo,
      'numberOfWins': instance.numberOfWins,
      'registeredAt': instance.registeredAt.toIso8601String(),
    };
