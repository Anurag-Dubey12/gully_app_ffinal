import 'package:json_annotation/json_annotation.dart';

part 'tournament_model.g.dart';

@JsonSerializable(createToJson: false)
class TournamentModel {
  @JsonKey(name: '_id')
  final String id;
  final String tournamentName;
  final DateTime tournamentStartDateTime;
  final DateTime tournamentEndDateTime;
  final double fees;
  @JsonKey(defaultValue: 0, disallowNullValue: false)
  final int tournamentLimit;
  @JsonKey(defaultValue: 0)
  final int registeredTeamsCount;
  @JsonKey(disallowNullValue: false)
  final String? phoneNumber;

  final int ballCharges;
  final int breakfastCharges;
  final String ballType;
  final String pitchType;
  final String stadiumAddress;

  TournamentModel(
      {required this.tournamentName,
      required this.id,
      required this.ballCharges,
      required this.phoneNumber,
      required this.tournamentLimit,
      required this.registeredTeamsCount,
      required this.stadiumAddress,
      required this.tournamentStartDateTime,
      required this.tournamentEndDateTime,
      required this.pitchType,
      required this.breakfastCharges,
      required this.ballType,
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
