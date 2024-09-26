import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gully_app/ui/screens/shop/shop_payment_screen.dart';
import 'package:gully_app/ui/widgets/shop/social_media_link.dart';
import 'package:gully_app/ui/widgets/shop/vendor_details.dart';
import 'package:gully_app/utils/utils.dart';
import '../../../data/controller/shop_controller.dart';
import '../../../data/model/vendor_model.dart';
import '../../../utils/app_logger.dart';
import '../../theme/theme.dart';
import '../../widgets/shop/product_details.dart';
import '../../widgets/shop/shop_details.dart';

class RegisterShop extends StatefulWidget {
  const RegisterShop({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShopState();
}

class _ShopState extends State<RegisterShop>
    with SingleTickerProviderStateMixin {
  final ShopController shopController = Get.put(ShopController());

  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  int _currentPage = 0;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  vendor_model? _vendorData;

  Map<String, Map<String, dynamic>> formData = {
    'vendorDetails': {},
    'shopDetails': {},
    'socialMediaDetails': {},
  };

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _progressAnimation =
        Tween<double>(begin: 0, end: 0).animate(_progressController);
    shopController.resetAllData();
  }

  @override
  void dispose() {
    shopController.resetAllData();
    _progressController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    setState(() {
      double endValue = _currentPage / (_formKeys.length - 1);
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: endValue,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ));
      _progressController.forward(from: 0);
    });
  }

  bool _isDocumentImageSelected = false;
  bool _isShopImageSelected = false;

  void _nextPage() {
    if (_formKeys[_currentPage].currentState!.validate()) {
      _formKeys[_currentPage].currentState!.save();
      if (_currentPage == 0 && !_isDocumentImageSelected) {
        errorSnackBar('Please select an ID proof document');
        return;
      }
      if (_currentPage == 1 && !_isShopImageSelected) {
        errorSnackBar('Please select all required shop images');
        return;
      }
      if (_currentPage < _formKeys.length - 1) {
        setState(() {
          _currentPage++;
        });
        _updateProgress();
      }
    }
  }


  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _updateProgress();
    }
  }

  void _submitForm() {
    if (_formKeys.every((key) => key.currentState!.validate())) {
      _formKeys.forEach((key) => key.currentState!.save());
      logger.d('Form submitted');
      logger.d(formData);
      Get.to(() => ShopPaymentPage(
            shopData: formData,
          ));
    }
  }

  final List<String> pagename = [
    'Vendor Details',
    'Shop Details',
    'Social Media Details',
  ];

  Widget _buildShopPages() {
    switch (_currentPage) {
      case 0:
        return VendorDetails(
          formKey: _formKeys[0],
          onDocumentImageSelected: (isSelected) {
            setState(() {
              _isDocumentImageSelected = isSelected;
            });
          },
          onVendorDataChanged: (vendorData) {
            shopController.updateVendorDetails(vendorData);
            setState(() {
              formData['vendorDetails'] = vendorData.toJson();
            });
          },
        );
      case 1:
        return ShopDetails(
          formKey: _formKeys[1],
          formData: formData,
          onshopDocumentSelected: (isSelected) {
            setState(() {
              _isShopImageSelected = isSelected;
            });
          },
        );
      case 2:
        return SocialMedia(formKey: _formKeys[2], formData: formData);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/sports_icon.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black26,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
          title: const Text(
            'Register Shop',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: Text(
                        pagename[_currentPage],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, top: 10, right: 20),
                      child: AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return Text(
                            "${_currentPage + 1}/${pagename.length}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 8.0),
                  child: AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _progressAnimation.value,
                        borderRadius: BorderRadius.circular(20),
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryColor),
                        minHeight: 12,
                      );
                    },
                  ),
                ),
                _buildShopPages(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
          width: Get.width,
          child: _currentPage == 0
              ? _nextNavigationButton('Next', _nextPage)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage > 0)
                      _previousNavigationButton(_previousPage)
                    else
                      const SizedBox(width: 80),
                    if (_currentPage < _formKeys.length - 1)
                      _nextNavigationButton('Next', _nextPage)
                    else if (_currentPage == _formKeys.length - 1)
                      _nextNavigationButton('Submit', _submitForm)
                    else
                      const SizedBox(width: 80),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _previousNavigationButton(VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(
            color: AppTheme.primaryColor,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
            child:
                Icon(Icons.arrow_back_rounded, color: Colors.black, size: 30)),
      ),
    );
  }

  Widget _nextNavigationButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 250,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color(0xfc2745f6),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
