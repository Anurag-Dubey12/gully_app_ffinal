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

  // factory AdvertisementModel.fromMap(Map<String, dynamic> map, String documentId) {
  //   return AdvertisementModel(
  //     id: documentId,
  //     userId: map['userId'] as String,
  //     imageUrl: map['imageUrl'] as String,
  //     adPlacement: List<String>.from(map['adPlacement']),
  //     startDate: (map['startDate'] as Timestamp).toDate(),
  //     endDate: (map['endDate'] as Timestamp).toDate(),
  //     totalAmount: (map['totalAmount'] as num).toDouble(),
  //     status: map['status'] as String,
  //     createdAt: (map['createdAt'] as Timestamp).toDate(),
  //     updatedAt: map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : null,
  //   );
  // }

  // Convert the AdvertisementModel to a Map
  // Map<String, dynamic> toMap() {
  //   return {
  //     'userId': userId,
  //     'imageUrl': imageUrl,
  //     'adPlacement': adPlacement,
  //     'startDate': Timestamp.fromDate(startDate),
  //     'endDate': Timestamp.fromDate(endDate),
  //     'totalAmount': totalAmount,
  //     'status': status,
  //     'createdAt': Timestamp.fromDate(createdAt),
  //     'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
  //   };
  // }

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