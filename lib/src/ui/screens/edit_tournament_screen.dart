import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/notification_screen.dart';
import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';
import '../widgets/custom_drop_down_field.dart';
import '../widgets/primary_button.dart';

class EditTournamentScreen extends StatefulWidget {
  const EditTournamentScreen({super.key});

  @override
  State<EditTournamentScreen> createState() => _EditTournamentScreenState();
}

class _EditTournamentScreenState extends State<EditTournamentScreen> {
  String selectedValue = 'Tournament 1';
  String selectedValue2 = 'Tennis';
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
          bottomNavigationBar: Container(
            height: 90,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, -1))
            ]),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 35.0, vertical: 19),
                  child: PrimaryButton(
                    onTap: () {
                      Get.to(() => const NotificationScreen());
                    },
                    title: 'Submit',
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Stack(children: [
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
              top: 0,
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.07,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Edit Tournament',
                              style: Get.textTheme.headlineLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: Get.height * 0.04),
                          const _TopCard(),
                        ],
                      ),
                    ),
                    Container(
                      width: Get.width,
                      margin: const EdgeInsets.only(top: 20),
                      color: Colors.black26,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tournament Category',
                                style: Get.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            DropDownWidget(
                              title: 'Select Tournament Category',
                              onSelect: (e) {
                                setState(() {
                                  selectedValue = e;
                                });
                                Get.back();
                              },
                              selectedValue: selectedValue,
                              items: const [
                                'Tournament 1',
                                'Tournament 2',
                                'Tournament 3'
                              ],
                            ),
                            Text('Ball Type',
                                style: Get.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            DropDownWidget(
                              title: 'Select Ball Type',
                              onSelect: (e) {
                                setState(() {
                                  selectedValue2 = e;
                                });
                                Get.back();
                              },
                              selectedValue: selectedValue2,
                              items: const [
                                'Leather',
                                'Tennis',
                                'Rubber',
                              ],
                            ),
                            Text('Organizer Name',
                                style: Get.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            DropDownWidget(
                              title: 'Select Ball Type',
                              onSelect: (e) {
                                setState(() {
                                  selectedValue = e;
                                });
                                Get.back();
                              },
                              selectedValue: selectedValue,
                              items: const [
                                'Leather',
                                'Tennis',
                                'Rubber',
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
        ));
  }
}

class _TopCard extends StatelessWidget {
  const _TopCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 1))
          ],
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.width / 4.5, vertical: 13),
                  child: Text(
                    'Bhushan Cricket',
                    style: Get.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const _SelectFromToCard()
          ],
        ),
      ),
    );
  }
}

class _SelectFromToCard extends StatelessWidget {
  const _SelectFromToCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Text('From'),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)));
                    },
                    child: Container(
                      width: 50,
                      height: 23,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey[200]),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.calendar_month,
                    size: 18,
                    color: AppTheme.secondaryYellowColor,
                  )
                ],
              )
            ],
          ),
          const Spacer(),
          const Spacer(),
          GestureDetector(
            onTap: () {
              showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    'To',
                    style: Get.textTheme.labelLarge,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 23,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey[200]),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Icon(
                      Icons.calendar_month,
                      size: 18,
                      color: AppTheme.secondaryYellowColor,
                    )
                  ],
                )
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
