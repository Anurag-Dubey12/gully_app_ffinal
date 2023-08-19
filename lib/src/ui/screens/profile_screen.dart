import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/current_tournament_list.dart';
import 'package:gully_app/src/ui/screens/edit_tournament_screen.dart';
import 'package:gully_app/src/ui/screens/notification_screen.dart';
import 'package:gully_app/src/ui/screens/organize_match.dart';
import 'package:gully_app/src/ui/screens/score_card.dart';
import 'package:gully_app/src/ui/screens/select_opening_players.dart';
import 'package:gully_app/src/ui/screens/select_opening_team.dart';
import 'package:gully_app/src/ui/screens/txn_history_screen.dart';
import 'package:gully_app/src/ui/screens/view_matchups_screen.dart';
import 'package:gully_app/src/ui/screens/view_tournaments_screen.dart';
import 'package:gully_app/src/ui/theme/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage(
                'assets/images/sports_icon.png',
              ),
              fit: BoxFit.cover),
        ),
        child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff3F5BBF), Colors.white24, Colors.white24],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(children: [
                AppBar(
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: const Text(
                    'Profile',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://staticg.sportskeeda.com/editor/2018/08/16a4f-1534264896-800.jpg'),
                                fit: BoxFit.contain))),

                    // backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey[900]),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mail,
                          color: Colors.grey[900],
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'kohli239@gmail.com',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey[800]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.grey[900],
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '304/c, S.V. Road, Kandivali East',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey[800]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.grey[900],
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '9855453210',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey[800]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.black26),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            InkWell(
                              child: ProfileTileCard(
                                onTap: () {
                                  Get.bottomSheet(BottomSheet(
                                    enableDrag: false,
                                    builder: (context) =>
                                        const RequestsBottomSheet(),
                                    onClosing: () {},
                                  ));
                                },
                                text: 'Request',
                                subTrailingWidget:
                                    Text('3', style: Get.textTheme.bodyLarge),
                              ),
                            ),
                            ProfileTileCard(
                              text: 'Current Tournament',
                              onTap: () {
                                Get.to(
                                    () => const CurrentTournamentListScreen());
                              },
                              subTrailingWidget:
                                  Text('2/13', style: Get.textTheme.bodyLarge),
                            ),
                            ProfileTileCard(
                              text: 'Organize',
                              onTap: () {
                                Get.to(() => const SelectOrganizeTeam());
                              },
                            ),
                            ProfileTileCard(
                              text: 'View Matchups',
                              onTap: () {
                                Get.to(() => const ViewMatchupsScreen());
                              },
                            ),
                            ProfileTileCard(
                              text: 'Score Board',
                              onTap: () {
                                Get.to(() => const SelectOpeningPlayer());
                              },
                            ),
                            ProfileTileCard(
                              text: 'Edit Tournament Form',
                              onTap: () {
                                Get.to(() => EditTournamentScreen());
                              },
                            ),
                            ProfileTileCard(
                              text: 'Transaction History',
                              onTap: () {
                                Get.to(() => const TxnHistoryScreen());
                              },
                            ),
                            ProfileTileCard(
                              text: 'View your tournament',
                              onTap: () {
                                Get.to(() => const ViewTournamentScreen());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ]),
            )));
  }
}

class ProfileTileCard extends StatelessWidget {
  final String text;
  final Widget? subTrailingWidget;
  final Function? onTap;
  const ProfileTileCard({
    super.key,
    required this.text,
    this.subTrailingWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? () {} : () => onTap!(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.secondaryYellowColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Text(text, style: Get.textTheme.bodyLarge),
              const Spacer(),
              subTrailingWidget ?? const SizedBox(),
              const Icon(
                Icons.arrow_forward_ios,
                size: 19,
                color: AppTheme.secondaryYellowColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RequestsBottomSheet extends StatefulWidget {
  const RequestsBottomSheet({
    super.key,
  });

  @override
  State<RequestsBottomSheet> createState() => _RequestsBottomSheetState();
}

class _RequestsBottomSheetState extends State<RequestsBottomSheet> {
  var textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: 4,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemBuilder: (context, snapshot) {
                    return InkWell(
                      onTap: () {
                        Get.to(() => const CurrentTournamentListScreen());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xffE9E7EF),
                            borderRadius: BorderRadius.circular(19)),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(children: [
                            CircleAvatar(),
                            SizedBox(width: 10),
                            Text(
                              'Bob Odenkirk',
                              style: TextStyle(fontSize: 18),
                            ),
                            Spacer(),
                            CircleAvatar(
                              radius: 13,
                              backgroundColor: Color.fromARGB(255, 71, 224, 79),
                              child: Icon(Icons.add),
                            ),
                            SizedBox(width: 10),
                            CircleAvatar(
                              radius: 13,
                              backgroundColor: Color.fromARGB(255, 235, 17, 24),
                              child: Icon(Icons.person_off),
                            )
                          ]),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
