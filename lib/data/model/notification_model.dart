import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final String title;
  final String body;
  final String? image;
  final String? deepLink;
  final String? notificationType;
  final String? notificationId;
  final DateTime createdAt;

  NotificationModel(
      {required this.title,
      required this.body,
      required this.image,
      required this.deepLink,
      required this.notificationType,
      required this.notificationId,
      required this.createdAt});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
