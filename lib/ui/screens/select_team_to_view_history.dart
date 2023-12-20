import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/screens/player_performance.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';

class SelectTeamToViewHistory extends StatefulWidget {
  const SelectTeamToViewHistory({super.key});

  @override
  State<SelectTeamToViewHistory> createState() =>
      _SelectTeamToViewHistoryState();
}

class _SelectTeamToViewHistoryState extends State<SelectTeamToViewHistory> {
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
        child: GradientBuilder(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  'Select Team',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const BackButton()),
            body: Container(
              width: Get.width,
              // height: Get.height * 0.54,
              margin: const EdgeInsets.only(top: 10),
              color: Colors.black26,
              child: const Padding(
                padding: EdgeInsets.all(18.0),
                child: Column(
                  children: [_TeamCard(), SizedBox(height: 20), _TeamCard()],
                ),
              ),
            ),
          ),
        ));
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => const PlayerPerformance()),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: const Padding(
          padding: EdgeInsets.all(18.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CSK vs RCB',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '20th April 2021',
                    style: TextStyle(
                        fontSize: 13, color: Color.fromARGB(255, 255, 154, 22)),
                  ),
                ],
              ),
              Spacer(),
              Text('Premier League',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400))
            ],
          ),
        ),
      ),
    );
  }
}
