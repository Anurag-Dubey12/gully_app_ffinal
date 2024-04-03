import 'package:json_annotation/json_annotation.dart';

import 'team_model.dart';

part 'challenge_match.g.dart';

@JsonSerializable(createToJson: false)
class ChallengeMatchModel {
  @JsonKey(name: '_id')
  final String id;
  final TeamModel team1;
  final TeamModel team2;
  final String status;
  final String challengedBy;

  ChallengeMatchModel({
    required this.id,
    required this.status,
    required this.team1,
    required this.team2,
    required this.challengedBy,
  });

  factory ChallengeMatchModel.fromJson(Map<String, dynamic> json) =>
      _$ChallengeMatchModelFromJson(json);
}
