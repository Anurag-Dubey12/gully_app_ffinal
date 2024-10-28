import 'package:json_annotation/json_annotation.dart';

part 'promote_banner_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PromoteBannerModel {
  @JsonKey(name: '_id')
  final String id;

  final String userId;
  final String imageUrl;
  final List<String> adPlacement;
  final DateTime startDate;
  final DateTime endDate;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  PromoteBannerModel({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.adPlacement,
    required this.startDate,
    required this.endDate,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  PromoteBannerModel copyWith({
    String? id,
    String? userId,
    String? imageUrl,
    List<String>? adPlacement,
    DateTime? startDate,
    DateTime? endDate,
    double? totalAmount,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PromoteBannerModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      adPlacement: adPlacement ?? this.adPlacement,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int get durationInDays => endDate.difference(startDate).inDays + 1;

  factory PromoteBannerModel.fromJson(Map<String, dynamic> json) =>
      _$PromoteBannerModelFromJson(json);

  Map<String, dynamic> toJson() => _$PromoteBannerModelToJson(this);

  @override
  String toString() {
    return 'PromoteBannerModel(id: $id, userId: $userId, imageUrl: $imageUrl, adPlacement: $adPlacement, startDate: $startDate, endDate: $endDate, totalAmount: $totalAmount, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
