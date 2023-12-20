import 'package:json_annotation/json_annotation.dart';

part 'tournament_model.g.dart';

@JsonSerializable()
class TournamenModel {
  final String tournamentName;
  final DateTime tournamentStartDateTime;
  final DateTime tournamentEndDateTime;
  final double fees;
  @JsonKey(
    unknownEnumValue: TournamentListType.upcoming,
    fromJson: tournamentListTypeFromJson,
  )
  final TournamentListType tournamentListType;

  TournamenModel(
      {required this.tournamentName,
      required this.tournamentStartDateTime,
      required this.tournamentEndDateTime,
      required this.tournamentListType,
      required this.fees});
  factory TournamenModel.fromJson(Map<String, dynamic> json) =>
      _$TournamenModelFromJson(json);

  Map<String, dynamic> toJson() => _$TournamenModelToJson(this);

  static TournamentListType tournamentListTypeFromJson(String value) {
    switch (value) {
      case 'upcoming':
        return TournamentListType.upcoming;
      case 'ongoing':
        return TournamentListType.ongoing;
      case 'completed':
        return TournamentListType.completed;
      default:
        return TournamentListType.upcoming;
    }
  }
}

enum TournamentListType { upcoming, ongoing, completed }
