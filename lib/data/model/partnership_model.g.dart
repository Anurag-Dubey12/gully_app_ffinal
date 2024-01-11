// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partnership_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnershipModel _$PartnershipModelFromJson(Map<String, dynamic> json) =>
    PartnershipModel(
      player1: PlayerModel.fromJson(json['player1'] as Map<String, dynamic>),
      player2: PlayerModel.fromJson(json['player2'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PartnershipModelToJson(PartnershipModel instance) =>
    <String, dynamic>{
      'player1': instance.player1.toJson(),
      'player2': instance.player2.toJson(),
      'runs': instance.runs,
      'balls': instance.balls,
    };
