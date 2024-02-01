import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/ui/screens/tournament_teams.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/date_time_helpers.dart';

import '../../data/controller/tournament_controller.dart';

class ViewTournamentScreen extends StatefulWidget {
  const ViewTournamentScreen({super.key});

  @override
  State<ViewTournamentScreen> createState() => _ViewTournamentScreenState();
}

class _ViewTournamentScreenState extends State<ViewTournamentScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    return GradientBuilder(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // toolbarHeight: 100,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Your Tournaments',
          textAlign: TextAlign.center,
          style: Get.textTheme.headlineLarge?.copyWith(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            Obx(() {
              if (controller.organizerTournamentList.isEmpty) {
                return const EmptyTournamentWidget();
              }

              return ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 18),
                  shrinkWrap: true,
                  itemCount: controller.organizerTournamentList.length,
                  itemBuilder: (context, index) {
                    return _TourCard(controller.organizerTournamentList[index],
                        () {
                      setState(() {});
                    }
                        // tournament: snapshot.data![index],
                        // redirectType: redirectType,
                        );
                  });
            }),
          ],
        ),
      ),
    ));
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
  final TournamentModel tournament;
  final Function onCancel;
  const _TourCard(this.tournament, this.onCancel);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      style: ListTileStyle.drawer,
      onTap: () {
        Get.to(() => TournamentTeams(tournament: tournament));
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      tileColor: Colors.white,
      contentPadding: const EdgeInsets.all(12),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tournament.tournamentName,
              style: Get.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          Text(tournament.stadiumAddress,
              style: Get.textTheme.bodySmall
                  ?.copyWith(color: Colors.grey.shade600)),
          SizedBox(height: Get.height * 0.01),
          Row(
            children: [
              const Icon(Icons.calendar_month,
                  color: AppTheme.secondaryYellowColor, size: 16),
              const SizedBox(width: 8),
              Text(
                  formatDateTime(
                      'dd.MMM.yyyy', tournament.tournamentStartDateTime),
                  style: Get.textTheme.bodySmall
                      ?.copyWith(color: Colors.grey.shade800)),
            ],
          ),
        ],
      ),
      trailing: GestureDetector(
        onTap: () async {
          Get.dialog(AlertDialog.adaptive(
            title: const Text('Cancel Tournament'),
            content:
                const Text('Are you sure you want to cancel this tournament?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('No')),
              TextButton(
                  onPressed: () async {
                    await controller.cancelTournament(tournament.id);
                    onCancel();
                    Get.back();
                  },
                  child: const Text('Yes')),
            ],
          ));
          // await controller.cancelTournament(tournament.id);
          // onCancel();
        },
        child: const Chip(
            iconTheme: IconThemeData(color: Colors.white),
            padding: EdgeInsets.zero,
            label: Text('Cancel',
                style: TextStyle(color: Colors.white, fontSize: 12)),
            backgroundColor: Colors.red,
            side: BorderSide.none),
      ),
    );
  }
}
