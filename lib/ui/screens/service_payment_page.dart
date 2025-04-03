import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../data/controller/auth_controller.dart';
import '../../data/model/service_model.dart';
import '../../utils/app_logger.dart';
import '../../utils/utils.dart';
import '../theme/theme.dart';
import '../widgets/gradient_builder.dart';
import '../widgets/advertisement/advertisement_summary.dart';
import '../widgets/service/ServiceOfferItem.dart';
import 'home_screen.dart';

class ServicePaymentPage extends StatefulWidget {
  final ServiceModel service;

  const ServicePaymentPage({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ServicePaymentPageState();
}

class ServicePaymentPageState extends State<ServicePaymentPage> {
  final _razorpay = Razorpay();
  double fees = 0;
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
      'Congratulations! Your transaction has been successful. Your Service is now active!',
      title: "Payment Successful",
    ).then(
      (value) => Get.offAll(() => const HomeScreen(),
          predicate: (route) => route.name == '/HomeScreen'),
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
    final AuthController authController = Get.find<AuthController>();
    return GradientBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppTheme.primaryColor,
          title: const Text('Review Service',
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
                    const SizedBox(height: 12),
                    // SizedBox(
                    //   width: Get.width,
                    //   height: 200,
                    //   child: Image.network(toImageUrl(authController.state?.profilePhoto ??
                    //       ""),fit: BoxFit.cover,)),
                    // Center(
                    //   child: Text(
                    //     widget.service.name,
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       color: Colors.grey.shade800,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),
                    const Center(
                      child: Text(
                        'Service Details',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    AdvertisementSummary(
                      label: 'Name',
                      value: widget.service.name ?? '',
                    ),
                    AdvertisementSummary(
                      label: 'Contact Number',
                      value: widget.service.phoneNumber ?? '',
                    ),
                    AdvertisementSummary(
                      label: 'Year of Experience',
                      value: widget.service.experience.toString(),
                    ),
                    AdvertisementSummary(
                      label: 'Location',
                      value: widget.service.address ?? '',
                    ),
                    AdvertisementSummary(
                      label: 'Charges',
                      value: widget.service.fees.toString(),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        'Package Details',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // AdvertisementSummary(
                    //   label: 'Package Name',
                    //   value: widget.service.servicePackage.name,
                    // ),
                    // AdvertisementSummary(
                    //   label: 'Duration',
                    //   value: widget.service.servicePackage.duration,
                    // ),
                    // AdvertisementSummary(
                    //   label: 'End Date',
                    //   value: widget.service.servicePackage.endDate,
                    // ),
                    const Center(
                      child: Text(
                        'Service Offering',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(widget.service.category),
                    Text(
                      'Payment Summary',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'Total Amount:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '₹${fees / 1.18}',
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
                        Text(
                          'GST (18%):',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '₹${fees - (fees / 1.18)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Discount:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '- ₹$discount',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey),
                    Row(
                      children: [
                        Text(
                          'Final Amount:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '₹${fees - discount}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
                        onPressed: startPayment,
                        child: const Text(
                          'Proceed to Payment',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
