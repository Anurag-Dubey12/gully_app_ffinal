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
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';

import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';

enum RedirectType {
  organizeMatch,
  scoreboard,
  matchup,
  editForm,
  currentTournament,
  manageAuthority,
}

class CurrentTournamentListScreen extends GetView<TournamentController> {
  final RedirectType redirectType;

  const CurrentTournamentListScreen({
    super.key,
    required this.redirectType,
  });

  @override
  Widget build(BuildContext context) {
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
        body: SafeArea(
          child: Stack(
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
                                return Center(
                                  child: Text(
                                    'Error: ${controller.status.errorMessage}',
                                  ),
                                );
                              }
                              return SizedBox(
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

    logger.d('build');
    return GestureDetector(
      onTap: () {
        switch (widget.redirectType) {
          case RedirectType.organizeMatch:
            Get.dialog(
              id: Random().nextInt(1000).toString(),
              _InputRoundNumber(
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
            Get.to(() => const ViewMatchupsScreen());
            break;
          case RedirectType.editForm:
            Get.to(() => TournamentFormScreen(
                  tournament: widget.tournament,
                ));
            break;
          case RedirectType.currentTournament:
            Get.to(() => TournamentTeams(
                  tournament: widget.tournament,
                ));
            break;
          case RedirectType.manageAuthority:
            Get.to(() => UpdateAuthorityScreen(
                  tournament: widget.tournament,
                ));
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

class _InputRoundNumber extends StatefulWidget {
  const _InputRoundNumber({
    required this.tournament,
  });

  final TournamentModel tournament;

  @override
  State<_InputRoundNumber> createState() => _InputRoundNumberState();
}

class _InputRoundNumberState extends State<_InputRoundNumber> {
  var roundController = TextEditingController();
  List<String> items = [
    'qualifier',
    'semi final',
    'final match',
  ];
  OverlayEntry? _overlayEntry;
  final GlobalKey _dropdownKey = GlobalKey();

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context)!.insert(_overlayEntry!);
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
            const SizedBox(height: 20),
            PrimaryButton(
              onTap: () {
                if (widget.tournament.authority != authController.state?.id) {
                  errorSnackBar('You are not authorized to organize the match',
                      forceDialogOpen: true)
                      .then((value) => Get.back());
                  return;
                }
                if (roundController.text.isEmpty) {
                  errorSnackBar('Please select a round', forceDialogOpen: true);
                  return;
                }
                Get.back();
                Get.to(
                      () => SelectOrganizeTeam(
                    tournament: widget.tournament,
                    round: roundController.text,
                  ),
                );
              },
              title: 'Continue',
            )
          ],
        ),
      ),
    );
  }
}