import 'package:json_annotation/json_annotation.dart';

part 'opponent_model.g.dart';

@JsonSerializable(createToJson: false)
class OpponentModel {
  final String tournamentId;
  final String teamId;
  final String tournamentName;

  OpponentModel({
    required this.tournamentId,
    required this.teamId,
    required this.tournamentName,
  });

  factory OpponentModel.fromJson(Map<String, dynamic> json) =>
      _$OpponentModelFromJson(json);
}
