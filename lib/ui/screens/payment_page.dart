import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/ui/screens/coupon_view.dart';
import 'package:gully_app/ui/screens/home_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../utils/app_logger.dart';

class PaymentPage extends StatefulWidget {
  final TournamentModel tournament;

  const PaymentPage({super.key, required this.tournament});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  double fees = 0;
  final _razorpay = Razorpay();
  String? couponCode;
  double discount = 0;
  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    fees = widget.tournament.fees;
  }

  getFee() async {
    final controller = Get.find<TournamentController>();
    fees = await controller.getTournamentFee(widget.tournament.id);
    setState(() {});
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) async {
    logger.f('Payment Success');
    successSnackBar('Payment Success').then(
      (value) => Get.offAll(() => const HomeScreen(),
          predicate: (route) => route.name == '/HomeScreen'),
    );
  }

  _handlePaymentError(PaymentFailureResponse response) {
    logger.f('Payment Error ${response.message.toString()}');
    errorSnackBar('Payment Failed\n${response.message}');
  }

  _handleExternalWallet(ExternalWalletResponse response) {
    logger.f('External Wallet');
    errorSnackBar('External Wallet');
  }

  startPayment() async {
    final controller = Get.find<TournamentController>();
    final authController = Get.find<AuthController>();
    final id = await controller.createOrder(
        discountAmount: fees,
        tournamentId: widget.tournament.id,
        totalAmount: widget.tournament.fees,
        coupon: couponCode);
    logger.f("ID $id");
    var options = {
      'key': 'rzp_live_6sW7limWXGaS3k',
      'amount': (fees - discount) * 100,
      'order_id': id,
      'name': 'Gully Team.',
      'description': 'Tournament Fee',
      'prefill': {
        'contact': authController.state?.phoneNumber,
        'email': authController.state?.email
      }
    };
    _razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    // getFee();
    return PopScope(
      canPop: false,
      child: GradientBuilder(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppTheme.primaryColor,
            title: const Text('Review Tournament',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text('${widget.tournament.tournamentName} ',
                            style: const TextStyle(
                                color: AppTheme.secondaryYellowColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                      // const Center(
                      //   child: Text('Tournament ID: 1234567890',
                      //       style: TextStyle(
                      //         // color: AppTheme.secondaryYellowColor,
                      //         fontSize: 13,
                      //         color: Colors.grey,
                      //       )),
                      // ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Start Date:',
                                  style: TextStyle(
                                    // color: AppTheme.secondaryYellowColor,
                                    fontSize: 14,
                                    color: Colors.grey,
                                  )),
                              Text(
                                  DateFormat("dd-MMM-yyyy").format(widget
                                      .tournament.tournamentStartDateTime),
                                  style: TextStyle(
                                    // color: AppTheme.secondaryYellowColor,
                                    fontSize: 14,
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('End Date:',
                                  style: TextStyle(
                                    // color: AppTheme.secondaryYellowColor,
                                    fontSize: 14,
                                    color: Colors.grey,
                                  )),
                              Text(
                                  DateFormat("dd-MMM-yyyy").format(
                                      widget.tournament.tournamentEndDateTime),
                                  style: TextStyle(
                                    // color: AppTheme.secondaryYellowColor,
                                    fontSize: 14,
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Text('Tournament Prize:',
                              style: TextStyle(
                                // color: AppTheme.secondaryYellowColor,
                                fontSize: 14,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w400,
                              )),
                          const Spacer(),
                          Text(widget.tournament.tournamentPrize ?? "N/A",
                              style: TextStyle(
                                // color: AppTheme.secondaryYellowColor,
                                fontSize: 16,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Text('Entry Fee:',
                              style: TextStyle(
                                // color: AppTheme.secondaryYellowColor,
                                fontSize: 14,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w400,
                              )),
                          const Spacer(),
                          Text("₹${widget.tournament.fees}",
                              style: TextStyle(
                                // color: AppTheme.secondaryYellowColor,
                                fontSize: 16,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Text('Team Limit',
                              style: TextStyle(
                                // color: AppTheme.secondaryYellowColor,
                                fontSize: 14,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w400,
                              )),
                          const Spacer(),
                          Text(widget.tournament.tournamentLimit.toString(),
                              style: TextStyle(
                                // color: AppTheme.secondaryYellowColor,
                                fontSize: 16,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                      const SizedBox(height: 22),
                      GestureDetector(
                        onTap: () async {
                          final res = await Get.to(
                              () => CouponView(
                                    tournamentId: widget.tournament.id,
                                    amount: fees,
                                  ),
                              fullscreenDialog: true);
                          if (res != null) {
                            setState(() {
                              couponCode = res['code'];
                              discount = res['discount'];
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.secondaryYellowColor
                                  .withOpacity(0.8),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                const Icon(Icons.discount_outlined),
                                const SizedBox(width: 12),
                                Text('Apply Coupon',
                                    style: TextStyle(
                                      // color: AppTheme.secondaryYellowColor,
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    )),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text('Tournament Summary',
                          style: TextStyle(
                            // color: AppTheme.secondaryYellowColor,
                            fontSize: 18,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text('Tournament Fee:',
                              style: TextStyle(
                                // color: AppTheme.secondaryYellowColor,
                                fontSize: 14,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w400,
                              )),
                          const Spacer(),
                          Text('₹$fees',
                              style: TextStyle(
                                // color: AppTheme.secondaryYellowColor,
                                fontSize: 16,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Discount:',
                                  style: TextStyle(
                                    // color: AppTheme.secondaryYellowColor,
                                    fontSize: 14,
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w400,
                                  )),
                              const SizedBox(height: 5),
                              if (couponCode != null)
                                Chip(
                                  label: Text(
                                    'Promocode: $couponCode',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  side: const BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.grey),
                                )
                            ],
                          ),
                          const Spacer(),
                          Text('-₹$discount',
                              style: TextStyle(
                                // color: AppTheme.secondaryYellowColor,
                                fontSize: 16,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      Row(
                        children: [
                          Text('Total Amount:',
                              style: TextStyle(
                                // color: AppTheme.secondaryYellowColor,
                                fontSize: 14,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w400,
                              )),
                          const Spacer(),
                          Text('₹${fees - discount}',
                              style: TextStyle(
                                // color: AppTheme.secondaryYellowColor,
                                fontSize: 20,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          onPressed: () {
                            startPayment();
                          },
                          child: const Text('Proceed to Payment',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                      ),
                      const SizedBox(height: 22),
                      const CancellationPolicyWidget()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CancellationPolicyWidget extends StatelessWidget {
  const CancellationPolicyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 300,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cancellation Policy',
                style: TextStyle(
                  // color: AppTheme.secondaryYellowColor,
                  fontSize: 18,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 12),
            Text(
                'The tournament fee is non-refundable. In case of any issue, kindly contact Gully Support.',
                style: TextStyle(
                  // color: AppTheme.secondaryYellowColor,
                  fontSize: 14,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w400,
                )),
          ],
        ),
      ),
    );
  }
}
