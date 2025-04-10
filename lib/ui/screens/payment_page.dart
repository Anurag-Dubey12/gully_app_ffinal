import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
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
  final Map<String, dynamic> tournament;
  const PaymentPage({super.key, required this.tournament});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  double fees = 0;
  final _razorpay = Razorpay();
  String? couponCode;
  bool _isCouponVisible = false;
  // double discount = 0;
  double discount = 100;
  DateTime? start_date;
  DateTime? end_date;
  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // fees = widget.tournament.fees;
    start_date = DateTime.parse(widget.tournament['tournamentStartDateTime']);
    end_date = DateTime.parse(widget.tournament['tournamentEndDateTime']);
    //logger.d"The Start Date is:$start_date and end Date is:$end_date");
    getFee();
  }

  getFee() async {
    final controller = Get.find<TournamentController>();
    //logger.d"The Fess Data:${widget.tournament['tournamentLimit']} ");
    fees =
        await controller.getTournamentFee(widget.tournament['tournamentLimit']);
    setState(() {
      //logger.dfees.toString());
    });
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) async {
    logger.f('Payment Success');
    successSnackBar(
            'Congratulations !!!\nyour transaction is been made successful.  Your Tournament ${widget.tournament['tournamentName']} is Live  !',
            title: "Payment Successfull")
        .then(
      (value) => Get.offAll(() => const HomeScreen(),
          predicate: (route) => route.name == '/HomeScreen'),
    );
  }

  _handlePaymentError(PaymentFailureResponse response) {
    logger.f('Payment Error ${response.message.toString()}');
    errorSnackBar('Your transaction has been Failed. please try again !',
        title: "Payment Failed!");
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
        tournamentId: widget.tournament['id'],
        totalAmount: fees,
        coupon: couponCode);
    logger.f("ID $id");
    logger.f("Fees ${fees - discount}");
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
    final TournamentController controller = Get.find<TournamentController>();
    final MiscController connectionController = Get.find<MiscController>();
    // getFee();
    return GradientBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppTheme.primaryColor,
          title: const Text('Review Tournament',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),

        //To Delete the  current filled tournament
        // appBar: AppBar(
        //   iconTheme: const IconThemeData(color: Colors.white),
        //   backgroundColor: AppTheme.primaryColor,
        //   leading: IconButton(
        //     icon: const Icon(Icons.arrow_back),
        //     onPressed: () async {
        //       bool confirm = await showDialog(
        //         context: context,
        //         builder: (BuildContext context) {
        //           return AlertDialog(
        //             title: const Text("Cancel Tournament"),
        //             content: const Text("Are you sure you want to cancel this tournament?"),
        //             actions: <Widget>[
        //               TextButton(
        //                 child: const Text("No"),
        //                 onPressed: () => Navigator.of(context).pop(false),
        //               ),
        //               TextButton(
        //                 child: const Text("Yes"),
        //                 onPressed: () => Navigator.of(context).pop(true),
        //               ),
        //             ],
        //           );
        //         },
        //       );
        //
        //       if (confirm == true) {
        //         final controller = Get.find<TournamentController>();
        //         bool cancelled = await controller.cancelTournament(widget.tournament.id);
        //         if (cancelled) {
        //           Get.back();
        //           successSnackBar("The tournament was successfully cancelled");
        //         } else {
        //           errorSnackBar("Failed to cancel the tournament. Please try again.");
        //         }
        //       }
        //     },
        //   ),
        //   title: const Text('Review Tournament',
        //       style: TextStyle(color: Colors.white, fontSize: 18)),
        // ),
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
                      child: Text('${widget.tournament['tournamentName']} ',
                          style: const TextStyle(
                              color: AppTheme.secondaryYellowColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                    // Center(
                    //   child: Text(
                    //       'Tournament ID: ${widget.tournament.id.substring(7, 15).toUpperCase()}',
                    //       style: const TextStyle(
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
                            Text(DateFormat("dd-MMM-yyyy").format(start_date!),
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
                            Text(DateFormat("dd-MMM-yyyy").format(end_date!),
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
                    Text('Tournament Prize:',
                        style: TextStyle(
                          // color: AppTheme.secondaryYellowColor,
                          fontSize: 14,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w400,
                        )),
                    Text(widget.tournament['tournamentPrize'] ?? "N/A",
                        style: TextStyle(
                          // color: AppTheme.secondaryYellowColor,
                          fontSize: 16,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                        )),
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
                        Text("₹${widget.tournament['fees']}",
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
                        Text(widget.tournament['tournamentLimit'].toString(),
                            style: TextStyle(
                              // color: AppTheme.secondaryYellowColor,
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.secondaryYellowColor.withOpacity(0.8),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/dicsount.png",
                              height: 30,
                              width: 30,
                            ),
                            const SizedBox(width: 10),
                            Text('Coupon Special 100% Discount Applied',
                                style: TextStyle(
                                  // color: AppTheme.secondaryYellowColor,
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                )),
                            const Spacer(),
                            // const Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () async {
                    //     final res = await Get.to(
                    //             () => CouponView(
                    //           tournamentId: widget.tournament['tournamentName'],
                    //           amount: fees,
                    //         ),
                    //         fullscreenDialog: true);
                    //     if (res != null) {
                    //       setState(() {
                    //         // couponCode = res['code'];
                    //         // discount = res['discount'];
                    //       });
                    //     }
                    //   },
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       border: Border.all(
                    //         color:
                    //         AppTheme.secondaryYellowColor.withOpacity(0.8),
                    //         width: 2,
                    //       ),
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(12.0),
                    //       child: Row(
                    //         children: [
                    //           Image.asset(
                    //             "assets/images/dicsount.png",
                    //             height: 30,
                    //             width: 30,
                    //           ),
                    //           const SizedBox(width: 12),
                    //           Text('Apply for Promo code',
                    //               style: TextStyle(
                    //                 // color: AppTheme.secondaryYellowColor,
                    //                 fontSize: 14,
                    //                 color: Colors.grey.shade600,
                    //                 fontWeight: FontWeight.w500,
                    //               )),
                    //           const Spacer(),
                    //           const Icon(Icons.arrow_forward_ios)
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                    //         Text('Discount:',
                    //             style: TextStyle(
                    //               // color: AppTheme.secondaryYellowColor,
                    //               fontSize: 14,
                    //               color: Colors.grey.shade800,
                    //               fontWeight: FontWeight.w400,
                    //             )),
                    //         const SizedBox(height: 5),
                    //         if (couponCode != null)
                    //           Chip(
                    //             label: Text(
                    //               'Promocode: $couponCode',
                    //               style: const TextStyle(fontSize: 12),
                    //             ),
                    //             side: BorderSide(
                    //                 style: BorderStyle.solid,
                    //                 color: Colors.red.shade400),
                    //           )
                    //       ],
                    //     ),
                    //     const Spacer(),
                    //     Text('- ₹$discount',
                    //         style: TextStyle(
                    //           // color: AppTheme.secondaryYellowColor,
                    //           fontSize: 16,
                    //           color: Colors.grey.shade800,
                    //           fontWeight: FontWeight.w600,
                    //         )),
                    //   ],
                    // ),
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isCouponVisible = !_isCouponVisible;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'Discount:',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade800,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Icon(
                                        _isCouponVisible
                                            ? Icons.arrow_drop_up_outlined
                                            : Icons.arrow_drop_down,
                                        color: Colors.grey.shade600,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text('- ₹$discount',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w600,
                                )),
                          ],
                        ),
                        if (_isCouponVisible)
                          Chip(
                            label: const Text(
                              'Code: Special 100% Discount',
                              style: TextStyle(fontSize: 12),
                            ),
                            backgroundColor: Colors.red.shade50,
                            side: BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.red.shade400,
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            avatar: Icon(
                              Icons.local_offer,
                              color: Colors.red.shade600,
                              size: 16,
                            ),
                          ),
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
                    // Container(
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //     color: AppTheme.primaryColor,
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   child: TextButton(
                    //     onPressed: () {
                    //       startPayment();
                    //     },
                    //     child: const Text('Proceed to Payment',
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.w600,
                    //         )),
                    //   ),
                    // ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (connectionController.isConnected.value) {
                            final response =
                                controller.createTournament(widget.tournament);
                            successSnackBar('Tournament Create Successfully')
                                .then(
                              (value) => Get.offAll(() => const HomeScreen(),
                                  predicate: (route) =>
                                      route.name == '/HomeScreen'),
                            );
                          } else {
                            errorSnackBar(
                                'No Internet Connection. Please try again later.');
                          }
                        },
                        child: const Text('Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //     color: AppTheme.primaryColor,
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   child: TextButton(
                    //     onPressed: () {
                    //
                    //
                    //       startPayment();
                    //     },
                    //     child: const Text('Proceed to Payment',
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.w600,
                    //         )),
                    //   ),
                    // ),
                    const SizedBox(height: 22),
                    const CancellationPolicyWidget(
                        content:
                            'The tournament fee is non-refundable. In case of any issue, kindly contact Gully Support.')
                  ],
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
  final String content;
  const CancellationPolicyWidget({super.key, required this.content});

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
            Text(content,
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
