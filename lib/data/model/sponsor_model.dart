import 'package:json_annotation/json_annotation.dart';

part 'sponsor_model.g.dart';

@JsonSerializable()
class TournamentSponsor {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey(name: "sponsorMedia")
  final String brandMedia;
  @JsonKey(name: "sponsorName")
  final String? brandName;
  @JsonKey(name: "sponsorDescription")
  final String? brandDescription;
  @JsonKey(name: "sponsorUrl")
  final String? brandUrl;
  @JsonKey(name: "tournamentId")
  final String tournament;
  @JsonKey(name: "isActive")
  final bool isActive;
  @JsonKey(name: "isVideo")
  final bool isVideo;

  TournamentSponsor({
    required this.id,
    required this.brandMedia,
    this.brandName,
    this.brandDescription,
    this.brandUrl,
    required this.tournament,
    required this.isActive,
    required this.isVideo,
  });

  factory TournamentSponsor.fromJson(Map<String, dynamic> json) => _$TournamentSponsorFromJson(json);

  Map<String, dynamic> toJson() => _$TournamentSponsorToJson(this);
}
