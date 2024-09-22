import 'package:flutter/material.dart';
import 'package:gully_app/ui/widgets/shop/vendor_details.dart';
import '../../../utils/app_logger.dart';
import '../../theme/theme.dart';
import '../../widgets/shop/shop_details.dart';

class RegisterShop extends StatefulWidget {
  const RegisterShop({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShopState();
}

class _ShopState extends State<RegisterShop> with SingleTickerProviderStateMixin {
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  int _currentPage = 0;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  // Form data
  Map<String, dynamic> formData = {};

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _progressAnimation = Tween<double>(begin: 0, end: 0).animate(_progressController);
  }

  @override
  void dispose() {
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

  void _nextPage() {
    if (_formKeys[_currentPage].currentState!.validate()) {
      _formKeys[_currentPage].currentState!.save();
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
    }
  }

  Widget _buildShopPages() {
    switch (_currentPage) {
      case 0:
        return VendorDetails(formKey: _formKeys[0], formData: formData);
      case 1:
        return ShopDetails(formKey: _formKeys[1], formData: formData);
      case 2:
      //   return VerificationDetails(formKey: _formKeys[2], formData: formData);
      case 3:
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
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return LinearProgressIndicator(
                              value: _progressAnimation.value,
                              borderRadius: BorderRadius.circular(20),
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                              minHeight: 10,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return Text(
                            "${(_progressAnimation.value * 100).toInt()}%",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                _buildShopPages(),
                const SizedBox(height: 20),
                _currentPage==0 ? Center(child: _NavigationButton('Next', _nextPage)):
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage > 0)
                      _NavigationButton('Previous', _previousPage)
                    else
                      const SizedBox(width: 90),
                    if (_currentPage < _formKeys.length - 1)
                      _NavigationButton('Next', _nextPage)
                    else if (_currentPage == _formKeys.length - 1)
                      _NavigationButton('Submit', _submitForm)
                    else
                      const SizedBox(width: 90),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _NavigationButton(String text, VoidCallback onTap) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 120,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
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
      ),
    );
  }
}