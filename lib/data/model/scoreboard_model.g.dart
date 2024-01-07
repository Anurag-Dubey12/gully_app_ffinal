// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scoreboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScoreboardModel _$ScoreboardModelFromJson(Map<String, dynamic> json) =>
    ScoreboardModel(
      team1: TeamModel.fromJson(json['team1'] as Map<String, dynamic>),
      team2: TeamModel.fromJson(json['team2'] as Map<String, dynamic>),
      matchId: json['matchId'] as String,
      lastOvers:
          (json['lastOvers'] as List<dynamic>).map((e) => e as String).toList(),
    )
      ..currentOver = json['currentOver'] as int
      ..currentBall = json['currentBall'] as int
      ..currentInnings = json['currentInnings'] as int
      ..currentInningsScore = json['currentInningsScore'] as int
      ..currentInningsWickets = json['currentInningsWickets'] as int
      ..lastEventType =
          $enumDecodeNullable(_$EventTypeEnumMap, json['lastEventType'])
      ..overHistory = (json['overHistory'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, OverModel.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$ScoreboardModelToJson(ScoreboardModel instance) =>
    <String, dynamic>{
      'team1': instance.team1.toJson(),
      'team2': instance.team2.toJson(),
      'matchId': instance.matchId,
      'lastOvers': instance.lastOvers,
      'currentOver': instance.currentOver,
      'currentBall': instance.currentBall,
      'currentInnings': instance.currentInnings,
      'currentInningsScore': instance.currentInningsScore,
      'currentInningsWickets': instance.currentInningsWickets,
      'lastEventType': _$EventTypeEnumMap[instance.lastEventType],
      'overHistory':
          instance.overHistory.map((k, e) => MapEntry(k, e.toJson())),
    };

const _$EventTypeEnumMap = {
  EventType.one: 'one',
  EventType.two: 'two',
  EventType.three: 'three',
  EventType.four: 'four',
  EventType.six: 'six',
  EventType.wide: 'wide',
  EventType.noBall: 'noBall',
  EventType.wicket: 'wicket',
  EventType.dotBall: 'dotBall',
  EventType.changeBowler: 'changeBowler',
  EventType.changeStriker: 'changeStriker',
  EventType.legByes: 'legByes',
  EventType.bye: 'bye',
};
