// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BattingModel _$BattingModelFromJson(Map<String, dynamic> json) => BattingModel(
      runs: json['runs'] as int,
      balls: json['balls'] as int,
      fours: json['fours'] as int,
      sixes: json['sixes'] as int,
      strikeRate: (json['strikeRate'] as num).toDouble(),
      bowledBy: json['bowledBy'] as String,
      outType: json['outType'] as String,
    );

Map<String, dynamic> _$BattingModelToJson(BattingModel instance) =>
    <String, dynamic>{
      'runs': instance.runs,
      'balls': instance.balls,
      'fours': instance.fours,
      'sixes': instance.sixes,
      'strikeRate': instance.strikeRate,
      'bowledBy': instance.bowledBy,
      'outType': instance.outType,
    };
