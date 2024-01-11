import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/ui/screens/home_screen.dart';
import 'package:gully_app/ui/widgets/create_tournament/form_input.dart';
import 'package:gully_app/utils/app_logger.dart';

import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';
import '../widgets/primary_button.dart';

class TeamEntryForm extends StatefulWidget {
  final TeamModel team;
  const TeamEntryForm({super.key, required this.team});

  @override
  State<TeamEntryForm> createState() => _TeamEntryFormState();
}

class _TeamEntryFormState extends State<TeamEntryForm> {
  String selectedValue2 = 'Tennis';
  final TextEditingController _viceCaptainController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool rulesAccepted = false;
  bool termsAccepted = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final TournamentController controller = Get.find<TournamentController>();
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
                  child: PrimaryButton(
                    isDisabled: !rulesAccepted || !termsAccepted,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        controller
                            .registerTeam(
                          teamId: widget.team.id,
                          viceCaptainContact: _viceCaptainController.text,
                          address: _addressController.text,
                          tournamentId: controller.status.data!.id,
                        )
                            .then((value) {
                          if (value) {
                            logger.i('Team Registered');
                            Get.offAll(() => const HomeScreen());
                          }
                        });
                      }
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
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FormInput(
                                    controller: TextEditingController(
                                      text: widget.team.name,
                                    ),
                                    readOnly: true,
                                    enabled: false,
                                    label: 'Team name',
                                  ),
                                  FormInput(
                                    controller: _addressController,
                                    label: 'Address',
                                  ),
                                  FormInput(
                                    controller: TextEditingController(
                                        text: authController.user.value.email),
                                    label: 'Email',
                                    enabled: false,
                                  ),
                                  FormInput(
                                    controller: TextEditingController(
                                      text:
                                          authController.user.value.phoneNumber,
                                    ),
                                    readOnly: true,
                                    enabled: false,
                                    label: 'Captian Contact ',
                                  ),
                                  FormInput(
                                    controller: _viceCaptainController,
                                    label: 'Vice Captian Contact ',
                                    textInputType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter a valid phone number';
                                      }
                                      if (value.length != 10) {
                                        return 'Please enter a valid phone number';
                                      }
                                      return null;
                                    },
                                  ),
                                  FormInput(
                                    controller: TextEditingController(
                                        text: controller.status.data?.fees
                                            .toString()),
                                    label: "Entry Fees",
                                    enabled: false,
                                  ),
                                  FormInput(
                                    controller: TextEditingController(
                                        text: controller
                                            .status.data?.phoneNumber
                                            .toString()),
                                    enabled: false,
                                    label: "Organizer Phone",
                                  ),
                                  FormInput(
                                    controller: TextEditingController(
                                        text:
                                            'By clicking on submit you agree to the terms and conditions of the tournament'),
                                    enabled: false,
                                    maxLines: 4,
                                    label: "Rules",
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                          width: 20,
                                          child: Checkbox(
                                              value: rulesAccepted,
                                              onChanged: (e) {
                                                setState(() {
                                                  rulesAccepted = e!;
                                                });
                                              })),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                          'I\'ve hereby read and agree to your terms and\nconditions',
                                          style: Get.textTheme.titleSmall),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  FormInput(
                                    controller: TextEditingController(
                                        text:
                                            'By clicking on submit you agree to the terms and conditions of the tournament'),
                                    enabled: false,
                                    maxLines: 4,
                                    label: "Rules",
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: 20,
                                          child: Checkbox(
                                              value: termsAccepted,
                                              onChanged: (e) {
                                                setState(() {
                                                  termsAccepted = e!;
                                                });
                                              })),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                          'I\'ve hereby read and agree to your terms and\nconditions',
                                          style: Get.textTheme.titleSmall),
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
