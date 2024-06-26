// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'innings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InningsModel _$InningsModelFromJson(Map<String, dynamic> json) => InningsModel(
      totalScore: json['totalScore'] as int,
      battingTeam:
          TeamModel.fromJson(json['battingTeam'] as Map<String, dynamic>),
      bowlingTeam:
          TeamModel.fromJson(json['bowlingTeam'] as Map<String, dynamic>),
      ballRecord: (json['ballRecord'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, OverModel.fromJson(e as Map<String, dynamic>)),
      ),
      openingStriker:
          PlayerModel.fromJson(json['openingStriker'] as Map<String, dynamic>),
      openingNonStriker: PlayerModel.fromJson(
          json['openingNonStriker'] as Map<String, dynamic>),
      openingBowler:
          PlayerModel.fromJson(json['openingBowler'] as Map<String, dynamic>),
      extras: ExtraModel.fromJson(json['extras'] as Map<String, dynamic>),
      partnerships: (json['partnerships'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, PartnershipModel.fromJson(e as Map<String, dynamic>)),
      ),
      overs: json['overs'] as int,
      balls: json['balls'] as int,
      totalWickets: json['totalWickets'] as int,
      isOver: json['isOver'] as bool? ?? false,
    );

Map<String, dynamic> _$InningsModelToJson(InningsModel instance) =>
    <String, dynamic>{
      'totalScore': instance.totalScore,
      'battingTeam': instance.battingTeam.toJson(),
      'bowlingTeam': instance.bowlingTeam.toJson(),
      'ballRecord': instance.ballRecord?.map((k, e) => MapEntry(k, e.toJson())),
      'openingStriker': instance.openingStriker.toJson(),
      'openingNonStriker': instance.openingNonStriker.toJson(),
      'openingBowler': instance.openingBowler.toJson(),
      'extras': instance.extras.toJson(),
      'partnerships':
          instance.partnerships?.map((k, e) => MapEntry(k, e.toJson())),
      'overs': instance.overs,
      'balls': instance.balls,
      'totalWickets': instance.totalWickets,
      'isOver': instance.isOver,
    };
