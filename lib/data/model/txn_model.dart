class Transaction {
  final String tournamentName;
  final String startDate;
  final String endDate;
  final String status;
  final double amount;
  final String coupon;
  final double amountWithoutCoupon;
  final String orderId;
  final String createdAt;
  final String? invoiceUrl;

  Transaction(
      {required this.tournamentName,
      required this.startDate,
      required this.endDate,
      required this.status,
      required this.amount,
      required this.coupon,
      required this.amountWithoutCoupon,
      required this.orderId,
      required this.invoiceUrl,
      required this.createdAt});
  //to convert json to model
  factory Transaction.fromJson(Map<String, dynamic> json) {
    print("Parsing transaction: $json");
    try {
      return Transaction(
        tournamentName: json['tournament']['tournamentName'] ?? 'Unknown Tournament',
        startDate: json['tournament']['tournamentStartDateTime'] ?? '',
        endDate: json['tournament']['tournamentEndDateTime'] ?? '',
        status: json['status'] ?? '',
        amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
        coupon: json['coupon'] ?? '',
        amountWithoutCoupon: double.tryParse(json['amountWithoutCoupon']?.toString() ?? '0') ?? 0.0,
        orderId: json['orderId'] ?? '',
        createdAt: json['createdAt'] ?? '',
        invoiceUrl: json['invoiceUrl'],
      );
    } catch (e) {
      print("Error parsing transaction: $e");
      print("Problematic JSON: $json");
      rethrow;
    }
  }
}
