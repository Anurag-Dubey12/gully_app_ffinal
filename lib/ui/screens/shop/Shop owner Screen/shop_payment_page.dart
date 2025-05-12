import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/config/app_constants.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/controller/shop_controller.dart';
import 'package:gully_app/data/model/package_model.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/ui/screens/home_screen.dart';
import 'package:gully_app/ui/screens/payment_page.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/date_time_helpers.dart';
import 'package:gully_app/utils/image_picker_helper.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ShopPaymentPage extends StatefulWidget {
  final ShopModel shop;
  final Package selectedpackage;
  final bool isAdditional;
  const ShopPaymentPage(
      {Key? key,
      required this.shop,
      required this.selectedpackage,
      this.isAdditional = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ShopPaymentPageState();
}

class ShopPaymentPageState extends State<ShopPaymentPage> {
  double fees = 0;
  final _razorpay = Razorpay();
  String? couponCode;
  double discount = 0;
  String startDate = '';
  String enddate = '';
  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    fees = double.tryParse(
            widget.selectedpackage.price.toString().split('.')[0]) ??
        0.0;
    calculatePackageEndDate(widget.selectedpackage.duration ?? '');
    startDate = formatDateTime('dd/MM/yyyy', DateTime.now());
  }

  String calculatePackageEndDate(String selectedMonth) {
    final now = DateTime.now();
    final durationInMonths = int.tryParse(selectedMonth) ?? 0;

    final endDate = DateTime(
      now.year,
      now.month + durationInMonths,
      now.day,
      now.hour,
      now.minute,
      now.second,
      now.millisecond,
      now.microsecond,
    );
    enddate = formatDateTime('dd/MM/yyyy', endDate);
    return endDate.toIso8601String();
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final controller = Get.find<ShopController>();

    Map<String, dynamic> subscriptiondata = {
      "shopId": widget.shop.id,
      "packageId": widget.selectedpackage.id,
      "packageStartDate": DateTime.now().toIso8601String(),
      "packageEndDate":
          calculatePackageEndDate(widget.selectedpackage.duration ?? ''),
    };
    if (widget.isAdditional) {
      bool isOK = await controller.addAddtionalPackage(subscriptiondata);
      if (isOK) {
        successSnackBar(
          AppConstants.additionalPackagePaymentSuccess,
          title: "Payment Successful",
        ).then(
          (value) => Get.offAll(() => const HomeScreen(),
              predicate: (route) => route.name == '/HomeScreen'),
        );
        // successSnackBar("The Subscription added successfully");
      }
    } else {
      final shopData =
          await controller.updateSubscriptionStatus(subscriptiondata);
      if (shopData != null) {
        successSnackBar(
          AppConstants.shopPaymentSuccessful,
          title: "Payment Successful",
        ).then(
          (value) => Get.offAll(() => const HomeScreen(),
              predicate: (route) => route.name == '/HomeScreen'),
        );
        // successSnackBar("The Subscription added successfully");
      }
    }
    logger.f('Payment Success');
  }

  _handlePaymentError(PaymentFailureResponse response) async {
    logger.f('Payment Error ${response.message.toString()}');
  }

  _handleExternalWallet(ExternalWalletResponse response) {
    logger.f('External Wallet');
    errorSnackBar('External Wallet');
  }

  void startPayment() async {
    final authController = Get.find<AuthController>();
    var options = {
      'key': 'rzp_test_QMUxKSQyzcywjc', //my test key
      // 'key': 'rzp_live_6sW7limWXGaS3k',
      'amount': fees * 100,
      'name': 'Gully Team',
      'description': 'Shop Product Fee',
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
          title: const Text('Review Shop',
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
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 150,
                        viewportFraction: 1.0,
                        autoPlay: true,
                        enlargeCenterPage: false,
                        autoPlayInterval: const Duration(seconds: 5),
                      ),
                      items: widget.shop.shopImage.map((imageUrl) {
                        return GestureDetector(
                          onTap: () => imageViewer(context, imageUrl, true),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(toImageUrl(imageUrl)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Shop Name: ",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.shop.shopName,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    screenInfoinColumn(
                        "Shop Address:", widget.shop.shopAddress),
                    screenInfoinRow("Shop Contacts", widget.shop.shopContact),
                    screenInfoinRow("Shop Email", widget.shop.shopEmail),
                    Divider(
                      color: Colors.grey.shade300,
                    ),
                    Text(
                      "Selected Package Details",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    screenInfoinRow(
                        "Package Name", widget.selectedpackage.name),
                    screenInfoinRow("Package Price",
                        widget.selectedpackage.price.toString()),
                    screenInfoinRow("Total Image Allowed",
                        widget.selectedpackage.maxMedia.toString()),
                    screenInfoinRow("Package Start Date", startDate),
                    screenInfoinRow("Package End Date", enddate),
                    Divider(
                      color: Colors.grey.shade300,
                    ),
                    Text('Payment Summary',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 3),
                    paymentSummaryRow("Amount (Excl. GST):",
                        '₹${(fees / 1.18).toStringAsFixed(2)}'),
                    paymentSummaryRow("GST (18%):",
                        '₹${(fees - (fees / 1.18)).toStringAsFixed(2)}'),
                    Divider(
                      color: Colors.grey.shade300,
                    ),
                    paymentSummaryRow("Total Amount:", '₹${fees - discount}',
                        isTotal: true),
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
                        content: AppConstants.shopfeescancellation)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget screenInfoinColumn(String title, String? value,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value ?? '',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget screenInfoinRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value ?? '',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 15 : 14,
              color: Colors.grey.shade800,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w400,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              color: Colors.grey.shade800,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
