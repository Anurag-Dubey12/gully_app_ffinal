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
  factory BattingModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return BattingModel(
          runs: 0,
          balls: 0,
          fours: 0,
          sixes: 0,
          strikeRate: 0,
          bowledBy: '',
          outType: '');
    } else {
      return _$BattingModelFromJson(json);
    }
  }
  Map<String, dynamic> toJson() => _$BattingModelToJson(this);
}
