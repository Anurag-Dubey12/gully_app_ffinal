import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/contact_us_screen.dart';

import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';

class OthersLookingForScreen extends StatelessWidget {
  const OthersLookingForScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 245, 247, 255),
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
                        color: AppTheme.secondaryYellowColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 70))
                  ],
                ),
                width: double.infinity,
              ),
            ),
            Positioned(
                child: SizedBox(
              width: Get.width,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 30, top: 30),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: BackButton(
                          color: Colors.white,
                        )),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Looking For',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.04),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: const Color.fromARGB(132, 61, 60, 58)
                                .withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 7))
                      ],
                    ),
                    height: 54,
                    width: Get.width / 1.2,
                    child: TextField(
                      onTap: () {},
                      decoration: InputDecoration(
                        isDense: true,

                        suffixIcon: const Icon(
                          CupertinoIcons.search,
                          color: AppTheme.secondaryYellowColor,
                          size: 28,
                        ),
                        labelText: 'Search..',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        // isCollapsed: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('What others are looking for?',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 20),
                        _LookingCard(),
                        SizedBox(height: 10),
                        _LookingCard(),
                        SizedBox(height: 10),
                        _LookingCard(),
                      ],
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class _LookingCard extends StatelessWidget {
  const _LookingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Bhavesh Pant is looking for a team to join as a batsman in Mumbai'),
                  Text('2 hours ago',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.secondaryYellowColor,
                    child: Icon(Icons.contact_page),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
