import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/extras_model.dart';
import 'package:gully_app/data/model/player_model.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/ui/screens/score_card_screen.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/utils/utils.dart';

import '../../data/controller/scoreboard_controller.dart';

class SelectOpeningPlayer extends StatefulWidget {

  const SelectOpeningPlayer({Key? key}) : super(key: key);

  @override
  State<SelectOpeningPlayer> createState() => _SelectOpeningPlayerState();
}

class _SelectOpeningPlayerState extends State<SelectOpeningPlayer> {
  PlayerModel? striker;
  PlayerModel? nonStriker;
  PlayerModel? openingBowler;


  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScoreBoardController>();
    final TournamentController tournamentController=Get.find<TournamentController>();
    return GradientBuilder(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text('Select Opening Players',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 24)),
          ),
          body: Obx((){
            final battingTeam=tournamentController.battingTeam.value;
            final bowlingTeam=tournamentController.bowlingTeam.value;
            final match=tournamentController.currentMatch.value;
            if(battingTeam==null || bowlingTeam ==null ||match==null){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Striker',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  PlayerDropDownWidget(
                    title: 'Select Striker',
                    onSelect: (e) {
                      setState(() {
                        if (e.id == nonStriker?.id) {
                          errorSnackBar('Striker and Non Striker cannot be same');
                          return;
                        }
                        striker = e;
                      });
                      Get.close();
                    },
                    selectedValue: striker?.name,
                    selectedPlayerId: striker?.id,
                    items: battingTeam.players!,
                  ),
                  const SizedBox(height: 20),
                  const Text('Non-Striker',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  PlayerDropDownWidget(
                    title: 'Select Non Striker',
                    onSelect: (e) {
                      setState(() {
                        if (e.id == striker?.id) {
                          errorSnackBar('Striker and Non Striker cannot be same');
                          return;
                        }
                        nonStriker = e;
                      });
                      Get.close();
                    },
                    selectedValue: nonStriker?.name,
                    selectedPlayerId: nonStriker?.id,
                    items: battingTeam.players!,
                  ),
                  const SizedBox(height: 20),
                  const Text('Opening Bowler',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  PlayerDropDownWidget(
                    title: 'Select Opening Bowler',
                    onSelect: (e) {
                      setState(() {
                        openingBowler = e;
                      });
                      Get.close();
                    },
                    selectedValue: openingBowler?.name,
                    selectedPlayerId: openingBowler?.id,
                    items: bowlingTeam.players!,
                  ),
                  const SizedBox(height: 20),
                  const Spacer(),
                  PrimaryButton(
                    onTap: () {
                      if (striker == null) {
                        errorSnackBar('Please select striker');
                        return;
                      }
                      if (nonStriker == null) {
                        errorSnackBar('Please select non striker');
                        return;
                      }
                      if (openingBowler == null) {
                        errorSnackBar('Please select opening bowler');
                        return;
                      }
                      errorSnackBar("Player id are :");
                      controller.createScoreBoard(
                        team1: TeamModel.fromJson(battingTeam.toJson()),
                        team2: TeamModel.fromJson(bowlingTeam.toJson()),
                        matchId: tournamentController.currentMatch.value!.id,
                        extras: match.scoreBoard?['extras'] ??
                            ExtraModel(
                                wides: 0,
                                noBalls: 0,
                                byes: 0,
                                legByes: 0,
                                penalty: 0),
                        tossWonBy: tournamentController.tossWonBy.value,
                        electedTo: tournamentController.electedTo.value,
                        overs: tournamentController.overs.value,
                        strikerId: striker!.id,
                        nonStrikerId: nonStriker!.id,
                        openingBowler: openingBowler!.id,
                      );
                      Get.off(() => const ScoreCardScreen());
                    },
                    title: 'Start Match',
                  )
                ],
              ),
            );
          })

        ));
  }
}


class PlayerDropDownWidget extends StatelessWidget {
  final Function(PlayerModel player) onSelect;
  final String? selectedValue;
  final String? selectedPlayerId;
  final List<PlayerModel> items;
  final String title;
  const PlayerDropDownWidget({
    super.key,
    required this.onSelect,
    this.selectedValue,
    this.selectedPlayerId,
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
                      // height: Get.height * 0.31,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9)),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                title,
                                style: Get.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Radio(
                                          value: items[index].id,
                                          groupValue: selectedPlayerId,
                                          onChanged: (e) {
                                            onSelect(items[index]);
                                          }),
                                      title: Text(items[index].name),
                                      trailing: Image.asset(
                                        getAssetFromRole(items[index].role),
                                        width: 20,
                                      ),
                                    );
                                  }),
                            ),
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
