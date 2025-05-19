import 'package:gully_app/data/model/package_model.dart';
import 'package:gully_app/data/model/shop_model.dart';
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
  @JsonKey(name: "gstAmount", defaultValue: 0.0)
  final double gstAmount;
  @JsonKey(name: "amountbeforegst", defaultValue: 0)
  final double amountbeforegst;
  @JsonKey(name: "totalAmountWithGST", defaultValue: 0.0)
  final double totalAmountWithGST;
  @JsonKey(defaultValue: 0.0)
  final double amountWithoutCoupon;
  final String orderId;
  final String createdAt;
  @JsonKey(name: "ordertype", defaultValue: '')
  final String orderType;
  @JsonKey(name: "bannerId")
  final PromotionalBanner? banner;
  @JsonKey(name: "shopId")
  final String? shop;
  @JsonKey(name: "PackageId")
  final Package? package;
  final String? locationAddress;

  Transaction({
    this.tournamentName,
    this.startDate,
    this.endDate,
    this.status = '',
    this.amount = 0.0,
    this.gstAmount = 0.0,
    this.amountbeforegst = 0,
    this.totalAmountWithGST = 0.0,
    this.amountWithoutCoupon = 0.0,
    this.orderId = '',
    this.createdAt = '',
    this.orderType = '',
    this.banner,
    this.package,
    this.shop,
    this.locationAddress,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  String get displayDate {
    if (orderType.toLowerCase() == 'banner' ||
        orderType.toLowerCase() == 'sponsor') {
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
