import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NoInternetScreen extends StatefulWidget {

  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  bool _isChecking = false;

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  void _retryConnection() async {
    setState(() {
      _isChecking = true;
    });

    bool isConnected = await _checkInternetConnection();

    setState(() {
      _isChecking = false;
    });

    if (isConnected) {
      Get.close();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Still no internet connection. Please try again."),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/wifi.svg',
              width: 300,
            ),
            const SizedBox(height: 20),
            const Text('No Internet Connection'),
            const SizedBox(height: 10),
            const Text('Please check your internet connection and try again'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isChecking ? null : _retryConnection,
              child: _isChecking
                  ? const CircularProgressIndicator()
                  : const Text('Retry', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}