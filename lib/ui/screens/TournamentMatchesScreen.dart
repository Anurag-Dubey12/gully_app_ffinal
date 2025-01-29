import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/controller/tournament_controller.dart';
import '../../data/model/matchup_model.dart';
import '../widgets/TournamentMatchCard.dart';

class TournamentMatchesScreen extends GetView<TournamentController> {
  final String tournamentId;

  const TournamentMatchesScreen({Key? key, required this.tournamentId}) : super(key: key);

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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Tournament Matches',
            style: Get.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          leading: const BackButton(color: Colors.white),
        ),
        body: FutureBuilder<List<MatchupModel>>(
          future: controller.getTournamentMatches(tournamentId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No matches found for this tournament.'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final match = snapshot.data![index];
                return TournamentMatchCard(match: match);
              },
            );
          },
        ),
      ),
    );
  }
}
