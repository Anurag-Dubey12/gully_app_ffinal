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

  Transaction(
      {required this.tournamentName,
      required this.startDate,
      required this.endDate,
      required this.status,
      required this.amount,
      required this.coupon,
      required this.amountWithoutCoupon,
      required this.orderId,
      required this.createdAt});
  //to convert json to model
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      tournamentName: json['tournamentId']['tournamentName'],
      startDate: json['tournamentId']['tournamentStartDateTime'],
      endDate: json['tournamentId']['tournamentEndDateTime'],
      status: json['status'],
      amount: double.parse(json['amount'].toString()),
      coupon: json['coupon'],
      amountWithoutCoupon: double.parse(json['amountWithoutCoupon'].toString()),
      orderId: json['orderId'],
      createdAt: json['createdAt'],
    );
  }
}
