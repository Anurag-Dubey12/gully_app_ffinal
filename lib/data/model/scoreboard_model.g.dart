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
      ..ballsToBowl = json['ballsToBowl'] as int
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

// ignore: unused_element
abstract class _$ScoreboardModelPerFieldToJson {
  // ignore: unused_element
  static Object? team1(TeamModel instance) => instance.toJson();
  // ignore: unused_element
  static Object? team2(TeamModel instance) => instance.toJson();
  // ignore: unused_element
  static Object? matchId(String instance) => instance;
  // ignore: unused_element
  static Object? lastOvers(List<String> instance) => instance;
  // ignore: unused_element
  static Object? _extras(ExtraModel instance) => instance.toJson();
  // ignore: unused_element
  static Object? ballsToBowl(int instance) => instance;
  // ignore: unused_element
  static Object? currentOver(int instance) => instance;
  // ignore: unused_element
  static Object? currentBall(int instance) => instance;
  // ignore: unused_element
  static Object? currentInnings(int instance) => instance;
  // ignore: unused_element
  static Object? currentInningsScore(int instance) => instance;
  // ignore: unused_element
  static Object? currentInningsWickets(int instance) => instance;
  // ignore: unused_element
  static Object? lastEventType(EventType? instance) =>
      _$EventTypeEnumMap[instance];
  // ignore: unused_element
  static Object? overHistory(Map<String, OverModel> instance) =>
      instance.map((k, e) => MapEntry(k, e.toJson()));
}

Map<String, dynamic> _$ScoreboardModelToJson(ScoreboardModel instance) =>
    <String, dynamic>{
      'team1': instance.team1.toJson(),
      'team2': instance.team2.toJson(),
      'matchId': instance.matchId,
      'lastOvers': instance.lastOvers,
      'extras': instance._extras.toJson(),
      'ballsToBowl': instance.ballsToBowl,
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
