// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TournamentModel _$TournamentModelFromJson(Map<String, dynamic> json) =>
    TournamentModel(
      tournamentName: json['tournamentName'] as String,
      id: json['_id'] as String,
      disclaimer: json['disclaimer'] as String?,
      rules: json['rules'] as String?,
      tournamentPrize: TournamentModel.extractName(
          json['tournamentPrize'] as Map<String, dynamic>),
      organizerName: json['organizerName'] as String?,
      ballCharges: (json['ballCharges'] as num).toInt(),
      pendingTeamsCount: (json['pendingTeamsCount'] as num?)?.toInt() ?? 0,
      phoneNumber: json['phoneNumber'] as String?,
      tournamentLimit: (json['tournamentLimit'] as num?)?.toInt() ?? 0,
      registeredTeamsCount:
          (json['registeredTeamsCount'] as num?)?.toInt() ?? 0,
      stadiumAddress: json['stadiumAddress'] as String,
      tournamentStartDateTime:
          DateTime.parse(json['tournamentStartDateTime'] as String),
      tournamentEndDateTime:
          DateTime.parse(json['tournamentEndDateTime'] as String),
      pitchType: TournamentModel.extractName(
          json['pitchType'] as Map<String, dynamic>),
      breakfastCharges: (json['breakfastCharges'] as num).toInt(),
      ballType:
          TournamentModel.extractName(json['ballType'] as Map<String, dynamic>),
      user: CoHostModel.fromJson(json['user'] as Map<String, dynamic>),
      coverPhoto: json['coverPhoto'] as String?,
      fees: (json['fees'] as num).toDouble(),
      coHost1: json['coHost1'] == null
          ? null
          : CoHostModel.fromJson(json['coHost1'] as Map<String, dynamic>),
      coHost2: json['coHost2'] == null
          ? null
          : CoHostModel.fromJson(json['coHost2'] as Map<String, dynamic>),
      authority: json['authority'] as String?,
      isSponsershippurchase: json['isSponsershippurchase'] as bool?,
      sponsershipPackageId: json['sponsershipPackageId'] as String?,
    );
