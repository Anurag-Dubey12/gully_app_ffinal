class AdvertisementModel {
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

  AdvertisementModel({
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

  AdvertisementModel copyWith({
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
    return AdvertisementModel(
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

  @override
  String toString() {
    return 'AdvertisementModel(id: $id, userId: $userId, imageUrl: $imageUrl, adPlacement: $adPlacement, startDate: $startDate, endDate: $endDate, totalAmount: $totalAmount, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}