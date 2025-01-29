import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/ui/screens/schedule_screen.dart';
import 'package:gully_app/ui/screens/team_players_list.dart';

import '../../data/controller/misc_controller.dart';
import '../../utils/FallbackImageProvider.dart';
import '../../utils/utils.dart';
import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';
import '../widgets/gradient_builder.dart';
import 'opponent_tournament_list.dart';

class TournamentTeams extends GetView<TournamentController> {
  final TournamentModel tournament;
  final bool isTeamListOnly;

  const TournamentTeams({
    super.key,
    required this.tournament,
    this.isTeamListOnly = false
  });

  @override
  Widget build(BuildContext context) {

    if (isTeamListOnly) {
      return DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/images/sports_icon.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: GradientBuilder(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const BackButton(color: Colors.white),
              title: const Text(
                'Tournament Teams',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            body: registeredTeamsView(),
          ),
        ),
      );
    }
    return DefaultTabController(
      length: 2,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/images/sports_icon.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: GradientBuilder(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const BackButton(color: Colors.white),
              title: const Text(
                'Tournament Info',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              bottom: const TabBar(
                indicatorColor: AppTheme.primaryColor,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                tabs: [
                  Tab(text: 'Register Teams'),
                  Tab(text: 'Matches'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                registeredTeamsView(),
                matchups()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget registeredTeamsView() {
    final MiscController connectionController=Get.find<MiscController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.07, vertical: 10),
      child: !connectionController.isConnected.value ? Center(
        child: SizedBox(
          width: Get.width,
          height: Get.height,
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
      ):FutureBuilder<List<TeamModel>>(
        future: controller.getRegisteredTeams(tournament.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data?.isEmpty ?? true) {
            return const Center(
              child: Text(
                'No teams have registered for this tournament yet.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 18),
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              return _Card(team: snapshot.data![index]);
            },
          );
        },
      ),
    );
  }

  Widget matchups() {
    final MiscController connectionController=Get.find<MiscController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
      child: !connectionController.isConnected.value ? Center(
        child: SizedBox(
          width: Get.width,
          height: Get.height,
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
      ):FutureBuilder(
          future: tournament.id !=null ? controller.getMatchup(tournament.id): controller.getMatchup(controller.state!.id),
          builder: (context, snapshot) {
            if (snapshot.data?.isEmpty ?? true) {
              return const Center(
                  child: EmptyTournamentWidget(
                      message: 'No Matchups Found'));
            } else {
              return ListView.separated(
                itemCount: snapshot.data?.length ?? 0,
                shrinkWrap: true,
                separatorBuilder: (context, index) =>
                    SizedBox(height: Get.height * 0.01),
                itemBuilder: (context, index) => MatchupCard(
                  matchup: snapshot.data![index],
                ),
              );
            }
          }),
    );
  }
}

//Register team Card View
class _Card extends StatelessWidget {
  final TeamModel team;

  const _Card({required this.team});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ViewTeamPlayers(teamModel: team));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                  radius: 24,
                  backgroundImage: FallbackImageProvider(
                      toImageUrl(team.logo ?? ""),
                      'assets/images/logo.png'
                  )),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  team.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}