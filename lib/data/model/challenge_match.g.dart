// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeMatchModel _$ChallengeMatchModelFromJson(Map<String, dynamic> json) =>
    ChallengeMatchModel(
      id: json['_id'] as String,
      status: json['status'] as String,
      team1: TeamModel.fromJson(json['team1'] as Map<String, dynamic>),
      team2: TeamModel.fromJson(json['team2'] as Map<String, dynamic>),
      challengedBy: json['challengedBy'] as String,
    );
