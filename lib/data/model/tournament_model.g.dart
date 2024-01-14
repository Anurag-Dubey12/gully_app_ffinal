// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TournamentModel _$TournamentModelFromJson(Map<String, dynamic> json) =>
    TournamentModel(
      tournamentName: json['tournamentName'] as String,
      id: json['_id'] as String,
      disclaimer: json['disclaimer'] as String?,
      rules: json['rules'] as String?,
      ballCharges: json['ballCharges'] as int,
      phoneNumber: json['phoneNumber'] as String?,
      tournamentLimit: json['tournamentLimit'] as int? ?? 0,
      registeredTeamsCount: json['registeredTeamsCount'] as int? ?? 0,
      stadiumAddress: json['stadiumAddress'] as String,
      tournamentStartDateTime:
          DateTime.parse(json['tournamentStartDateTime'] as String),
      tournamentEndDateTime:
          DateTime.parse(json['tournamentEndDateTime'] as String),
      pitchType: json['pitchType'] as String,
      breakfastCharges: json['breakfastCharges'] as int,
      ballType: json['ballType'] as String,
      fees: (json['fees'] as num).toDouble(),
    );
