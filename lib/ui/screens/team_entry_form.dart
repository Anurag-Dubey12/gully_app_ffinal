import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/ui/screens/home_screen.dart';
import 'package:gully_app/ui/widgets/create_tournament/form_input.dart';
import 'package:gully_app/utils/utils.dart';

import '../../utils/app_logger.dart';
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
// final TextEditingController _viceCaptainController = TextEditingController();
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
                          viceCaptainContact: '1234567890',
                          address: _addressController.text,
                          tournamentId: controller.status.data!.id,
                        )
                            .then((value) {
                          if (value) {
                            logger.i('Team Registered');
                            Get.bottomSheet(
                                BottomSheet(
                                    onClosing: () {},
                                    enableDrag: false,
                                    showDragHandle: true,
                                    builder: (context) {
                                      return SizedBox(
                                        width: Get.width,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Icon(
                                              Icons.verified,
                                              size: 98,
                                              color:
                                                  AppTheme.secondaryYellowColor,
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                              'Request Sent Successfully',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                              'Your request has been sent to the organizer. You will be notified once your request is accepted.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: PrimaryButton(
                                                onTap: () {
                                                  Get.offAll(
                                                      () => const HomeScreen(),
                                                      predicate: (route) =>
                                                          route.name ==
                                                          '/HomeScreen');
                                                },
                                                title: 'OK',
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 80,
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                isDismissible: false,
                                enableDrag: false);
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
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Text('Entry Form',
                          style: Get.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      leading: const BackButton(
                        color: Colors.white,
                      ),
                    ),
                    controller.state!.coverPhoto != null
                        ? Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SizedBox(
                              height: 130,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: SizedBox(
                                      width: Get.width,
                                      height: 120,
                                      child: Image.network(
                                        toImageUrl(
                                            controller.state!.coverPhoto!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
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
                                    autofocus: true,
                                    validator: (e) {
                                      if (e!
                                          .contains(RegExp(r'[^\x00-\x7F]+'))) {
                                        return 'Address cannot contain emojis';
                                      }
                                      return null;
                                    },
                                  ),
                                  FormInput(
                                    controller: TextEditingController(
                                        text: authController.state!.email),
                                    label: 'Email',
                                    enabled: false,
                                  ),
                                  FormInput(
                                    controller: TextEditingController(
                                      text: authController.state!.phoneNumber,
                                    ),
                                    readOnly: true,
                                    enabled: false,
                                    label: 'Captain Contact ',
                                  ),
                                  // FormInput(
                                  //   controller: _viceCaptainController,
                                  //   label: 'Vice Captain Contact ',
                                  //   textInputType: TextInputType.number,
                                  //   maxLength: 10,
                                  //   validator: (value) {
                                  //     if (value!.isEmpty) {
                                  //       return 'Please enter a valid phone number';
                                  //     }
                                  //     if (value.length != 10) {
                                  //       return 'Please enter a valid phone number';
                                  //     }
                                  //     return null;
                                  //   },
                                  // ),
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
                                            .status.data?.tournamentPrize
                                            .toString()),
                                    label: "Prize",
                                    enabled: false,
                                  ),
                                  FormInput(
                                    controller: TextEditingController(
                                        text: controller
                                            .status.data?.organizerName
                                            .toString()),
                                    enabled: false,
                                    label: "Organizer Name",
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
                                        text: controller.status.data!.rules),
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
                                          'I\'ve hereby read and agree to Organizer Rules\nand Regulations',
                                          style: Get.textTheme.titleSmall),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  FormInput(
                                    controller: TextEditingController(
                                        text:
                                            controller.status.data!.disclaimer),
                                    enabled: false,
                                    maxLines: 4,
                                    label: "Disclaimer",
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
                                      const SizedBox(width: 8),
                                      Text(
                                          'I\'ve hereby read and agree to your disclaimer',
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
            FocusScope.of(context).hasFocus && Platform.isIOS
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
