// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointTableModel _$PointTableModelFromJson(Map<String, dynamic> json) =>
    PointTableModel(
      teamId: json['teamId'] as String,
      rank: (json['rank'] as num).toInt(),
      teamName: json['teamName'] as String,
      teamLogo: json['teamLogo'] as String,
      matchesPlayed: (json['matchesPlayed'] as num).toInt(),
      wins: (json['wins'] as num).toInt(),
      losses: (json['losses'] as num).toInt(),
      ties: (json['ties'] as num).toInt(),
      points: (json['points'] as num).toInt(),
      netRunRate: json['netRunRate'] as String?,
    );

Map<String, dynamic> _$PointTableModelToJson(PointTableModel instance) =>
    <String, dynamic>{
      'teamId': instance.teamId,
      'rank': instance.rank,
      'teamName': instance.teamName,
      'teamLogo': instance.teamLogo,
      'matchesPlayed': instance.matchesPlayed,
      'wins': instance.wins,
      'losses': instance.losses,
      'ties': instance.ties,
      'points': instance.points,
      'netRunRate': instance.netRunRate,
    };
