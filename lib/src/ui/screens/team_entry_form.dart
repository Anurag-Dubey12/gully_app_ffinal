import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/create_tournament_form_screen.dart';
import 'package:gully_app/src/ui/screens/select_location.dart';
import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';
import '../widgets/custom_drop_down_field.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class TeamEntryForm extends StatefulWidget {
  const TeamEntryForm({super.key});

  @override
  State<TeamEntryForm> createState() => _TeamEntryFormState();
}

class _TeamEntryFormState extends State<TeamEntryForm> {
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
                      Get.to(() => const SelectLocationScreen());
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
                height: Get.height,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 30),
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
                          Text('Entry Form',
                              style: Get.textTheme.headlineLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 29)),
                          SizedBox(height: Get.height * 0.08),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: Get.width,
                        // height: Get.height * 0.6,
                        margin: const EdgeInsets.only(top: 20),
                        color: Colors.black26,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, right: 18.0, top: 18.0, bottom: 0.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Team name',
                                    style: Get.textTheme.headlineMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black)),
                                DropDownWidget(
                                  title: 'Select Team Name',
                                  onSelect: (e) {
                                    setState(() {
                                      selectedValue = e;
                                    });
                                    Get.back();
                                  },
                                  selectedValue: selectedValue,
                                  items: const ['CSK', 'RCB', 'KKR'],
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Text('Address',
                                    style: Get.textTheme.headlineMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
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
                                    'Address',
                                    'Address',
                                    'Address',
                                  ],
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Text('Email Id',
                                    style: Get.textTheme.headlineMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black)),
                                const SizedBox(
                                  height: 8,
                                ),
                                const CustomTextField(
                                  filled: true,
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Text('Captian Contact Number',
                                    style: Get.textTheme.headlineMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black)),
                                const SizedBox(
                                  height: 8,
                                ),
                                const CustomTextField(
                                  filled: true,
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Text('Vice Captian Contact Number',
                                    style: Get.textTheme.headlineMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black)),
                                const SizedBox(
                                  height: 8,
                                ),
                                const CustomTextField(
                                  filled: true,
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Text('Entry Fee',
                                    style: Get.textTheme.headlineMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black)),
                                const SizedBox(
                                  height: 8,
                                ),
                                CustomTextField(
                                  onTap: () {},
                                  enabled: true,
                                  filled: true,
                                  readOnly: true,
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Text('Organizer Number',
                                    style: Get.textTheme.headlineMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black)),
                                const SizedBox(
                                  height: 8,
                                ),
                                const CustomTextField(
                                  filled: true,
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Text('Rules',
                                    style: Get.textTheme.headlineMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black)),
                                const SizedBox(
                                  height: 8,
                                ),
                                const CustomTextField(
                                  maxLines: 3,
                                  filled: true,
                                ),
                                Row(
                                  children: [
                                    Checkbox(value: true, onChanged: (e) {}),
                                    Text(
                                        'I\'ve hereby read and agree to your terms and conditions',
                                        style: Get.textTheme.labelMedium),
                                  ],
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Text('Disclaimer',
                                    style: Get.textTheme.headlineMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black)),
                                const SizedBox(
                                  height: 8,
                                ),
                                const CustomTextField(
                                  maxLines: 5,
                                  filled: true,
                                ),
                                Row(
                                  children: [
                                    Checkbox(value: true, onChanged: (e) {}),
                                    Text(
                                        'I\'ve hereby read and agree to your terms and conditions',
                                        style: Get.textTheme.labelMedium),
                                  ],
                                ),
                                const SizedBox(
                                  height: 108,
                                ),
                              ],
                            ),
                          ),
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
                    style: Get.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
