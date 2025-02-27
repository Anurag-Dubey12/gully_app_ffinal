import 'package:gully_app/data/model/package_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'PromotionalBannerModel.dart';

part 'txn_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Transaction {
  final String? tournamentName;
  final String? startDate;
  final String? endDate;
  final String status;
  final double amount;
  @JsonKey(defaultValue: "")
  final String coupon;
  final double amountWithoutCoupon;
  final String orderId;
  final String createdAt;
  // final String? invoiceUrl;
  @JsonKey(name: "ordertype")
  final String orderType;
  @JsonKey(name: "bannerId")
  final PromotionalBanner? banner;
  @JsonKey(name: "sponsorPackageId")
  final Package? sponsor;
  final String? locationAddress;

  Transaction({
    this.tournamentName,
    this.startDate,
    this.endDate,
    required this.status,
    required this.amount,
    required this.coupon,
    required this.amountWithoutCoupon,
    required this.orderId,
    // this.invoiceUrl,
    required this.createdAt,
    required this.orderType,
    this.banner,
    this.sponsor,
    this.locationAddress,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  String get displayDate {
    if (orderType.toLowerCase() == 'banner' || orderType.toLowerCase() == 'sponsor') {
      return startDate ?? createdAt;
    }
    return createdAt;
  }

  String getStatusText() {
    switch (status.toLowerCase()) {
      case 'successful':
        return 'Success';
      case 'failed':
        return 'Failed';
      default:
        return 'Failed';
    }
  }
}