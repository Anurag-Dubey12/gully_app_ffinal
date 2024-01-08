// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extras_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExtraModel _$ExtraModelFromJson(Map<String, dynamic> json) => ExtraModel(
      wides: json['wides'] as int,
      noBalls: json['noBalls'] as int,
      byes: json['byes'] as int,
      legByes: json['legByes'] as int,
      penalty: json['penalty'] as int,
    );

Map<String, dynamic> _$ExtraModelToJson(ExtraModel instance) =>
    <String, dynamic>{
      'wides': instance.wides,
      'noBalls': instance.noBalls,
      'byes': instance.byes,
      'legByes': instance.legByes,
      'penalty': instance.penalty,
    };
