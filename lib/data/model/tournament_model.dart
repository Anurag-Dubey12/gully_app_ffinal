import 'package:json_annotation/json_annotation.dart';

part 'tournament_model.g.dart';

@JsonSerializable(createToJson: false)
class TournamentModel {
  final String tournamentName;
  final DateTime tournamentStartDateTime;
  final DateTime tournamentEndDateTime;
  final double fees;
  final int tournamentLimit;
  final int registeredTeamsCount;
  TournamentModel(
      {required this.tournamentName,
      required this.tournamentLimit,
      required this.registeredTeamsCount,
      required this.tournamentStartDateTime,
      required this.tournamentEndDateTime,
      // required this.tournamentListType,
      required this.fees});
  factory TournamentModel.fromJson(Map<String, dynamic> json) =>
      _$TournamentModelFromJson(json);

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
