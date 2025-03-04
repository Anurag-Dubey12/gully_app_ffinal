import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/ui/screens/organize_match.dart';
import 'package:gully_app/ui/screens/select_match_for_scoreboard.dart';
import 'package:gully_app/ui/screens/tournament_form_screen.dart';
import 'package:gully_app/ui/screens/tournament_teams.dart';
import 'package:gully_app/ui/screens/update_authority_screen.dart';
import 'package:gully_app/ui/screens/view_matchups_screen.dart';
import 'package:gully_app/ui/screens/view_tournaments_screen.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/ui/widgets/sponsor/addSponsorDetails.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';

import '../../data/controller/misc_controller.dart';
import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';
import '../widgets/sponsor/sponsor_package.dart';
import 'SponsorScreen.dart';

enum RedirectType {
  organizeMatch,
  scoreboard,
  matchup,
  editForm,
  currentTournament,
  manageAuthority,
  sponsor
}

class CurrentTournamentListScreen extends GetView<TournamentController> {
  final RedirectType redirectType;

  const CurrentTournamentListScreen({
    super.key,
    required this.redirectType,
  });
  @override
  Widget build(BuildContext context) {
    final MiscController connectionController=Get.find<MiscController>();
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
        body:Stack(
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
                      color: Colors.black.withOpacity(0.9),
                      blurRadius: 20,
                      spreadRadius: 20,
                      offset: const Offset(0, 90),
                    ),
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
                      title: Text(
                        AppLocalizations.of(context)!.currentTournamentTitle,
                        style: Get.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      leading: const BackButton(
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.07,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Obx(() {
                            if (controller
                                .organizerTournamentList.value.isEmpty) {
                              return const EmptyTournamentWidget();
                            }
                            if (controller.status.isError) {
                              return const Center(
                                child: Text(
                                  'Something went wrong',
                                ),
                              );
                            }
                            return !connectionController.isConnected.value ? Center(
                              child: SizedBox(
                                width: Get.width,
                                height: Get.height * 0.7,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.signal_wifi_off,
                                      size: 48,
                                      color: Colors.black54,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No internet connection',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ):SizedBox(
                              height: Get.height / 1.2,
                              child: ListView.separated(
                                scrollDirection: Axis.vertical,
                                separatorBuilder: (context, index) =>
                                const SizedBox(height: 18),
                                shrinkWrap: true,
                                padding:
                                EdgeInsets.only(top: Get.height * 0.08),
                                physics:
                                const AlwaysScrollableScrollPhysics(),
                                itemCount: controller
                                    .organizerTournamentList.value.length,
                                itemBuilder: (context, index) {
                                  return _Card(

                                    tournament: controller
                                        .organizerTournamentList.value[index],
                                    redirectType: redirectType,
                                  );
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
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

class _Card extends StatefulWidget {
  final TournamentModel tournament;
  final RedirectType redirectType;

  const _Card({required this.tournament, required this.redirectType});

  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    logger.d("The Total Tournament: ${controller.tournamentList.map((t)=>t.tournamentName)}");
    logger.d('build');

    return GestureDetector(
      onTap: () {
        switch (widget.redirectType) {
          case RedirectType.organizeMatch:
            // Get.dialog(
            //   id: Random().nextInt(1000).toString(),
            //   InputRoundNumber(
            //     tournament: widget.tournament,
            //   ),
            // );
            controller.saveDates(
                widget.tournament.tournamentStartDateTime,
                widget.tournament.tournamentEndDateTime,
                widget.tournament.authority ??''
            );
            controller.isEditable.value = true;
            Get.to(
                  () => SelectOrganizeTeam(
                tournament: widget.tournament,
              ),
            );
            break;
          case RedirectType.scoreboard:
            controller.setSelectedTournament(widget.tournament);
            Get.to(() => const SelectMatchForScoreBoard());
            break;
          case RedirectType.matchup:
            controller.setSelectedTournament(widget.tournament);
            controller.setScheduleStatus(false);
            Get.to(() => ViewMatchupsScreen(tournament: widget.tournament));
            controller.tournamentId.value=widget.tournament.id ??'';
            controller.isTourOver.value=false;
            break;
          case RedirectType.editForm:
            Get.to(() => TournamentFormScreen(
              tournament: widget.tournament,
            ));
            break;
          case RedirectType.currentTournament:
            logger.d("Current tournament is");
            Get.to(() => TournamentTeams(
              tournament: widget.tournament,
              isTeamListOnly: true,
            ));
            break;
          case RedirectType.manageAuthority:
            Get.to(() => UpdateAuthorityScreen(
              tournament: widget.tournament,
            ));
            break;
          case RedirectType.sponsor:
            if (widget.tournament.isSponsorshippurchase==false) {
              // showDialog(
              //   context: context,
              //   builder: (BuildContext context) {
              //     return Dialog(
              //       backgroundColor: Colors.transparent,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //       child: Container(
              //         padding: const EdgeInsets.all(20),
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(20),
              //         ),
              //         child: Column(
              //           mainAxisSize: MainAxisSize.min,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             const Icon(
              //               Icons.warning_amber_rounded,
              //               color: Colors.orange,
              //               size: 50,
              //             ),
              //             const SizedBox(height: 15),
              //             const Text(
              //               'Payment Required',
              //               style: TextStyle(
              //                 fontSize: 22,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.blueGrey,
              //               ),
              //             ),
              //             const SizedBox(height: 10),
              //             Text(
              //               'To add a sponsor for the tournament "${widget.tournament.tournamentName}", you need to make a payment. Please complete the payment to proceed.',
              //               textAlign: TextAlign.center,
              //               style: const TextStyle(
              //                 fontSize: 16,
              //                 color: Colors.black87,
              //               ),
              //             ),
              //             const SizedBox(height: 20),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 ElevatedButton(
              //                   onPressed: () {
              //                     Get.to(() => SponsorPackageScreen(tournament: widget.tournament));
              //                   },
              //                   style: ElevatedButton.styleFrom(
              //                     backgroundColor: AppTheme.primaryColor,
              //                     shape: RoundedRectangleBorder(
              //                       borderRadius: BorderRadius.circular(12),
              //                     ),
              //                     padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              //                   ),
              //                   child: const Text(
              //                     'Pay Now',
              //                     style: TextStyle(
              //                       color: Colors.white,
              //                       fontWeight: FontWeight.w500,
              //                     ),
              //                   ),
              //                 ),
              //                 TextButton(
              //                   onPressed: () {
              //                     Navigator.of(context).pop();
              //                   },
              //                   child: const Text(
              //                     'Cancel',
              //                     style: TextStyle(
              //                       fontSize: 16,
              //                       color: Colors.red,
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       ),
              //     );
              //   },
              // );
              Get.to(() => SponsorPackageScreen(tournament: widget.tournament));
            }else{
              logger.d("Tournament sponsor Id:${widget.tournament.SponsorshipPackageId}");
              Get.to(() => SponsorScreen(tournament: widget.tournament));
            }
            break;

        }
      },
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(
          //   color: Colors.black
          // ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          // border: Border.all(
          //   color: Colors.black
          // ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.05,
            vertical: Get.height * 0.02,
          ),
          child: Row(
            children: [
              const Spacer(),
              Text(
                widget.tournament.tournamentName,
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 19,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class InputRoundNumber extends StatefulWidget {
  final TournamentModel? tournament;
  final String? existingRound;
  final Function(String) onItemSelected;

  const InputRoundNumber({super.key, 
    this.tournament,
    this.existingRound,
    required this.onItemSelected,
  });

  @override
  State<InputRoundNumber> createState() => _InputRoundNumberState();
}

class _InputRoundNumberState extends State<InputRoundNumber> {
  late TextEditingController roundController;
  late TextEditingController roundNumberController;

  List<String> items = [
    'Round',
    'qualifier',
    'semi final',
    'final match',
  ];

  OverlayEntry? _overlayEntry;
  final GlobalKey _dropdownKey = GlobalKey();
  bool _isRoundSelected = false;

  @override
  void initState() {
    super.initState();

    String? extractedRound;
    String? extractedRoundNumber;

    if (widget.existingRound != null) {
      final roundMatch = RegExp(r'Round\s*(\d+)', caseSensitive: false).firstMatch(widget.existingRound!);

      if (roundMatch != null) {
        extractedRound = 'Round';
        extractedRoundNumber = roundMatch.group(1);
        _isRoundSelected = true;
      } else {
        extractedRound = widget.existingRound;
      }
    }

    roundController = TextEditingController(text: extractedRound ?? '');
    roundNumberController = TextEditingController(text: extractedRoundNumber ?? '');
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    roundController.dispose();
    roundNumberController.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: Material(
          elevation: 4.0,
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: items
                .map((e) => ListTile(
              title: Text(e.capitalize),
              onTap: () {
                setState(() {
                  roundController.text = e;
                  _isRoundSelected = e == 'Round';
                  if (!_isRoundSelected) {
                    roundNumberController.clear();
                  }
                });
                _toggleDropdown();
              },
            ))
                .toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final TournamnetController = Get.find<TournamentController>();
    logger.d("The id is:${authController.state!.id} and authority id is:${TournamnetController.tournamentauthority}");
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Round",
                style: Get.textTheme.headlineMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18)),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _toggleDropdown,
              child: Container(
                key: _dropdownKey,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      roundController.text.isEmpty ? 'Select Round' : roundController.text.capitalize,
                      style: Get.textTheme.headlineMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            if (_isRoundSelected) ...[
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: roundNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        hintText: 'Enter Round Number',
                        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.blue),
                    onPressed: () {
                      int currentValue = int.tryParse(roundNumberController.text) ?? 0;
                      setState(() {
                        roundNumberController.text = (currentValue + 1).toString();
                      });
                    },
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            PrimaryButton(
              onTap: () {
                if (TournamnetController.tournamentauthority.value != authController.state?.id) {
                  errorSnackBar('You are not authorized to organize the match',
                      forceDialogOpen: true)
                      .then((value) => Get.back());
                  return;
                }
                if (roundController.text.isEmpty) {
                  errorSnackBar('Please select a round', forceDialogOpen: true);
                  return;
                }
                if (_isRoundSelected && roundNumberController.text.isEmpty) {
                  errorSnackBar('Please enter a round number', forceDialogOpen: true);
                  return;
                }
                String roundText = _isRoundSelected
                    ? 'Round ${roundNumberController.text}'
                    : roundController.text;

                widget.onItemSelected(roundText);
                Navigator.pop(context);
              },
              title: 'Continue',
            )
          ],
        ),
      ),
    );
  }
}

//previous inputRound Number
// class InputRoundNumber extends StatefulWidget {
//   final TournamentModel? tournament;
//   final String? existingRound;
//
//   const InputRoundNumber({
//     this.tournament,
//     this.existingRound,
//   });
//
//   @override
//   State<InputRoundNumber> createState() => _InputRoundNumberState();
// }
//
// class _InputRoundNumberState extends State<InputRoundNumber> {
//   late TextEditingController roundController;
//   late TextEditingController roundNumberController;
//
//   List<String> items = [
//     'Round',
//     'qualifier',
//     'semi final',
//     'final match',
//   ];
//
//   OverlayEntry? _overlayEntry;
//   final GlobalKey _dropdownKey = GlobalKey();
//   bool _isRoundSelected = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     String? extractedRound;
//     String? extractedRoundNumber;
//
//     if (widget.existingRound != null) {
//       final roundMatch = RegExp(r'Round\s*(\d+)', caseSensitive: false).firstMatch(widget.existingRound!);
//
//       if (roundMatch != null) {
//         extractedRound = 'Round';
//         extractedRoundNumber = roundMatch.group(1);
//         _isRoundSelected = true;
//       } else {
//         extractedRound = widget.existingRound;
//       }
//     }
//
//     roundController = TextEditingController(text: extractedRound ?? '');
//     roundNumberController = TextEditingController(text: extractedRoundNumber ?? '');
//   }
//
//   @override
//   void dispose() {
//     _overlayEntry?.remove();
//     roundController.dispose();
//     roundNumberController.dispose();
//     super.dispose();
//   }
//
//   void _toggleDropdown() {
//     if (_overlayEntry == null) {
//       _overlayEntry = _createOverlayEntry();
//       Overlay.of(context).insert(_overlayEntry!);
//     } else {
//       _overlayEntry!.remove();
//       _overlayEntry = null;
//     }
//   }
//
//   OverlayEntry _createOverlayEntry() {
//     RenderBox renderBox = _dropdownKey.currentContext!.findRenderObject() as RenderBox;
//     var size = renderBox.size;
//     var offset = renderBox.localToGlobal(Offset.zero);
//
//     return OverlayEntry(
//       builder: (context) => Positioned(
//         left: offset.dx,
//         top: offset.dy + size.height,
//         width: size.width,
//         child: Material(
//           elevation: 4.0,
//           child: ListView(
//             padding: EdgeInsets.zero,
//             shrinkWrap: true,
//             children: items
//                 .map((e) => ListTile(
//               title: Text(e.capitalize),
//               onTap: () {
//                 setState(() {
//                   roundController.text = e;
//                   _isRoundSelected = e == 'Round';
//
//                   // Clear round number if not 'Round'
//                   if (!_isRoundSelected) {
//                     roundNumberController.clear();
//                   }
//                 });
//                 _toggleDropdown();
//               },
//             ))
//                 .toList(),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final authController = Get.find<AuthController>();
//     final TournamnetController = Get.find<TournamentController>();
//     return Dialog(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Select Round",
//                 style: Get.textTheme.headlineMedium?.copyWith(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 18)),
//             const SizedBox(height: 20),
//             GestureDetector(
//               onTap: _toggleDropdown,
//               child: Container(
//                 key: _dropdownKey,
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       roundController.text.isEmpty ? 'Select Round' : roundController.text.capitalize,
//                       style: Get.textTheme.headlineMedium?.copyWith(
//                         color: Colors.black,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const Icon(Icons.arrow_drop_down),
//                   ],
//                 ),
//               ),
//             ),
//             if (_isRoundSelected) ...[
//               const SizedBox(height: 5),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: roundNumberController,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 12),
//                         hintText: 'Enter Round Number',
//                         hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: Colors.grey.shade300),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: const BorderSide(color: Colors.grey),
//                         ),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.add_circle, color: Colors.blue),
//                     onPressed: () {
//                       int currentValue = int.tryParse(roundNumberController.text) ?? 0;
//                       setState(() {
//                         roundNumberController.text = (currentValue + 1).toString();
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ],
//             const SizedBox(height: 20),
//             PrimaryButton(
//               onTap: () {
//                 if (TournamnetController.tournamentauthority.value != authController.state?.id) {
//                   errorSnackBar('You are not authorized to organize the match',
//                       forceDialogOpen: true)
//                       .then((value) => Get.back());
//                   return;
//                 }
//                 if (roundController.text.isEmpty) {
//                   errorSnackBar('Please select a round', forceDialogOpen: true);
//                   return;
//                 }
//                 if (_isRoundSelected && roundNumberController.text.isEmpty) {
//                   errorSnackBar('Please enter a round number', forceDialogOpen: true);
//                   return;
//                 }
//                 String roundText = _isRoundSelected
//                     ? 'Round ${roundNumberController.text}'
//                     : roundController.text;
//
//                 Get.back();
//                 Get.to(
//                       () => SelectOrganizeTeam(
//                     tournament: widget.tournament,
//                     round: roundText,
//                   ),
//                 );
//               },
//               title: 'Continue',
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
