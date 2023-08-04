import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gully_app/src/ui/screens/select_location.dart';

import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';
import '../widgets/primary_button.dart';

class CreateTournamentScreen extends StatefulWidget {
  const CreateTournamentScreen({super.key});

  @override
  State<CreateTournamentScreen> createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
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
                          Text('Create Tournament',
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
                      height: Get.height * 0.5,
                      margin: const EdgeInsets.only(top: 20),
                      color: Colors.black26,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: SingleChildScrollView(
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
                              const SizedBox(
                                height: 18,
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
                              const SizedBox(
                                height: 18,
                              ),
                              Text('Organizer Name',
                                  style: Get.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(
                                height: 8,
                              ),
                              const CustomTextField(),
                              const SizedBox(
                                height: 18,
                              ),
                              Text('Organizer Phone',
                                  style: Get.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(
                                height: 8,
                              ),
                              const CustomTextField(),
                              const SizedBox(
                                height: 18,
                              ),
                              Text('Rules',
                                  style: Get.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(
                                height: 8,
                              ),
                              const CustomTextField(),
                              const SizedBox(
                                height: 18,
                              ),
                              Text('Select Location',
                                  style: Get.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(
                                height: 8,
                              ),
                              const CustomTextField(),
                              const SizedBox(
                                height: 18,
                              ),
                              Text('Entry Fee',
                                  style: Get.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(
                                height: 8,
                              ),
                              const CustomTextField(),
                              const SizedBox(
                                height: 18,
                              ),
                              Text('Ball Charges',
                                  style: Get.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(
                                height: 8,
                              ),
                              const CustomTextField(),
                              const SizedBox(
                                height: 18,
                              ),
                              Text('Breakfast Charges',
                                  style: Get.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(
                                height: 8,
                              ),
                              const CustomTextField(),
                              const SizedBox(
                                height: 18,
                              ),
                              Text('Team Limit',
                                  style: Get.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(
                                height: 8,
                              ),
                              const CustomTextField(),
                              const SizedBox(
                                height: 18,
                              ),
                              Text('Address',
                                  style: Get.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(
                                height: 8,
                              ),
                              const CustomTextField(),
                              const SizedBox(
                                height: 18,
                              ),
                              Text('Disclaimer',
                                  style: Get.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(
                                height: 8,
                              ),
                              const CustomTextField(),
                            ],
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

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        decoration: InputDecoration(
          isDense: true,

          labelText: '',
          labelStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.white,
          // isCollapsed: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
        ),
      ),
    );
  }
}

class DropDownWidget extends StatelessWidget {
  final Function onSelect;
  final String? selectedValue;
  final List<String> items;
  final String title;
  const DropDownWidget({
    super.key,
    required this.onSelect,
    this.selectedValue,
    required this.items,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        borderRadius: BorderRadius.circular(9),
        borderOnForeground: true,
        child: InkWell(
          borderRadius: BorderRadius.circular(9),
          onTap: () {
            Get.bottomSheet(BottomSheet(
                onClosing: () {},
                builder: (context) => Container(
                      height: Get.height * 0.3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9)),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: Get.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Radio(
                                      value: true,
                                      groupValue: selectedValue == items[index],
                                      onChanged: (e) => onSelect(items[index]),
                                    ),
                                    onTap: () {
                                      onSelect();
                                      Get.back();
                                    },
                                    title: Text(items[index]),
                                  );
                                }),
                          ],
                        ),
                      ),
                    )));
          },
          child: Ink(
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(selectedValue ?? '', style: Get.textTheme.labelLarge),
                  const Spacer(),
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_drop_down,
                        size: 28,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
