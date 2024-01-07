// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bowling_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BowlingModel _$BowlingModelFromJson(Map<String, dynamic> json) => BowlingModel(
      overs: json['overs'] as num,
      runs: json['runs'] as int,
      wickets: json['wickets'] as int,
      economy: (json['economy'] as num).toDouble(),
      maidens: json['maidens'] as int,
      fours: json['fours'] as int,
      sixes: json['sixes'] as int,
      wides: json['wides'] as int,
      noBalls: json['noBalls'] as int,
    );

Map<String, dynamic> _$BowlingModelToJson(BowlingModel instance) =>
    <String, dynamic>{
      'overs': instance.overs,
      'runs': instance.runs,
      'wickets': instance.wickets,
      'economy': instance.economy,
      'maidens': instance.maidens,
      'fours': instance.fours,
      'sixes': instance.sixes,
      'wides': instance.wides,
      'noBalls': instance.noBalls,
    };
