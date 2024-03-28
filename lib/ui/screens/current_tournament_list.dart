import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/ui/screens/organize_match.dart';
import 'package:gully_app/ui/screens/select_team_for_scoreboard.dart';
import 'package:gully_app/ui/screens/tournament_form_screen.dart';
import 'package:gully_app/ui/screens/tournament_teams.dart';
import 'package:gully_app/ui/screens/update_authority_screen.dart';
import 'package:gully_app/ui/screens/view_matchups_screen.dart';
import 'package:gully_app/ui/screens/view_tournaments_screen.dart';
import 'package:gully_app/ui/widgets/custom_text_field.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';

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
  final roundController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();

    return GestureDetector(
      onTap: () {
        switch (widget.redirectType) {
          case RedirectType.organizeMatch:
            Get.dialog(
              Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        labelText:
                            AppLocalizations.of(context)!.enterRoundNumberLabel,
                        textInputType: TextInputType.number,
                        controller: roundController,
                        autoFocus: true,
                      ),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        onTap: () {
                          Get.back();
                          Get.to(
                            () => SelectOrganizeTeam(
                              tournament: widget.tournament,
                              round: int.parse(roundController.text),
                            ),
                          );
                        },
                        title: 'Continue',
                      )
                    ],
                  ),
                ),
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
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
