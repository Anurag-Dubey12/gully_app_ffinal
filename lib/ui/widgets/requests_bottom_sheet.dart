import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/data/model/tournament_model.dart';

import '../../data/controller/tournament_controller.dart';

class RequestsBottomSheet extends StatefulWidget {
  final TournamentModel tournament;
  const RequestsBottomSheet({
    super.key,
    required this.tournament,
  });

  @override
  State<RequestsBottomSheet> createState() => _RequestsBottomSheetState();
}

class _RequestsBottomSheetState extends State<RequestsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    return SizedBox(
      width: double.infinity,
      height: Get.height / .7,
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

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<List<TeamModel>>(
                    future: controller.getTeamRequests(widget.tournament.id),
                    builder: (context, snapshot) {
                      if (snapshot.data?.isEmpty ?? true) {
                        return const Center(
                          child: Text('No Requests'),
                        );
                      }
                      return ListView.separated(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length ?? 0,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            return Container(
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
                                          widget.tournament.id,
                                          snapshot.data![index].id,
                                          'Accepted');
                                      setState(() {
                                        widget.tournament.pendingTeamsCount--;
                                      });
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
                                          widget.tournament.id,
                                          snapshot.data![index].id,
                                          'Denied');
                                      setState(() {
                                        widget.tournament.pendingTeamsCount--;
                                      });
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
                            );
                          });
                    }),
              ),
            )
          ],
        ),
    );
  }
}
