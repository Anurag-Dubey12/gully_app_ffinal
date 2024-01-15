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
      tossWonBy: json['tossWonBy'] as String,
      electedTo: json['electedTo'] as String?,
      totalOvers: json['totalOvers'] as int,
      firstInningHistory:
          (json['firstInningHistory'] as Map<String, dynamic>?)?.map(
                (k, e) =>
                    MapEntry(k, OverModel.fromJson(e as Map<String, dynamic>)),
              ) ??
              {},
      secondInningHistory:
          (json['secondInningHistory'] as Map<String, dynamic>?)?.map(
                (k, e) =>
                    MapEntry(k, OverModel.fromJson(e as Map<String, dynamic>)),
              ) ??
              {},
      strikerId: json['strikerId'] as String,
      nonStrikerId: json['nonStrikerId'] as String,
      bowlerId: json['bowlerId'] as String,
    )
      ..firstInnings = json['firstInnings'] == null
          ? null
          : InningsModel.fromJson(json['firstInnings'] as Map<String, dynamic>)
      ..secondInnings = json['secondInnings'] == null
          ? null
          : InningsModel.fromJson(json['secondInnings'] as Map<String, dynamic>)
      ..ballsToBowl = json['ballsToBowl'] as int
      ..currentOver = json['currentOver'] as int
      ..currentBall = json['currentBall'] as int
      ..currentInnings = json['currentInnings'] as int
      ..currentInningsScore = json['currentInningsScore'] as int
      ..currentInningsWickets = json['currentInningsWickets'] as int
      ..lastEventType =
          $enumDecodeNullable(_$EventTypeEnumMap, json['lastEventType']);

// ignore: unused_element
abstract class _$ScoreboardModelPerFieldToJson {
  // ignore: unused_element
  static Object? team1(TeamModel instance) => instance.toJson();
  // ignore: unused_element
  static Object? team2(TeamModel instance) => instance.toJson();
  // ignore: unused_element
  static Object? firstInnings(InningsModel? instance) => instance?.toJson();
  // ignore: unused_element
  static Object? secondInnings(InningsModel? instance) => instance?.toJson();
  // ignore: unused_element
  static Object? matchId(String instance) => instance;
  // ignore: unused_element
  static Object? tossWonBy(String instance) => instance;
  // ignore: unused_element
  static Object? electedTo(String? instance) => instance;
  // ignore: unused_element
  static Object? totalOvers(int instance) => instance;
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
  static Object? bowlerId(String instance) => instance;
  // ignore: unused_element
  static Object? strikerId(String instance) => instance;
  // ignore: unused_element
  static Object? nonStrikerId(String instance) => instance;
  // ignore: unused_element
  static Object? firstInningHistory(Map<String, OverModel> instance) =>
      instance.map((k, e) => MapEntry(k, e.toJson()));
  // ignore: unused_element
  static Object? secondInningHistory(Map<String, OverModel> instance) =>
      instance.map((k, e) => MapEntry(k, e.toJson()));
}

Map<String, dynamic> _$ScoreboardModelToJson(ScoreboardModel instance) =>
    <String, dynamic>{
      'team1': instance.team1.toJson(),
      'team2': instance.team2.toJson(),
      'firstInnings': instance.firstInnings?.toJson(),
      'secondInnings': instance.secondInnings?.toJson(),
      'matchId': instance.matchId,
      'tossWonBy': instance.tossWonBy,
      'electedTo': instance.electedTo,
      'totalOvers': instance.totalOvers,
      'extras': instance._extras.toJson(),
      'ballsToBowl': instance.ballsToBowl,
      'currentOver': instance.currentOver,
      'currentBall': instance.currentBall,
      'currentInnings': instance.currentInnings,
      'currentInningsScore': instance.currentInningsScore,
      'currentInningsWickets': instance.currentInningsWickets,
      'lastEventType': _$EventTypeEnumMap[instance.lastEventType],
      'bowlerId': instance.bowlerId,
      'strikerId': instance.strikerId,
      'nonStrikerId': instance.nonStrikerId,
      'firstInningHistory':
          instance.firstInningHistory.map((k, e) => MapEntry(k, e.toJson())),
      'secondInningHistory':
          instance.secondInningHistory.map((k, e) => MapEntry(k, e.toJson())),
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
