import 'package:json_annotation/json_annotation.dart';

import '../controller/scoreboard_controller.dart';

part 'overs_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OverModel {
  final int over;
  final int ball;
  final int run;
  final int wickets;
  final int extra;
  final int total;
  final List<EventType> events;
  final String? bowlerId;
  final String? strikerId;
  final String? nonStrikerId;
  final String? wicketTakerId;
  final String? wicketType;

  OverModel(
      {required this.over,
      this.bowlerId,
      this.strikerId,
      this.nonStrikerId,
      this.wicketTakerId,
      this.wicketType,
      required this.ball,
      required this.run,
      required this.wickets,
      required this.extra,
      required this.total,
      required this.events});

  factory OverModel.fromJson(Map<String, dynamic> json) =>
      _$OverModelFromJson(json);
  Map<String, dynamic> toJson() => _$OverModelToJson(this);
}
