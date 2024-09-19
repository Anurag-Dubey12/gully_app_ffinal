import 'package:flutter/material.dart';
import 'package:gully_app/ui/widgets/shop/vendor_details.dart';
import '../../theme/theme.dart';

class RegisterShop extends StatefulWidget {
  const RegisterShop({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShopState();
}

class _ShopState extends State<RegisterShop> {
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  int _currentPage = 0;
  double _progress = 0.0;

  // Form data
  Map<String, dynamic> formData = {};


  Widget _buildShopPages() {
    switch (_currentPage) {
      case 0:
        return VendorDetails(formKey: _formKeys[0], formData: formData);
      case 1:
      //   return ShopDetails(formKey: _formKeys[1], formData: formData);
      // case 2:
      //   return VerificationDetails(formKey: _formKeys[2], formData: formData);
      // case 3:
      //   return ProductDetails(formKey: _formKeys[3], formData: formData);
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
        backgroundColor: Colors.transparent,
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
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                ),
                SizedBox(height: 10),
                Text(
                  'Progress: ${(_progress * 100).toInt()}%',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildShopPages(),
                SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     if (_currentPage > 0)
                //       ElevatedButton(
                //         onPressed: _previousPage,
                //         child: Text('Previous'),
                //         style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
                //       ),
                //     if (_currentPage < _formKeys.length - 1)
                //       ElevatedButton(
                //         onPressed: _nextPage,
                //         child: Text('Next'),
                //         style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
                //       ),
                //     if (_currentPage == _formKeys.length - 1)
                //       ElevatedButton(
                //         onPressed: _submitForm,
                //         child: Text('Submit'),
                //         style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
                //       ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}