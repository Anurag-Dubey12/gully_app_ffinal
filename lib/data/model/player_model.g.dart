// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerModel _$PlayerModelFromJson(Map<String, dynamic> json) => PlayerModel(
      name: json['name'] as String,
      id: json['_id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      role: json['role'] as String,
    )
      ..batting = json['batting'] == null
          ? null
          : BattingModel.fromJson(json['batting'] as Map<String, dynamic>)
      ..bowling = json['bowling'] == null
          ? null
          : BowlingModel.fromJson(json['bowling'] as Map<String, dynamic>);

Map<String, dynamic> _$PlayerModelToJson(PlayerModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'role': instance.role,
      'batting': instance.batting?.toJson(),
      'bowling': instance.bowling?.toJson(),
    };
