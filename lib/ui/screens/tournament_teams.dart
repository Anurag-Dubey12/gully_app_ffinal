import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/ui/screens/team_players_list.dart';
import 'package:gully_app/ui/screens/view_tournaments_screen.dart';

import '../../utils/FallbackImageProvider.dart';
import '../../utils/utils.dart';
import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';

class TournamentTeams extends GetView<TournamentController> {
  final TournamentModel tournament;
  const TournamentTeams({
    super.key,
    required this.tournament,
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
        body: Stack(
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
                        color: AppTheme.secondaryYellowColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 70),
                      )
                    ],
                  ),
                  width: double.infinity,
                  height: Get.height * 1.5,
                ),
              ),
              Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text(
                      'Registered Teams',
                      style: Get.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    leading: const BackButton(color: Colors.white),
                  ),
                  SizedBox(height: Get.height * 0.07),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.07),
                      child: FutureBuilder<List<TeamModel>>(
                        future: controller.getRegisteredTeams(tournament.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.data?.isEmpty ?? true) {
                            return const EmptyTournamentWidget(
                              message: 'No teams have registered for this tournament yet',
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
                    ),
                  ),
                  const SizedBox(height:20)
                ],
              ),
            ],
          ),
        ),
    );
  }
}

class _Card extends GetView<TournamentController> {
  final TeamModel team;

  const _Card({
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ViewTeamPlayers(
          teamModel: team,
          // tournament: tournament,
        ));
      },
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, 1))
            ],
            borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.05,
            vertical: Get.height * 0.02,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage:team.toImageUrl().isNotEmpty && team.toImageUrl() !=null ?
                FallbackImageProvider(
                    toImageUrl(team.logo ?? "assets/images/logo.png"),
                    'assets/images/logo.png'
                ) as ImageProvider
                    : const AssetImage('assets/images/logo.png'),
              ),
              const Spacer(),
              Text(
                team.name,
                style: Get.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600, fontSize: 19),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}