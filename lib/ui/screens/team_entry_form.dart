import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/ui/screens/home_screen.dart';
import 'package:gully_app/ui/widgets/create_tournament/form_input.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/utils.dart';

import '../../utils/app_logger.dart';
import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';
import '../widgets/primary_button.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";

import 'legal_screen.dart';
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
    final MiscController connectionController=Get.find<MiscController>();
    logger.d("Cover Image:${controller.state!.coverPhoto}");
    return GradientBuilder(
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
          child:Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 35.0, vertical: 19),
                child: PrimaryButton(
                  isDisabled: !rulesAccepted || !termsAccepted || !connectionController.isConnected.value,
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
                                            'Your team request has been sent to the organizer. Please wait for them to accept.',
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
        appBar: AppBar(
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
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // controller.state!.coverPhoto == ''
            //     ? Padding(
            //   padding: const EdgeInsets.all(18.0),
            //   child: SizedBox(
            //     height: 130,
            //     child: Stack(
            //       children: [
            //         ClipRRect(
            //           borderRadius: BorderRadius.circular(20),
            //           child: SizedBox(
            //             width: Get.width,
            //             height: 120,
            //             child: Image.asset('assets/images/logo.png'),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ) : Padding(
            //         padding: const EdgeInsets.all(18.0),
            //         child: SizedBox(
            //           height: 130,
            //           child: Stack(
            //             children: [
            //               ClipRRect(
            //                 borderRadius: BorderRadius.circular(20),
            //                 child: SizedBox(
            //                   width: Get.width,
            //                   height: 120,
            //                   child: Image.network(
            //                     toImageUrl(
            //                         controller.state!.coverPhoto!),
            //                     fit: BoxFit.cover,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 18.0, right: 18.0, top: 0.0, bottom: 0.0),
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
                            validator: (e) {
                              if (e == null || e.trim().isEmpty) {
                                return 'Please enter the address';
                              }
                              if (e.contains(RegExp(r'[^\x00-\x7F]+'))) {
                                return 'Address cannot contain emojis';
                              }
                              return null;}
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
                        // Text('Disclaimer',
                        //     style: Get.textTheme.headlineMedium
                        //         ?.copyWith(
                        //             fontWeight: FontWeight.bold,
                        //             color: Colors.black,
                        //             fontSize: 16)),
                        // FutureBuilder<String>(
                        //     future: Get.find<MiscController>()
                        //         .getContent('teamDisclaimer'),
                        //     builder: (context, snapshot) {
                        //       return Container(
                        //         decoration: BoxDecoration(
                        //             color: Colors.white,
                        //             border: Border.all(
                        //                 color: Colors.black12
                        //                     .withOpacity(0.7)),
                        //             borderRadius:
                        //                 BorderRadius.circular(10),
                        //             boxShadow: [
                        //               BoxShadow(
                        //                   color: Colors.black
                        //                       .withOpacity(0.1),
                        //                   blurRadius: 5,
                        //                   spreadRadius: 2,
                        //                   offset: const Offset(0, 2))
                        //             ]),
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: HtmlWidget(
                        //             snapshot.data ?? '',
                        //             textStyle: const TextStyle(
                        //                 color: Colors.black,
                        //                 fontSize: 14),
                        //           ),
                        //         ),
                        //       );
                        //       // return FormInput(
                        //       //   controller: TextEditingController(
                        //       //       text: snapshot.data ?? ''),
                        //       //   enabled: false,
                        //       //   maxLines: 4,
                        //       //   label: "Disclaimer",
                        //       // );
                        //     }),
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
                            RichText(
                              text: TextSpan(
                                text: AppLocalizations.of(context)!.iHerebyAgreeToThe,
                                children: [
                                  TextSpan(
                                    text: AppLocalizations.of(context)!.disclaimer,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.bottomSheet(BottomSheet(
                                          onClosing: () {},
                                          builder: (builder) => const LegalViewScreen(
                                              title: 'Disclaimer',
                                              slug: 'disclaimer',
                                              hideDeleteButton: true),
                                        ));
                                      },
                                    style: const TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(text: " of the app ", style: TextStyle()),
                                ],
                                style: Get.textTheme.titleSmall,
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 108,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
