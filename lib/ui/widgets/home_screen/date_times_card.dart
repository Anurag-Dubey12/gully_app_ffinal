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
    double itemWidth = 109;
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
      final controller = Get.find<TournamentController>();
      controller.setSelectedDate(DateTime.now());
      controller.getTournamentList();
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
            if (index == dateTimes.length) {
              return SizedBox(
                child: GestureDetector(
                  onTap: () async {
                    final res = await showDatePicker(
                        context: context,
                        helpText: 'Select Tournament Date',
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 90)),
                        lastDate: DateTime.now().add(const Duration(days: 90)));
                    if (res != null) {
                      controller.setSelectedDate(res);
                      controller.getTournamentList();
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade100,
                    child: Icon(
                      Icons.calendar_month,
                      color: Colors.amber.shade500,
                    ),
                  ),
                ),
              );
            }
            return GestureDetector(
                onTap: () {
                  controller.setSelectedDate(dateTimes[index]);
                  controller.getTournamentList();
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
          itemCount: dateTimes.length + 1),
    );
  }
}
