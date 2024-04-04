// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scoreboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScoreboardModel _$ScoreboardModelFromJson(Map<String, dynamic> json) =>
    ScoreboardModel(
      team1: TeamModel.fromJson(json['team1'] as Map<String, dynamic>),
      currentInnings: json['currentInnings'] as int,
      team2: TeamModel.fromJson(json['team2'] as Map<String, dynamic>),
      matchId: json['matchId'] as String,
      tossWonBy: json['tossWonBy'] as String,
      electedTo: json['electedTo'] as String?,
      totalOvers: json['totalOvers'] as int,
      extras: ExtraModel.fromJson(json['extras'] as Map<String, dynamic>),
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
      overCompleted: json['overCompleted'] as bool? ?? true,
      partnerships: (json['partnerships'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, PartnershipModel.fromJson(e as Map<String, dynamic>)),
          ) ??
          {},
      isChallenge: json['isChallenge'] as bool? ?? false,
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
      ..currentInningsScore = json['currentInningsScore'] as int;

// ignore: unused_element
abstract class _$ScoreboardModelPerFieldToJson {
  // ignore: unused_element
  static Object? team1(TeamModel instance) => instance.toJson();
  // ignore: unused_element
  static Object? team2(TeamModel instance) => instance.toJson();
  // ignore: unused_element
  static Object? isChallenge(bool? instance) => instance;
  // ignore: unused_element
  static Object? firstInnings(InningsModel? instance) => instance?.toJson();
  // ignore: unused_element
  static Object? secondInnings(InningsModel? instance) => instance?.toJson();
  // ignore: unused_element
  static Object? partnerships(Map<String, PartnershipModel> instance) =>
      instance.map((k, e) => MapEntry(k, e.toJson()));
  // ignore: unused_element
  static Object? matchId(String instance) => instance;
  // ignore: unused_element
  static Object? tossWonBy(String instance) => instance;
  // ignore: unused_element
  static Object? electedTo(String? instance) => instance;
  // ignore: unused_element
  static Object? totalOvers(int instance) => instance;
  // ignore: unused_element
  static Object? overCompleted(bool instance) => instance;
  // ignore: unused_element
  static Object? extras(ExtraModel instance) => instance.toJson();
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
  // ignore: unused_element
  static Object? totalWickets(int instance) => instance;
}

Map<String, dynamic> _$ScoreboardModelToJson(ScoreboardModel instance) =>
    <String, dynamic>{
      'team1': instance.team1.toJson(),
      'team2': instance.team2.toJson(),
      'isChallenge': instance.isChallenge,
      'firstInnings': instance.firstInnings?.toJson(),
      'secondInnings': instance.secondInnings?.toJson(),
      'partnerships':
          instance.partnerships.map((k, e) => MapEntry(k, e.toJson())),
      'matchId': instance.matchId,
      'tossWonBy': instance.tossWonBy,
      'electedTo': instance.electedTo,
      'totalOvers': instance.totalOvers,
      'overCompleted': instance.overCompleted,
      'extras': instance.extras.toJson(),
      'ballsToBowl': instance.ballsToBowl,
      'currentOver': instance.currentOver,
      'currentBall': instance.currentBall,
      'currentInnings': instance.currentInnings,
      'currentInningsScore': instance.currentInningsScore,
      'bowlerId': instance.bowlerId,
      'strikerId': instance.strikerId,
      'nonStrikerId': instance.nonStrikerId,
      'firstInningHistory':
          instance.firstInningHistory.map((k, e) => MapEntry(k, e.toJson())),
      'secondInningHistory':
          instance.secondInningHistory.map((k, e) => MapEntry(k, e.toJson())),
      'totalWickets': instance.totalWickets,
    };
