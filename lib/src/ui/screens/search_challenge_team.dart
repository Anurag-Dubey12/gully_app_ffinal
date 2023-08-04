import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/contact_us_screen.dart';

import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';

class SearchChallengeTeam extends StatelessWidget {
  const SearchChallengeTeam({super.key});

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
                  Padding(
                    padding: EdgeInsets.only(left: 30, top: 30),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: BackButton(
                          color: Colors.white,
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Challenge team',
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
                            color: Color.fromARGB(132, 61, 60, 58)
                                .withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 7))
                      ],
                    ),
                    height: 54,
                    width: Get.width / 1.2,
                    child: TextField(
                      onTap: () {
                        Get.to(() => ContactUsScreen());
                      },
                      decoration: InputDecoration(
                        isDense: true,

                        suffixIcon: Icon(
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
