import 'package:json_annotation/json_annotation.dart';

part 'challenge_match.g.dart';

@JsonSerializable(createToJson: false)
class ChallengeMatchModel {
  final String id;
  final String team1Id;
  final String team2Id;
  final String team1Name;
  final String team2Name;

  ChallengeMatchModel(
      {required this.id,
      required this.team1Id,
      required this.team2Id,
      required this.team1Name,
      required this.team2Name});

  factory ChallengeMatchModel.fromJson(Map<String, dynamic> json) =>
      _$ChallengeMatchModelFromJson(json);
}
