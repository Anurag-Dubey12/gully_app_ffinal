import 'package:json_annotation/json_annotation.dart';

part 'team_model.g.dart';

@JsonSerializable(createToJson: false)
class TeamModel {
  @JsonKey(name: 'teamName')
  final String name;
  @JsonKey(name: 'teamLogo')
  final String logo;
  @JsonKey(name: '_id')
  final String id;
  final int playersCount;

  TeamModel(this.playersCount,
      {required this.name, required this.logo, required this.id});

  factory TeamModel.fromJson(Map<String, dynamic> json) =>
      _$TeamModelFromJson(json);
}
