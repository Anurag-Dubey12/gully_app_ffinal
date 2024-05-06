import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/team_controller.dart';
import 'package:gully_app/data/model/opponent_model.dart';
import 'package:gully_app/ui/screens/opponent_team_list.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';

import '../../data/controller/tournament_controller.dart';

class OpponentTournamentsScreen extends StatefulWidget {
  final bool opponentView;
  const OpponentTournamentsScreen({super.key, this.opponentView = false});

  @override
  State<OpponentTournamentsScreen> createState() =>
      _OpponentTournamentsScreenState();
}

class _OpponentTournamentsScreenState extends State<OpponentTournamentsScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();
    return GradientBuilder(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: AppTheme.primaryColor,
              elevation: 0,
              // toolbarHeight: 100,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                widget.opponentView ? 'Select Tournament' : 'Your Tournaments',
                textAlign: TextAlign.center,
                style: Get.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 24),
              ),
            ),
            body: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(children: [
                  Expanded(
                    child: FutureBuilder<List<OpponentModel>>(
                        future: controller.getOpponents(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text(snapshot.error.toString(),
                                    style: Get.textTheme.bodyLarge
                                        ?.copyWith(color: Colors.red)));
                          }
                          if (snapshot.data == null || snapshot.data!.isEmpty) {
                            return const EmptyTournamentWidget();
                          }
                          return ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 18),
                              shrinkWrap: true,
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                return _TourCard(
                                    snapshot.data!.elementAt(index), () {
                                  setState(() {});
                                }
                                    // tournament: snapshot.data![index],
                                    // redirectType: redirectType,
                                    );
                              });
                        }),
                  )
                ]))));
  }
}

class EmptyTournamentWidget extends StatelessWidget {
  final String? message;
  const EmptyTournamentWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const Image(
          image: AssetImage('assets/images/cricketer.png'),
          height: 230,
        ),
        SizedBox(height: Get.height * 0.02),
        Text(message ?? 'You have no tournaments yet',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    ));
  }
}

class _TourCard extends GetView<TournamentController> {
  final OpponentModel opponentModel;
  final Function onCancel;
  const _TourCard(this.opponentModel, this.onCancel);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      style: ListTileStyle.drawer,
      onTap: () {
        // Get.to(() => TournamentTeams(tournament: opponentModel));
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      tileColor: Colors.white,
      contentPadding: const EdgeInsets.all(12),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(opponentModel.tournamentName,
              style: Get.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          // Text(opponentModel.stadiumAddress,
          //     style: Get.textTheme.bodySmall
          //         ?.copyWith(color: Colors.grey.shade600)),
        ],
      ),
      trailing: GestureDetector(
        onTap: () async {
          Get.to(() => ViewOpponentTeamList(
                opponent: opponentModel,
              ));
        },
        child: const Chip(
            iconTheme: IconThemeData(color: Colors.white),
            padding: EdgeInsets.zero,
            label: Text('View Opponents',
                style: TextStyle(color: Colors.white, fontSize: 12)),
            backgroundColor: AppTheme.darkYellowColor,
            side: BorderSide.none),
      ),
    );
  }
}
