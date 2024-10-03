import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/ui/screens/shop/my_shop.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../data/controller/auth_controller.dart';
import '../../utils/app_logger.dart';
import '../../utils/utils.dart';
import '../theme/theme.dart';
import '../widgets/gradient_builder.dart';
import 'coupon_view.dart';
import 'home_screen.dart';
import 'payment_page.dart';

class ShopPaymentPage extends StatefulWidget {
  final shop_model? shopData;
  const ShopPaymentPage({super.key, this.shopData});

  @override
  State<StatefulWidget> createState() => PaymentPage();
}

class PaymentPage extends State<ShopPaymentPage> {
  final _razorpay = Razorpay();
  double fees = 1500;
  String? couponCode;
  double discount = 0;

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    logger.f('Payment Success');
    successSnackBar(
      'Congratulations! Your transaction has been successful. Your Shop is now active!',
      title: "Payment Successful",
    ).then(
      (value) => Get.offAll(() => const MyShop(),
          predicate: (route) => route.name == '/ShopScreen'),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    logger.f('Payment Error ${response.message.toString()}');
    errorSnackBar('Your transaction has failed. Please try again!',
        title: "Payment Failed!");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    logger.f('External Wallet');
    errorSnackBar('External Wallet');
  }

  void startPayment() async {
    final authController = Get.find<AuthController>();
    var options = {
      'key': 'rzp_live_6sW7limWXGaS3k',
      'amount': fees * 100,
      'name': 'Gully Team',
      'description': 'Service Fee',
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
        title: const Text('Review Banner',
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
                    if (widget.shopData!.shopLogo!.isNotEmpty)
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: FileImage(
                                File(widget.shopData!.shopLogo ?? '')),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Text('Shop Name:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w400,
                            )),
                        const Spacer(),
                        Text(widget.shopData!.shopName ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text('Shop Number:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w400,
                            )),
                        const Spacer(),
                        Text(widget.shopData!.shopNumber ?? 'Not Added',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text('Shop Email:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w400,
                            )),
                        const Spacer(),
                        Text(widget.shopData!.shopEmail ?? 'Not Added',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Gst Number:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w400,
                            )),
                        const Spacer(),
                        Text(widget.shopData!.gstNumber ?? 'Not Added',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    //       Row(
                    //         children: [
                    //           Expanded(
                    //             flex: 2,
                    //             child: Text(
                    //               'Shop Business Hours',
                    //               style: TextStyle(
                    //                 fontSize: 14,
                    //                 color: Colors.grey.shade800,
                    //                 fontWeight: FontWeight.w400,
                    //               ),
                    //             ),
                    //           ),
                    //           if (widget.shopData!.businessHours != null && widget.shopData!.businessHours!.isNotEmpty)
                    //             ...widget.shopData!.businessHours!.entries.map((entry) {
                    //               final day = entry.key;
                    //               final hours = entry.value;
                    //               final hoursString = hours.isOpen
                    //                   ? '${hours.openTime ?? '00:00'} - ${hours.closeTime ?? '00:00'}'
                    //                   : 'Closed';
                    //               return BusinessHoursSummary(
                    //                 day: day,
                    //                 hours: hoursString,
                    //               );
                    //             }).toList(),
                    //           if (widget.shopData!.businessHours == null || widget.shopData!.businessHours!.isEmpty)
                    //             Text('No business hours set'),
                    GestureDetector(
                      onTap: () async {
                        final res = await Get.to(
                            () => CouponView(
                                  tournamentId: '',
                                  amount: fees,
                                ),
                            fullscreenDialog: true);
                        if (res != null) {
                          setState(() {
                            // couponCode = res['code'];
                            // discount = res['discount'];
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                AppTheme.secondaryYellowColor.withOpacity(0.8),
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
                              const SizedBox(width: 12),
                              Text('Apply for Promo code',
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
                        Text('₹${500 / 1.18}',
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
                        Text('₹${100 - (fees / 1.18)}',
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
                                  'Promo code: $couponCode',
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
                  ]),
            ),
          ),
        ),
      ),
    ));
  }
}
