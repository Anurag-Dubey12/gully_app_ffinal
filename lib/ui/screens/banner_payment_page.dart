import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/banner_promotion_controller.dart';
import 'package:gully_app/ui/screens/payment_page.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../data/controller/auth_controller.dart';
import '../../data/controller/tournament_controller.dart';
import '../../utils/app_logger.dart';
import '../../utils/utils.dart';
import '../theme/theme.dart';
import '../widgets/gradient_builder.dart';
import 'home_screen.dart';

class BannerPaymentPage extends StatefulWidget {
  final Map<String, dynamic> banner;
  final Map<String, dynamic> SelectedPakcage;
  final String base64;
  const BannerPaymentPage(
      {Key? key,
      required this.banner,
      required this.SelectedPakcage,
      required this.base64})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => BannerPaymentPageState();
}

class BannerPaymentPageState extends State<BannerPaymentPage> {
  double fees = 0;
  final _razorpay = Razorpay();
  String? couponCode;
  double discount = 0;
  DateTime? start_date;
  DateTime? end_date;
  String bannerId='';
  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    start_date = DateTime.parse(widget.banner['startDate']);
    end_date = DateTime.parse(widget.banner['endDate']);
    fees = double.tryParse(widget.SelectedPakcage['package']['price']
            .toString()
            .split('.')[0]) ??
        0.0;

    logger.d("Start Date${widget.banner['startDate']}");
    logger.d("endDate${widget.banner['endDate']}");
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final controller = Get.find<PromotionController>();
    final ordercontroller = Get.find<TournamentController>();
    Map<String, dynamic> bannerdata = {
      "banner_title": widget.banner['banner_title'],
      "banner_image": widget.base64,
      "startDate": widget.banner['startDate'],
      "endDate": widget.banner['endDate'],
      "bannerlocationaddress": widget.banner['bannerlocationaddress'],
      "longitude": widget.banner['longitude'],
      "latitude": widget.banner['latitude'],
      "packageId": widget.banner['packageId'],
    };
    final res = await controller.createBanner(bannerdata);
    logger.d("The Banner Id:${res.id}");
    if (res != null) {
      bannerId=res.id;
      await ordercontroller.createbannerOrder(
        discountAmount: fees,
        bannerId: res.id,
        totalAmount: fees,
        coupon: couponCode,
        status: "Successful",
      );
      successSnackBar(
        'Congratulations !!!\nYour transaction has been successful. Your banner Details will be updated sortly!',
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

    final ordercontroller = Get.find<TournamentController>();
    await ordercontroller.createbannerOrder(
      discountAmount: fees,
      bannerId: bannerId,
      totalAmount: fees,
      coupon: couponCode,
      status: "Failed",
    );
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
      // 'key': 'rzp_test_QMUxKSQyzcywjc', //my test key
      'key': 'rzp_live_6sW7limWXGaS3k',
      'amount': fees * 100,
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
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: FileImage(File(widget.banner['banner_image'])),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Start Date:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                )),
                            Text(DateFormat("dd-MMM-yyyy").format(start_date!),
                                style: TextStyle(
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
                                  fontSize: 14,
                                  color: Colors.grey,
                                )),
                            Text(DateFormat("dd-MMM-yyyy").format(end_date!),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Package Details:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    packageDetails(
                      'Package Name:',
                      widget.SelectedPakcage['package']['name'],
                    ),
                    packageDetails('Package Price:',
                        '₹${widget.SelectedPakcage['package']['price']}/-'),
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
                          '₹${(fees / 1.18).toStringAsFixed(0)}',
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
                        Text('GST(18%):',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w400,
                            )),
                        const Spacer(),
                        Text('₹${(fees - (fees / 1.18)).toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                    //         Text('Discount:',
                    //             style: TextStyle(
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
                    //           fontSize: 16,
                    //           color: Colors.grey.shade800,
                    //           fontWeight: FontWeight.w600,
                    //         )),
                    //   ],
                    // ),
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
                        Text('₹${fees - discount}',
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
