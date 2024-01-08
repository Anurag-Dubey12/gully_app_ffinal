import 'package:json_annotation/json_annotation.dart';

part 'extras_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ExtraModel {
  int wides;
  int noBalls;
  int byes;
  int legByes;
  int penalty;

  ExtraModel(
      {required this.wides,
      required this.noBalls,
      required this.byes,
      required this.legByes,
      required this.penalty});

  factory ExtraModel.fromJson(Map<String, dynamic> json) =>
      _$ExtraModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExtraModelToJson(this);
}
