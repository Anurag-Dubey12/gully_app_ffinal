// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'txn_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      tournamentName: json['tournamentName'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      status: json['status'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      gstAmount: (json['gstAmount'] as num?)?.toDouble() ?? 0.0,
      amountbeforegst: (json['amountbeforegst'] as num?)?.toDouble() ?? 0,
      totalAmountWithGST:
          (json['totalAmountWithGST'] as num?)?.toDouble() ?? 0.0,
      amountWithoutCoupon:
          (json['amountWithoutCoupon'] as num?)?.toDouble() ?? 0.0,
      orderId: json['orderId'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      orderType: json['ordertype'] as String? ?? '',
      banner: json['bannerId'] == null
          ? null
          : PromotionalBanner.fromJson(
              json['bannerId'] as Map<String, dynamic>),
      sponsor: json['sponsorPackageId'] == null
          ? null
          : Package.fromJson(json['sponsorPackageId'] as Map<String, dynamic>),
      locationAddress: json['locationAddress'] as String?,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'tournamentName': instance.tournamentName,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'status': instance.status,
      'amount': instance.amount,
      'gstAmount': instance.gstAmount,
      'amountbeforegst': instance.amountbeforegst,
      'totalAmountWithGST': instance.totalAmountWithGST,
      'amountWithoutCoupon': instance.amountWithoutCoupon,
      'orderId': instance.orderId,
      'createdAt': instance.createdAt,
      'ordertype': instance.orderType,
      'bannerId': instance.banner?.toJson(),
      'sponsorPackageId': instance.sponsor?.toJson(),
      'locationAddress': instance.locationAddress,
    };
