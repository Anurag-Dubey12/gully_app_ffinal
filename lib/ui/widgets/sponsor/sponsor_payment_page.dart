import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/banner_promotion_controller.dart';
import 'package:gully_app/ui/screens/payment_page.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../data/controller/auth_controller.dart';
import '../../../data/controller/tournament_controller.dart';
import '../../../data/model/package_model.dart';
import '../../../data/model/tournament_model.dart';
import '../../../utils/FallbackImageProvider.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/image_picker_helper.dart';
import '../../../utils/utils.dart';
import '../../screens/home_screen.dart';
import '../../theme/theme.dart';
import '../gradient_builder.dart';

class SponsorPaymentPage extends StatefulWidget {
  final TournamentModel tournament;
  final Package? package;

  const SponsorPaymentPage(
      {Key? key, required this.tournament, required this.package})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => SponsorPaymentPageState();
}

class SponsorPaymentPageState extends State<SponsorPaymentPage> {
  final _razorpay = Razorpay();
  double discount = 0;
  String? couponCode;

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final controller = Get.find<TournamentController>();
    Map<String, dynamic> sponsor = {
      "tournamentId":widget.tournament.id,
      "SponsorshipPackageId":widget.package?.id
    };
    final res=await controller.setSponsor(sponsor);
    if(res!=null){
      successSnackBar(
        'Congratulations !!!\nYour transaction has been successful. Your Can Now Add Your Sponsor Details',
        title: "Payment Successful",
      ).then(
            (value) => Get.offAll(() => const HomeScreen(),
            predicate: (route) => route.name == '/HomeScreen'),
      );
    }
    logger.f('Payment Success');
  }

  _handlePaymentError(PaymentFailureResponse response) async {
    logger.f('Payment Error ${response.message.toString()}');
    errorSnackBar('Your transaction has failed. Please try again!',
        title: "Payment Failed!");
  }

  _handleExternalWallet(ExternalWalletResponse response) {
    logger.f('External Wallet');
    errorSnackBar('External Wallet');
  }

  void startPayment() async {
    final authController = Get.find<AuthController>();
    var options = {
      // 'key': 'rzp_live_6sW7limWXGaS3k',
      'key': 'rzp_test_QMUxKSQyzcywjc',//my test key
      'amount': widget.package!.price * 100,
      'name': 'Gully Team',
      'description': 'Advertisement Fee',
      'prefill': {
        'contact': authController.state?.phoneNumber,
        'email': authController.state?.email,
      }
    };
    _razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    double gstAmount = (widget.package?.price ?? 0) * 0.18;
    return GradientBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppTheme.primaryColor,
          title: const Text('Review banner',
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
                    const Text(
                      'Tournament Details',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: widget.tournament.coverPhoto != null
                          ? Image.network(
                        toImageUrl(widget.tournament.coverPhoto!),
                        fit: BoxFit.contain,
                        // errorBuilder:  (BuildContext context, Object exception, StackTrace? stackTrace){
                        //   return Stack(
                        //     children: [
                        //     Image.asset(
                        //     'assets/images/logo.png',
                        //     fit: BoxFit.cover,
                        //   ),
                        //       Positioned(
                        //
                        //         child: Container(
                        //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        //           decoration: BoxDecoration(
                        //             color: Colors.black.withOpacity(0.5),
                        //             borderRadius: BorderRadius.circular(8),
                        //           ),
                        //           child: const Text(
                        //             "Unable To Get Tournament Cover Image",
                        //             style: TextStyle(
                        //               color: Colors.white,
                        //               fontSize: 16,
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     ],
                        //   );
                        // },
                      )
                          : Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    packageDetails(
                        "Tournament Name", widget.tournament.tournamentName),
                    packageDetails(
                        "Tournament Start Date",
                        DateFormat("dd-MMM-yyyy")
                            .format(widget.tournament.tournamentStartDateTime)),
                    packageDetails(
                        "Tournament End Date",
                        DateFormat("dd-MMM-yyyy")
                            .format(widget.tournament.tournamentEndDateTime)),
                    const SizedBox(height: 22),
                    const Text(
                      'Sponsor Package  Details:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    packageDetails(
                        "Package Name", widget.package?.name),
                    packageDetails(
                        "Total Media Allowed", "${widget.package?.maxMedia}"),
                    packageDetails(
                        "Video Allowed", "${widget.package?.maxVideos}"),
                    packageDetails(
                        "Package Price", "${widget.package?.price}"),
                    const SizedBox(height: 15),
                    Text('Payment Summary',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text('Total Amount:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w400,
                            )),
                        const Spacer(),
                        Text(
                          '₹${(widget.package?.price ?? 0 / 1.18) - gstAmount}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('GST (18%):',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w400,
                            )),
                        const Spacer(),
                        Text(
                            '₹$gstAmount',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Divider(
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        Text('Final Amount:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w400,
                            )),
                        const Spacer(),
                        Text('₹${widget.package?.price ?? 0 - discount}',
                            style: TextStyle(
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
                    const CancellationPolicyWidget(
                      content:
                          'The Banner fee is non-refundable. In case of any issue, kindly contact Gully Support.',
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget packageDetails(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value ?? '',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
