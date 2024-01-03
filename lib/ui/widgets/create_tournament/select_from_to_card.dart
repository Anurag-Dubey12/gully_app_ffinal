import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../theme/theme.dart';

class SelectFromToCard extends StatelessWidget {
  final DateTime? from;
  final DateTime? to;
  final Function onFromChanged;
  final Function onToChanged;
  const SelectFromToCard(
      {super.key,
      required this.from,
      required this.to,
      required this.onFromChanged,
      required this.onToChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Text('From'),
              ),
              GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 4)),
                      firstDate: DateTime.now().add(const Duration(days: 4)),
                      lastDate: DateTime.now().add(const Duration(days: 365)));
                  if (date != null) {
                    onFromChanged(date);
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 33,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey[200]),
                      child: Center(
                          child: Text(
                        from != null
                            ? DateFormat('dd/MM/yyyy').format(from!)
                            : "",
                        style: Get.textTheme.labelMedium,
                      )),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.calendar_month,
                      size: 18,
                      color: AppTheme.secondaryYellowColor,
                    )
                  ],
                ),
              )
            ],
          ),
          const Spacer(),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              final date0 = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 4)),
                  firstDate: DateTime.now().add(const Duration(days: 4)),
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
                  child: Text(
                    'To',
                    style: Get.textTheme.labelLarge,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 33,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey[200]),
                      child: Center(
                          child: Text(
                        to != null ? DateFormat('dd/MM/yyyy').format(to!) : "",
                        style: Get.textTheme.labelMedium,
                      )),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Icon(
                      Icons.calendar_month,
                      size: 18,
                      color: AppTheme.secondaryYellowColor,
                    )
                  ],
                )
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
