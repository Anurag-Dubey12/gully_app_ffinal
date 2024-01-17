// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      title: json['title'] as String,
      body: json['body'] as String,
      image: json['image'] as String?,
      deepLink: json['deepLink'] as String?,
      notificationType: json['notificationType'] as String?,
      notificationId: json['notificationId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'image': instance.image,
      'deepLink': instance.deepLink,
      'notificationType': instance.notificationType,
      'notificationId': instance.notificationId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
