import 'package:json_annotation/json_annotation.dart';

part 'bowling_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BowlingModel {
  num overs = 0;
  int runs = 0;
  int wickets = 0;
  double economy = 0;
  int maidens = 0;
  int fours = 0;
  int sixes = 0;
  int wides = 0;
  int noBalls = 0;

  BowlingModel(
      {required this.overs,
      required this.runs,
      required this.wickets,
      required this.economy,
      required this.maidens,
      required this.fours,
      required this.sixes,
      required this.wides,
      required this.noBalls});

  factory BowlingModel.fromJson(Map<String, dynamic> json) =>
      _$BowlingModelFromJson(json);
  Map<String, dynamic> toJson() => _$BowlingModelToJson(this);
}
