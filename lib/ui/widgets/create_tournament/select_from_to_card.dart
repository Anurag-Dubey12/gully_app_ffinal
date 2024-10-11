import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:intl/intl.dart';

import '../../theme/theme.dart';

class SelectFromToCard extends StatelessWidget {
  final DateTime? from;
  final DateTime? to;
  final Function onFromChanged;
  final Function onToChanged;
  final bool isAds;
  final bool iswhite;
  const SelectFromToCard(
      {super.key,
        required this.from,
        required this.to,
        required this.onFromChanged,
        required this.onToChanged,
        required this.isAds,
        this.iswhite=false
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text('From',
                      style: Get.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: iswhite?Colors.white :Colors.black,
                          fontSize: 16)),
                ),
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                        context: context,
                        initialDate:
                        isAds ? DateTime.now():
                        DateTime.now().add(const Duration(days: 4)),
                        firstDate: isAds ? DateTime.now():DateTime.now().add(const Duration(days: 4)),
                        lastDate: DateTime.now().add(const Duration(days: 365)));
                    if (date != null) {
                      logger.d('Date: $date');
                      onFromChanged(date);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 36,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey[100]),
                          child: Center(
                              child: Text(
                                from != null
                                    ? DateFormat('dd/MM/yyyy').format(from!)
                                    : "",
                                style: Get.textTheme.labelMedium,
                              )),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.calendar_month,
                          size: 18,
                          color: AppTheme.secondaryYellowColor,
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final date0 = await showDatePicker(
                    context: context,
                    initialDate: isAds ? DateTime.now() : DateTime.now().add(const Duration(days: 4)),
                    firstDate: isAds ? DateTime.now() : DateTime.now().add(const Duration(days: 4)),
                    lastDate: DateTime.now().add(const Duration(days: 365)));
                if (date0 != null) {
                  onToChanged(date0);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('To',
                        style: Get.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: iswhite ?Colors.white:Colors.black,
                            fontSize: 16)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 36,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey[100]),
                          child: Center(
                              child: Text(
                                to != null
                                    ? DateFormat('dd/MM/yyyy').format(to!)
                                    : "",
                                style: Get.textTheme.labelMedium,
                              )),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.calendar_month,
                          size: 18,
                          color: AppTheme.secondaryYellowColor,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}