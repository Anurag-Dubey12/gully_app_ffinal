import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/ui/screens/select_location.dart';
import 'package:gully_app/ui/widgets/create_tournament/form_input.dart';
import 'package:gully_app/ui/widgets/custom_drop_down_field.dart';
import 'package:gully_app/utils/geo_locator_helper.dart';
import 'package:gully_app/utils/utils.dart';

import '../../data/controller/auth_controller.dart';
import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';
import '../widgets/create_tournament/top_card.dart';
import '../widgets/primary_button.dart';

class TournamentFormScreen extends StatefulWidget {
  final TournamentModel? tournament;
  const TournamentFormScreen({super.key, this.tournament});

  @override
  State<TournamentFormScreen> createState() => _TournamentFormScreenState();
}

class _TournamentFormScreenState extends State<TournamentFormScreen> {
  String tournamentType = 'turf';
  String ballType = 'tennis';
  String pitchType = 'cement';
  DateTime? from;
  DateTime? to;
  bool tncAccepted = false;
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _rulesController = TextEditingController();
  final TextEditingController _entryFeeController = TextEditingController();
  final TextEditingController _ballChargesController = TextEditingController();
  final TextEditingController _breakfastChargesController =
      TextEditingController();
  final TextEditingController _teamLimitController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _disclaimerController = TextEditingController();

  final _key = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).unfocus();
    });
    if (widget.tournament != null) {
      _nameController.text = widget.tournament!.tournamentName;
      _rulesController.text = widget.tournament!.rules ?? "";
      _entryFeeController.text = widget.tournament!.fees.toString();
      _ballChargesController.text = widget.tournament!.ballCharges.toString();
      _breakfastChargesController.text =
          widget.tournament!.breakfastCharges.toString();
      _teamLimitController.text = widget.tournament!.tournamentLimit.toString();
      _addressController.text = widget.tournament!.stadiumAddress;
      _disclaimerController.text = widget.tournament!.disclaimer ?? "";
      from = widget.tournament!.tournamentStartDateTime;
      to = widget.tournament!.tournamentEndDateTime;
      // tournamentType = widget.tournament!.tournamentCategory!;
      ballType = widget.tournament!.ballType;
      pitchType = widget.tournament!.pitchType;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TournamentController tournamentController =
        Get.find<TournamentController>();
    final AuthController authController = Get.find<AuthController>();
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
                              if (_key.currentState!.validate()) {
                                if (from == null || to == null) {
                                  errorSnackBar(
                                      'Please select tournament start and end date');
                                  return;
                                }
                                log(_nameController.text);
                                setState(() {
                                  isLoading = true;
                                });
                                final position = await determinePosition();

                                Map<String, dynamic> tournament = {
                                  "tournamentStartDateTime":
                                      from?.toIso8601String(),
                                  "tournamentEndDateTime":
                                      to?.toIso8601String(),
                                  "tournamentName": _nameController.text,
                                  "tournamentCategory": tournamentType,
                                  "ballType": ballType.toLowerCase(),
                                  "pitchType": pitchType,
                                  "matchType": "Tennis ball cricket match",
                                  "price": "1st price",
                                  "location": _addressController.text,
                                  "tournamentPrize": '1st prize',
                                  "fees": _entryFeeController.text,
                                  "ballCharges": _ballChargesController.text,
                                  "breakfastCharges":
                                      _breakfastChargesController.text,
                                  "stadiumAddress": _addressController.text,
                                  "tournamentLimit": _teamLimitController.text,
                                  "gameType": "KABADDI",
                                  "selectLocation": _addressController.text,
                                  "latitude": position.latitude,
                                  "longitude": position.longitude,
                                  "rules": _rulesController.text,
                                  "disclaimer": _disclaimerController.text,
                                };
                                if (widget.tournament != null) {
                                  bool isOk = await tournamentController
                                      .updateTournament({
                                    ...tournament,
                                    'id': widget.tournament!.id
                                  });
                                  if (isOk) {
                                    Get.back();
                                    successSnackBar(
                                        'Tournament Updated Successfully');
                                  }
                                } else {
                                  bool isOk = await tournamentController
                                      .createTournament(tournament);
                                  if (isOk) {
                                    Get.back();
                                    successSnackBar(
                                        'Tournament Created Successfully');
                                  }
                                }
                              }
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                            // Get.to(() => const SelectLocationScreen());
                          },
                          isDisabled: !tncAccepted,
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
            SizedBox(
              width: Get.width,
              height: Get.height,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        // horizontal: Get.width * 0.07,
                        ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          iconTheme: const IconThemeData(color: Colors.white),
                          title: Text(
                            widget.tournament != null
                                ? 'Edit Tournament'
                                : 'Create Tournament',
                            style: Get.textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 23),
                          ),
                          centerTitle: true,
                        ),
                        SizedBox(height: Get.height * 0.04),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: TopCard(
                            from: from,
                            to: to,
                            controller: _nameController,
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
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: Get.width,
                    // height: Get.height,
                    margin: const EdgeInsets.only(top: 20),
                    color: Colors.black26,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 40, top: 20),
                      child: Form(
                        key: _key,
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
                                style: Get.textTheme.headlineMedium?.copyWith(
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
                            tournamentType == "turf"
                                ? const SizedBox()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      Text('Pitch Type',
                                          style: Get.textTheme.headlineMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                      DropDownWidget(
                                        title: 'Select Pitch Type',
                                        onSelect: (e) {
                                          setState(() {
                                            pitchType = e;
                                          });
                                          Get.back();
                                        },
                                        selectedValue: pitchType.toUpperCase(),
                                        items: const [
                                          'rough',
                                          'cement',
                                        ],
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 9,
                            ),
                            FormInput(
                              controller: TextEditingController(
                                  text: authController.state!.fullName),
                              label: 'Organizer Name',
                              enabled: false,
                              readOnly: true,
                            ),
                            FormInput(
                              controller: TextEditingController(
                                text: authController.state!.phoneNumber,
                              ),
                              label: 'Organizer Phone',
                              enabled: false,
                              readOnly: true,
                              textInputType: TextInputType.number,
                            ),
                            FormInput(
                              controller: _rulesController,
                              label: 'Rules',
                              maxLines: 5,
                            ),
                            FormInput(
                              controller: _addressController,
                              label: 'Select Stadium Address',
                              readOnly: true,
                              onTap: () {
                                Get.to(() => SelectLocationScreen(
                                      onSelected: (e) {
                                        setState(() {
                                          _addressController.text = e;
                                        });
                                        FocusScope.of(context).unfocus();
                                      },
                                    ));
                              },
                            ),
                            FormInput(
                              controller: _entryFeeController,
                              label: 'Entry Fee',
                              validator: (e) {
                                if (e == null || e.isEmpty) {
                                  return 'Please enter entry fee';
                                }
                                return null;
                              },
                              textInputType: TextInputType.number,
                            ),
                            FormInput(
                              controller: _ballChargesController,
                              label: 'Ball Charges',
                              validator: (e) {
                                if (e == null || e.isEmpty) {
                                  return 'Please enter ball charges';
                                }
                                return null;
                              },
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
                              validator: (e) {
                                if (e == null || e.isEmpty) {
                                  return 'Please enter team limit';
                                } else if (int.parse(e) < 2) {
                                  return 'Team limit should be greater than 2';
                                }
                                return null;
                              },
                              textInputType: TextInputType.number,
                            ),
                            FormInput(
                              controller: _disclaimerController,
                              label: 'Disclaimer',
                              maxLines: 5,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                    value: tncAccepted,
                                    onChanged: (e) {
                                      setState(() {
                                        tncAccepted = e!;
                                      });
                                    }),
                                Text(
                                    'I\'ve hereby read and agree to your\nterms and conditions',
                                    style: Get.textTheme.labelMedium),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            FocusScope.of(context).hasFocus && Platform.isIOS
                ? Positioned(
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          padding: const EdgeInsets.all(9),
                          width: Get.width,
                          child: const Text('Done',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18))),
                    ))
                : const SizedBox(),
          ]),
        ));
  }
}
