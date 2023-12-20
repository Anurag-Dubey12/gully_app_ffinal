import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/controller/tournament_controller.dart';
import '../../../utils/date_time_helpers.dart';
import 'time_card.dart';

class DateTimesCard extends StatefulWidget {
  const DateTimesCard({super.key});

  @override
  State<DateTimesCard> createState() => _DateTimesCardState();
}

class _DateTimesCardState extends State<DateTimesCard> {
  ScrollController scrollController = ScrollController();
  final dateTimes = getDateList();
  void scrollToCenter() {
    // Assuming each item and separator in the list has a fixed width
    double itemWidth = 135;
    double screenWidth = MediaQuery.of(context).size.width;
    double centerPosition = (dateTimes.length * itemWidth - screenWidth) / 2;
    scrollController.animateTo(
      centerPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();

    // Schedule a callback to scroll the list after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToCenter();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    return SizedBox(
      height: Get.height * 0.05,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          controller: scrollController,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  controller.setSelectedDate(dateTimes[index]);
                },
                child: Obx(
                  () => TimeCard(
                    isSelected: areDatesEqual(
                        dateTimes[index], controller.selectedDate.value),
                    title: getDayName(dateTimes[index]),
                  ),
                ));
          },
          padding: const EdgeInsets.only(left: 20),
          itemCount: dateTimes.length),
    );
  }
}
