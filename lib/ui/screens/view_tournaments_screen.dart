import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/screens/home_screen.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';

class ViewTournamentScreen extends StatelessWidget {
  const ViewTournamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBuilder(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'View your\nTournaments',
          textAlign: TextAlign.center,
          style: Get.textTheme.headlineLarge
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: GestureDetector(
          onTap: () {
            Get.to(() => const HomeScreen());
          },
          child: const Column(
            children: [
              _TourCard(),
              SizedBox(height: 22),
              _TourCard(),
              SizedBox(height: 22),
              _TourCard(),
              SizedBox(height: 22),
              _TourCard()
            ],
          ),
        ),
      ),
    ));
  }
}

class _TourCard extends StatelessWidget {
  const _TourCard();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      style: ListTileStyle.drawer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      tileColor: Colors.white,
      contentPadding: const EdgeInsets.all(12),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Jogeshwari Mitra Mandal',
              style: Get.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          Text('Jogeshwari Stadium',
              style: Get.textTheme.bodySmall
                  ?.copyWith(color: Colors.grey.shade400)),
        ],
      ),
      trailing: const Chip(
          padding: EdgeInsets.zero,
          label: Text('Cancel',
              style: TextStyle(color: Colors.white, fontSize: 12)),
          backgroundColor: Colors.red,
          side: BorderSide.none),
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade400,
        radius: 32,
      ),
    );
  }
}
