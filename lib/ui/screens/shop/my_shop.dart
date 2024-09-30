
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:gully_app/data/controller/shop_controller.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../theme/theme.dart';
import '../../widgets/arc_clipper.dart';

class MyShop extends GetView<ShopController>{
  const MyShop({super.key});

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
        body: Stack(
          children: [
            ClipPath(
              clipper: ArcClipper(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xff368EBF),
                      AppTheme.primaryColor,
                    ],
                    center: Alignment(-0.4, -0.8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.9),
                      blurRadius: 20,
                      spreadRadius: 20,
                      offset: const Offset(0, 90),
                    ),
                  ],
                ),
                width: double.infinity,
              ),
            ),
            Positioned(
              top: 0,
              child: SizedBox(
                width: Get.width,
                height: Get.height,
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Text(
                        "My Shop",
                        style: Get.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      leading: const BackButton(
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.07,
                      ),
                    child:_Card(
                        shop:shop_model()
                    ) ,

                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
class _Card extends StatefulWidget {
  final shop_model shop;

  const _Card({required this.shop});

  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(
          //   color: Colors.black
          // ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          // border: Border.all(
          //   color: Colors.black
          // ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.05,
            vertical: Get.height * 0.02,
          ),
          child: Row(
            children: [
              const Spacer(),
              Text(
                "Shop two",
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 19,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}