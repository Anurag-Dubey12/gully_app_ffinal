// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extras_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExtraModel _$ExtraModelFromJson(Map<String, dynamic> json) => ExtraModel(
      wides: (json['wides'] as num).toInt(),
      noBalls: (json['noBalls'] as num).toInt(),
      byes: (json['byes'] as num).toInt(),
      legByes: (json['legByes'] as num).toInt(),
      penalty: (json['penalty'] as num).toInt(),
    );

Map<String, dynamic> _$ExtraModelToJson(ExtraModel instance) =>
    <String, dynamic>{
      'wides': instance.wides,
      'noBalls': instance.noBalls,
      'byes': instance.byes,
      'legByes': instance.legByes,
      'penalty': instance.penalty,
    };
