import 'package:gully_app/data/model/batting_model.dart';
import 'package:gully_app/data/model/bowling_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PlayerModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String phoneNumber;
  final String role;
  @JsonKey(
    fromJson: BattingModel.fromJson,
  )
  BattingModel? batting = BattingModel(
      runs: 0,
      balls: 0,
      fours: 0,
      sixes: 0,
      strikeRate: 0,
      bowledBy: '',
      outType: '');
  @JsonKey(fromJson: BowlingModel.fromJson)

  BowlingModel? bowling = BowlingModel(
      runs: 0,
      noBalls: 0,
      wickets: 0,
      maidens: 0,
      economy: 0,
      fours: 0,
      sixes: 3,
      wides: 2);
  PlayerModel(
      {required this.name,
      required this.id,
      required this.phoneNumber,
      required this.role});

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerModelToJson(this);

}
