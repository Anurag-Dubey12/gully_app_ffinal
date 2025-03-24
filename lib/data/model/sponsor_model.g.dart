// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sponsor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TournamentSponsor _$TournamentSponsorFromJson(Map<String, dynamic> json) =>
    TournamentSponsor(
      id: json['_id'] as String,
      brandMedia: json['sponsorMedia'] as String,
      brandName: json['sponsorName'] as String?,
      brandDescription: json['sponsorDescription'] as String?,
      brandUrl: json['sponsorUrl'] as String?,
      tournament: json['tournamentId'] as String,
      isActive: json['isActive'] as bool,
      isVideo: json['isVideo'] as bool,
    );

Map<String, dynamic> _$TournamentSponsorToJson(TournamentSponsor instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'sponsorMedia': instance.brandMedia,
      'sponsorName': instance.brandName,
      'sponsorDescription': instance.brandDescription,
      'sponsorUrl': instance.brandUrl,
      'tournamentId': instance.tournament,
      'isActive': instance.isActive,
      'isVideo': instance.isVideo,
    };
