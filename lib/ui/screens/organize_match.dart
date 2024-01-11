import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/screens/view_matchups_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';

class SelectOrganizeTeam extends StatefulWidget {
  final String? title;
  const SelectOrganizeTeam({super.key, this.title});

  @override
  State<SelectOrganizeTeam> createState() => _SelectOrganizeTeamState();
}

class _SelectOrganizeTeamState extends State<SelectOrganizeTeam> {
  String _selectedItem = 'TEAM 1'; // Default selected item

  final List<String> _dropdownItems = [
    'TEAM 1',
    'TEAM 2',
    'TEAM 3',
    'TEAM 4',
    'TEAM 5',
  ];
  @override
  Widget build(BuildContext context) {
    return GradientBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              child: SizedBox(
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text('Organize',
                                  style: Get.textTheme.headlineLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(height: Get.height * 0.04),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    const CircleAvatar(
                                      radius: 43,
                                      backgroundImage: NetworkImage(
                                          'https://mediacaterer.com/wp-content/uploads/2023/06/KFC-logo-1.jpg'),
                                    ),
                                    const SizedBox(height: 20),
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: DropdownButton<String>(
                                          value: _selectedItem,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          padding: EdgeInsets.zero,
                                          iconSize: 24,
                                          // menuMaxHeight: 8,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          alignment: Alignment.bottomCenter,
                                          // elevation: 16,
                                          iconEnabledColor: Colors.black,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          underline: const SizedBox(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedItem = newValue!;
                                            });
                                          },
                                          items: _dropdownItems
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Chip(
                                        label: Text('VS',
                                            style: Get.textTheme.labelLarge
                                                ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                        backgroundColor:
                                            AppTheme.secondaryYellowColor,
                                        side: BorderSide.none),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    const CircleAvatar(
                                      radius: 43,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(
                                          'https://www.partageshoppingbetim.com.br/wp-content/uploads/sites/3/2023/01/Burger-king-logo-1.png'),
                                    ),
                                    const SizedBox(height: 20),
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: DropdownButton<String>(
                                          value: _selectedItem,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          padding: EdgeInsets.zero,
                                          iconSize: 24,
                                          // menuMaxHeight: 8,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          alignment: Alignment.bottomCenter,
                                          // elevation: 16,
                                          iconEnabledColor: Colors.black,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          underline: const SizedBox(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedItem = newValue!;
                                            });
                                          },
                                          items: _dropdownItems
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: Get.height * 0.03),
                            InkWell(
                              onTap: () {
                                showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('12:00'),
                                ),
                              ),
                            ),
                            SizedBox(height: Get.height * 0.03),
                            PrimaryButton(
                              onTap: () {
                                Get.to(() => const ViewMatchupsScreen());
                              },
                              title: 'Submit',
                            )
                          ],
                        ))
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
