import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/custom_drop_down_field.dart';
import '../widgets/gradient_builder.dart';

class PurchaseAdsScreen extends StatefulWidget {
  const PurchaseAdsScreen({super.key});

  @override
  State<StatefulWidget> createState() => AdsScreen();
}

class AdsScreen extends State<PurchaseAdsScreen> {

  String AdsType = ' ';
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
        child: GradientBuilder(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  'Purchase Ads',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const BackButton(
                  color: Colors.white,
                )),
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  DropDownWidget(
                    title: "Purchase Ads",
                    onSelect: (e) {
                      setState(() {
                        AdsType = e;
                      });
                      // Get.back();
                      Get.close();
                    },
                    selectedValue: AdsType.toUpperCase(),
                    items: const [
                      'turf',
                      'corporate',
                      'series',
                      'open'
                    ], isAds: true,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
