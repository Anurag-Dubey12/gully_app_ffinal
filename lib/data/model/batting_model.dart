import 'package:json_annotation/json_annotation.dart';

part 'batting_model.g.dart';

@JsonSerializable()
class BattingModel {
  int runs;
  int balls;
  int fours;
  int sixes;
  double strikeRate;
  String bowledBy;
  String outType;

  BattingModel(
      {required this.runs,
      required this.balls,
      required this.fours,
      required this.sixes,
      required this.strikeRate,
      required this.bowledBy,
      required this.outType});
//
  factory BattingModel.fromJson(Map<String, dynamic> json) =>
      _$BattingModelFromJson(json);
  Map<String, dynamic> toJson() => _$BattingModelToJson(this);
}
