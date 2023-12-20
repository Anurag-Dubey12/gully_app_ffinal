import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/ui/screens/select_location.dart';
import 'package:gully_app/ui/widgets/create_tournament/form_input.dart';

import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';
import '../widgets/create_tournament/top_card.dart';
import '../widgets/custom_drop_down_field.dart';
import '../widgets/primary_button.dart';

class CreateTournamentScreen extends StatefulWidget {
  const CreateTournamentScreen({super.key});

  @override
  State<CreateTournamentScreen> createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  String tournamentType = 'turf';
  String ballType = 'tennis';
  DateTime? from;
  DateTime? to;
  static final TextEditingController _organizerNameController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _organizerPhoneController =
      TextEditingController();
  final TextEditingController _rulesController = TextEditingController();
  final TextEditingController _entryFeeController = TextEditingController();
  final TextEditingController _ballChargesController = TextEditingController();
  final TextEditingController _breakfastChargesController =
      TextEditingController();
  final TextEditingController _teamLimitController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _disclaimerController = TextEditingController();
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final TournamentController tournamentController =
        Get.find<TournamentController>();
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
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : PrimaryButton(
                          onTap: () async {
                            try {
                              log(_nameController.text);
                              setState(() {
                                isLoading = true;
                              });
                              Map<String, dynamic> tournament = {
                                "tournamentStartDateTime":
                                    from?.toIso8601String(),
                                "tournamentEndDateTime": to?.toIso8601String(),
                                "tournamentName": _nameController.text,
                                "tournamentCategory": "turf",
                                "ballType": ballType.toLowerCase(),
                                "pitchType": "cement",
                                "matchType": "Tennis ball cricket match",
                                "price": "1st price",
                                "location": "Mumbai",
                                "tournamentPrize": '1st prize',
                                "fees": _entryFeeController.text,
                                "ballCharges": _ballChargesController.text,
                                "breakfastCharges":
                                    _breakfastChargesController.text,
                                "stadiumAddress": "ABC",
                                "tournamentLimit": 12,
                                "gameType": "KABADDI",
                                "selectLocation": "borivali", // remove
                                "latitude": 19.217907,
                                "longitude": 72.847084
                              };
                              bool isOk = await tournamentController
                                  .createTournament(tournament);
                              if (isOk) {
                                Get.back();
                              }
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                            // Get.to(() => const SelectLocationScreen());
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
                      padding: EdgeInsets.only(left: 0, top: 30),
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
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23)),
                          SizedBox(height: Get.height * 0.04),
                          TopCard(
                            controller: _nameController,
                            fromController: _startDate,
                            toController: _endDate,
                            onFromChanged: (
                              e,
                            ) {
                              setState(() {
                                from = e;
                              });
                            },
                            onToChanged: (e) {
                              setState(() {
                                to = e;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: Get.width,
                      height: Get.height,
                      margin: const EdgeInsets.only(top: 20),
                      color: Colors.black26,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 40, top: 20),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(bottom: Get.height / 2),
                          child: Form(
                            key: _key,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tournament Category',
                                    style: Get.textTheme.headlineMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                DropDownWidget(
                                  title: 'Select Tournament Category',
                                  onSelect: (e) {
                                    setState(() {
                                      tournamentType = e;
                                    });
                                    Get.back();
                                  },
                                  selectedValue: tournamentType.toUpperCase(),
                                  items: const [
                                    'turf',
                                    'corporate',
                                    'series',
                                    'open'
                                  ],
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Text('Ball Type',
                                    style: Get.textTheme.headlineMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                DropDownWidget(
                                  title: 'Select Ball Type',
                                  onSelect: (e) {
                                    setState(() {
                                      ballType = e;
                                    });
                                    Get.back();
                                  },
                                  selectedValue: ballType.toUpperCase(),
                                  items: const [
                                    'tennis',
                                    'leather',
                                    'others',
                                  ],
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                                FormInput(
                                  controller: _organizerNameController,
                                  label: 'Organizer Name',
                                ),
                                FormInput(
                                  controller: _organizerPhoneController,
                                  label: 'Organizer Phone',
                                  textInputType: TextInputType.number,
                                ),
                                FormInput(
                                  controller: _rulesController,
                                  label: 'Rules',
                                  maxLines: 5,
                                ),
                                FormInput(
                                  controller: TextEditingController(),
                                  label: 'Select Location',
                                  readOnly: true,
                                  onTap: () {
                                    Get.to(() => const SelectLocationScreen());
                                  },
                                ),
                                FormInput(
                                  controller: _entryFeeController,
                                  label: 'Entry Fee',
                                  textInputType: TextInputType.number,
                                ),
                                FormInput(
                                  controller: _ballChargesController,
                                  label: 'Ball Charges',
                                  textInputType: TextInputType.number,
                                ),
                                FormInput(
                                  controller: _breakfastChargesController,
                                  label: 'Breakfast Charges',
                                  textInputType: TextInputType.number,
                                ),
                                FormInput(
                                  controller: _teamLimitController,
                                  label: 'Team Limit',
                                  textInputType: TextInputType.number,
                                ),
                                FormInput(
                                  controller: _addressController,
                                  label: 'Address',
                                ),
                                FormInput(
                                  controller: _disclaimerController,
                                  label: 'Disclaimer',
                                  maxLines: 5,
                                ),
                                Row(
                                  children: [
                                    Checkbox(value: true, onChanged: (e) {}),
                                    Text(
                                        'I\'ve hereby read and agree to your terms and conditions',
                                        style: Get.textTheme.labelMedium),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            FocusScope.of(context).hasFocus
                ? Positioned(
                    bottom: 0,
                    child: Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        padding: const EdgeInsets.all(9),
                        width: Get.width,
                        child: const Text('Done',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18))))
                : const SizedBox(),
          ]),
        ));
  }
}
