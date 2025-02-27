import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/controller/tournament_controller.dart';
import '../../data/model/points_table_model.dart';
import '../../data/model/tournament_model.dart';

class PointsTable extends StatelessWidget {
  final TournamentModel? tournament;
  const PointsTable(
      {super.key, required this.tournament});

  @override
  Widget build(BuildContext context) {
    final TournamentController controller = Get.find<TournamentController>();
    return Scaffold(
      appBar: AppBar(
        title: Text("${tournament?.tournamentName.capitalize} Points Table",
            style: const TextStyle(fontSize: 18, color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<PointTableModel>>(
        future: controller.tournamentPointsTable(tournament!.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: Get.width,
              child: Column(
                children: [
                  Container(
                    color: Colors.black,
                    padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tableHeader('POS', flex: 2),
                        tableHeader('Team', flex: 4),
                        tableHeader('Played', flex: 2),
                        tableHeader('Win', flex: 2),
                        tableHeader('Loss', flex: 2),
                        tableHeader('Ties', flex: 2),
                        tableHeader('Points', flex: 2),
                        tableHeader('NRR', flex: 2),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() => ListView.builder(
                      itemCount: controller.points_table.length,
                      itemBuilder: (context, index) {
                        final team = controller.points_table[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 5),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              teamTableData(team.rank.toString(), flex: 2),
                              const SizedBox(
                                width: 2,
                              ),
                              teamData(team, flex: 4),
                              teamTableData(team.matchesPlayed.toString(), flex: 2),
                              teamTableData(team.wins.toString(), flex: 2),
                              teamTableData(team.losses.toString(), flex: 2),
                              teamTableData(team.ties.toString(), flex: 2),
                              teamTableData(team.points.toString(), flex: 2),
                              teamTableData(team.netRunRate.toString(),flex: 2),
                            ],
                          ),
                        );
                      },
                    )),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


}
Widget tableHeader(String text, {required int flex}) {
  return Expanded(
    flex: flex,
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 10,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget teamTableData(String text, {required int flex}) {
  return Expanded(
    flex: flex,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
      textAlign: TextAlign.center,
    ),
  );
}
Widget teamData(PointTableModel team, {required int flex}) {
  return Expanded(
    flex: flex,
    child: Text(
      team.teamName.capitalize,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      textAlign: TextAlign.start,
    ),
  );
}
