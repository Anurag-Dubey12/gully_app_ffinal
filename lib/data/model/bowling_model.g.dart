// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bowling_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BowlingModel _$BowlingModelFromJson(Map<String, dynamic> json) => BowlingModel(
      runs: json['runs'] as int,
      wickets: json['wickets'] as int,
      economy: (json['economy'] as num).toDouble(),
      maidens: json['maidens'] as int,
      fours: json['fours'] as int,
      sixes: json['sixes'] as int,
      wides: json['wides'] as int,
      noBalls: json['noBalls'] as int,
    )
      ..overs = (json['overs'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, OverModel.fromJson(e as Map<String, dynamic>)),
      )
      ..currentOver = json['currentOver'] as int
      ..currentBall = json['currentBall'] as int;

Map<String, dynamic> _$BowlingModelToJson(BowlingModel instance) =>
    <String, dynamic>{
      'overs': instance.overs.map((k, e) => MapEntry(k, e.toJson())),
      'runs': instance.runs,
      'wickets': instance.wickets,
      'economy': instance.economy,
      'currentOver': instance.currentOver,
      'currentBall': instance.currentBall,
      'maidens': instance.maidens,
      'fours': instance.fours,
      'sixes': instance.sixes,
      'wides': instance.wides,
      'noBalls': instance.noBalls,
    };
