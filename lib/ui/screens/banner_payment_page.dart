import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/screens/payment_page.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../data/controller/auth_controller.dart';
import '../../data/model/promote_banner_model.dart';
import '../../utils/app_logger.dart';
import '../../utils/utils.dart';
import '../theme/theme.dart';
import '../widgets/advertisement/advertisement_summary.dart';
import '../widgets/gradient_builder.dart';
import 'home_screen.dart';

class BannerPaymentPage extends StatefulWidget {
  final PromoteBannerModel ads;
  final List<Map<String, dynamic>> screens;
  const BannerPaymentPage({Key? key, required this.ads, required this.screens}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BannerPaymentPageState();
}

class BannerPaymentPageState extends State<BannerPaymentPage> {
  double fees = 0;
  final _razorpay = Razorpay();
  String? couponCode;
  double discount = 0;

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    fees = widget.ads.totalAmount;
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) async {
    logger.f('Payment Success');
    successSnackBar(
      'Congratulations !!!\nYour transaction has been successful. Your Banner is Live!',
      title: "Payment Successful",
    ).then(
          (value) => Get.offAll(() => const HomeScreen(), predicate: (route) => route.name == '/HomeScreen'),
    );
  }

  _handlePaymentError(PaymentFailureResponse response) {
    logger.f('Payment Error ${response.message.toString()}');
    errorSnackBar('Your transaction has failed. Please try again!', title: "Payment Failed!");
  }

  _handleExternalWallet(ExternalWalletResponse response) {
    logger.f('External Wallet');
    errorSnackBar('External Wallet');
  }
  void startPayment() async {
    final authController = Get.find<AuthController>();
    var options = {
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
          title: const Text('Review Banner', style: TextStyle(color: Colors.white, fontSize: 18)),
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
                    // Center(
                    //   child: Text(widget.ads.id,
                    //       style: const TextStyle(
                    //           color: AppTheme.secondaryYellowColor,
                    //           fontSize: 18,
                    //           fontWeight: FontWeight.bold)),
                    // ),
                    if (widget.ads.imageUrl.isNotEmpty)
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: FileImage(File(widget.ads.imageUrl)),
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
                            Text(
                                DateFormat("dd-MMM-yyyy").format(
                                    widget.ads.startDate),
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
                            Text(
                                DateFormat("dd-MMM-yyyy").format(
                                    widget.ads.endDate),
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
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Banner Display on',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Amount',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.ads.adPlacement.isNotEmpty)
                      ...widget.ads.adPlacement.map((adType) {
                        final screenData = widget.screens.firstWhere((s) => s['name'] == adType);
                        final pricePerDay = screenData['price'] as int;
                        final duration = widget.ads.endDate.difference(widget.ads.startDate).inDays + 1;
                        final amount = pricePerDay * duration;
                        return AdvertisementSummary(
                          label: adType,
                          value: '₹${amount.toStringAsFixed(2)}',
                        );
                      }).toList(),
                    const SizedBox(height: 15),
                    // Row(
                    //   children: [
                    //     Text('Total Amount:',
                    //         style: TextStyle(
                    //           fontSize: 14,
                    //           color: Colors.grey.shade800,
                    //           fontWeight: FontWeight.w400,
                    //         )),
                    //     const Spacer(),
                    //     Text("₹${widget.ads.totalAmount}",
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //           color: Colors.grey.shade800,
                    //           fontWeight: FontWeight.w600,
                    //         )),
                    //   ],
                    // ),
                    // const SizedBox(height: 22),
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
                        Text('₹${fees/1.18}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                            )),
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
                        Text('₹${fees-(fees/1.18)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Discount:',
                                style: TextStyle(
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
                                side: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.red.shade400),
                              )
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
                    const CancellationPolicyWidget()
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
