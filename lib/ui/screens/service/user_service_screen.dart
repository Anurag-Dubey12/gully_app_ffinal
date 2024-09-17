import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class MyServiceScreen extends StatefulWidget {
  const MyServiceScreen({super.key});
  @override
  State<StatefulWidget> createState() => MyService();
}

class MyService extends State<MyServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage(
              'assets/images/sports_icon.png',
            ),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
          title: const Text(
            'My Service',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
