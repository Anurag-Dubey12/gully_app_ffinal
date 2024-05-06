// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overs_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OverModel _$OverModelFromJson(Map<String, dynamic> json) => OverModel(
      over: json['over'] as int,
      bowlerId: json['bowlerId'] as String?,
      strikerId: json['strikerId'] as String?,
      nonStrikerId: json['nonStrikerId'] as String?,
      wicketTakerId: json['wicketTakerId'] as String?,
      wicketType: json['wicketType'] as String?,
      ball: json['ball'] as int,
      run: json['run'] as int,
      wickets: json['wickets'] as int,
      extra: json['extra'] as int,
      total: json['total'] as int,
      events: (json['events'] as List<dynamic>)
          .map((e) => $enumDecode(_$EventTypeEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$OverModelToJson(OverModel instance) => <String, dynamic>{
      'over': instance.over,
      'ball': instance.ball,
      'run': instance.run,
      'wickets': instance.wickets,
      'extra': instance.extra,
      'total': instance.total,
      'events': instance.events.map((e) => _$EventTypeEnumMap[e]!).toList(),
      'bowlerId': instance.bowlerId,
      'strikerId': instance.strikerId,
      'nonStrikerId': instance.nonStrikerId,
      'wicketTakerId': instance.wicketTakerId,
      'wicketType': instance.wicketType,
    };

const _$EventTypeEnumMap = {
  EventType.one: 'one',
  EventType.two: 'two',
  EventType.three: 'three',
  EventType.four: 'four',
  EventType.five: 'five',
  EventType.six: 'six',
  EventType.custom: 'custom',
  EventType.wide: 'wide',
  EventType.noBall: 'noBall',
  EventType.wicket: 'wicket',
  EventType.dotBall: 'dotBall',
  EventType.changeBowler: 'changeBowler',
  EventType.changeStriker: 'changeStriker',
  EventType.legByes: 'legByes',
  EventType.bye: 'bye',
  EventType.retire: 'retire',
  EventType.eoi: 'eoi',
};
