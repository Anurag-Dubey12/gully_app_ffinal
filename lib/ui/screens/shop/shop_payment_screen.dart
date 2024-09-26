
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../data/controller/auth_controller.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/utils.dart';
import '../../theme/theme.dart';
import '../../widgets/gradient_builder.dart';
import '../home_screen.dart';
import '../payment_page.dart';

class ShopPaymentPage extends StatefulWidget{
  final Map<String, dynamic> shopData;

  const ShopPaymentPage({Key? key, required this.shopData}) : super(key: key);

  @override
  State<StatefulWidget> createState()=>Payment();
}
class Payment extends State<ShopPaymentPage>{
  @override
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
