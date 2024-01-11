import 'package:gully_app/data/model/player_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partnership_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PartnershipModel {
  final PlayerModel player1;
  final PlayerModel player2;
  @JsonKey(includeToJson: true, name: 'runs')
  int get runs => player1.batting!.runs + player2.batting!.runs;
  @JsonKey(includeToJson: true, name: 'balls')
  int get balls => player1.batting!.balls + player2.batting!.balls;
  PartnershipModel({required this.player1, required this.player2});

  factory PartnershipModel.fromJson(Map<String, dynamic> json) =>
      _$PartnershipModelFromJson(json);

  Map<String, dynamic> toJson() => _$PartnershipModelToJson(this);
}
