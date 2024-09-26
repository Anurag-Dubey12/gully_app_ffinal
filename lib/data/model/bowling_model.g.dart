// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bowling_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BowlingModel _$BowlingModelFromJson(Map<String, dynamic> json) => BowlingModel(
      runs: (json['runs'] as num).toInt(),
      wickets: (json['wickets'] as num).toInt(),
      economy: (json['economy'] as num).toDouble(),
      maidens: (json['maidens'] as num).toInt(),
      fours: (json['fours'] as num).toInt(),
      sixes: (json['sixes'] as num).toInt(),
      wides: (json['wides'] as num).toInt(),
      noBalls: (json['noBalls'] as num).toInt(),
    )
      ..overs = (json['overs'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, OverModel.fromJson(e as Map<String, dynamic>)),
      )
      ..currentOver = (json['currentOver'] as num).toInt()
      ..currentBall = (json['currentBall'] as num).toInt();

Map<String, dynamic> _$BowlingModelToJson(BowlingModel instance) =>
    <String, dynamic>{
      'overs': instance.overs.map((k, e) => MapEntry(k, e.toJson())),
      'economy': instance.economy,
      'runs': instance.runs,
      'wickets': instance.wickets,
      'maidens': instance.maidens,
      'fours': instance.fours,
      'sixes': instance.sixes,
      'wides': instance.wides,
      'noBalls': instance.noBalls,
      'currentOver': instance.currentOver,
      'currentBall': instance.currentBall,
      'economyRate': instance.economyRate,
    };
