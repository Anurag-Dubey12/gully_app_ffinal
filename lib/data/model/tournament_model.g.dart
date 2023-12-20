// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TournamenModel _$TournamenModelFromJson(Map<String, dynamic> json) =>
    TournamenModel(
      tournamentName: json['tournamentName'] as String,
      tournamentStartDateTime:
          DateTime.parse(json['tournamentStartDateTime'] as String),
      tournamentEndDateTime:
          DateTime.parse(json['tournamentEndDateTime'] as String),
      tournamentListType: TournamenModel.tournamentListTypeFromJson(
          json['tournamentListType'] as String),
      fees: (json['fees'] as num).toDouble(),
    );

Map<String, dynamic> _$TournamenModelToJson(TournamenModel instance) =>
    <String, dynamic>{
      'tournamentName': instance.tournamentName,
      'tournamentStartDateTime':
          instance.tournamentStartDateTime.toIso8601String(),
      'tournamentEndDateTime': instance.tournamentEndDateTime.toIso8601String(),
      'fees': instance.fees,
      'tournamentListType':
          _$TournamentListTypeEnumMap[instance.tournamentListType]!,
    };

const _$TournamentListTypeEnumMap = {
  TournamentListType.upcoming: 'upcoming',
  TournamentListType.ongoing: 'ongoing',
  TournamentListType.completed: 'completed',
};
