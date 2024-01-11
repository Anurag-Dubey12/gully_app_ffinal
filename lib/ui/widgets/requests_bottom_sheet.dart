import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/team_model.dart';

import '../../data/controller/tournament_controller.dart';
import '../screens/current_tournament_list.dart';

class RequestsBottomSheet extends StatelessWidget {
  final String tournamentId;
  const RequestsBottomSheet({
    super.key,
    required this.tournamentId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    return SizedBox(
      width: double.infinity,
      height: Get.height / .7,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 7,
                width: 120,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Row(
                children: [
                  Text('Requests',
                      style: Get.textTheme.titleLarge?.copyWith(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.person_add_alt_sharp),
                  )
                ],
              ),
            ),

            // Create a container with 4 items in row -->  circle avatar with name and two icons in trailing

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<TeamModel>>(
                  future: controller.getTeamRequests(tournamentId),
                  builder: (context, snapshot) {
                    return ListView.separated(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length ?? 0,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.to(() => const CurrentTournamentListScreen(
                                  redirectType: RedirectType.organizeMatch));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xffE9E7EF),
                                  borderRadius: BorderRadius.circular(19)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        snapshot.data![index].toImageUrl()),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    snapshot.data![index].name,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      await controller.updateTeamRequest(
                                          tournamentId,
                                          snapshot.data![index].id,
                                          'Accepted');
                                    },
                                    child: const CircleAvatar(
                                      radius: 13,
                                      backgroundColor:
                                          Color.fromARGB(255, 71, 224, 79),
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () async {
                                      await controller.updateTeamRequest(
                                          tournamentId,
                                          snapshot.data![index].id,
                                          'Denied');
                                    },
                                    child: const CircleAvatar(
                                      radius: 13,
                                      backgroundColor:
                                          Color.fromARGB(255, 235, 17, 24),
                                      child: Icon(Icons.person_off),
                                    ),
                                  )
                                ]),
                              ),
                            ),
                          );
                        });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
