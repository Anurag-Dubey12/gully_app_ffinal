// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamModel _$TeamModelFromJson(Map<String, dynamic> json) => TeamModel(
      json['playersCount'] as int?,
      name: json['teamName'] as String,
      logo: json['teamLogo'] as String?,
      id: json['_id'] as String,
      status: json['status'] as String?,
      players: (json['players'] as List<dynamic>?)
          ?.map((e) => PlayerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TeamModelToJson(TeamModel instance) => <String, dynamic>{
      'teamName': instance.name,
      'teamLogo': instance.logo,
      '_id': instance.id,
      'playersCount': instance.playersCount,
      'players': instance.players?.map((e) => e.toJson()).toList(),
      'status': instance.status,
    };
