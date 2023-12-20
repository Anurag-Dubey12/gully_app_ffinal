import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:intl/intl.dart';

import 'select_from_to_card.dart';

class TopCard extends StatefulWidget {
  final Function onFromChanged;
  final Function onToChanged;
  final TextEditingController controller;
  final TextEditingController fromController;
  final TextEditingController toController;
  const TopCard(
      {super.key,
      required this.controller,
      required this.fromController,
      required this.toController,
      required this.onFromChanged,
      required this.onToChanged});

  @override
  State<TopCard> createState() => _TopCardState();
}

class _TopCardState extends State<TopCard> {
  DateTime? from;
  DateTime? to;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 1))
          ],
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 13),
                  child: TextField(
                    controller: widget.controller,
                    style: Get.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        hintText: 'Tournament Name',
                        hintStyle: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade400,
                        ),
                        border: InputBorder.none),
                  ),
                ),
              ),
            ),
            SelectFromToCard(
              onFromChanged: (e) {
                setState(
                  () {
                    logger.i("76");

                    setState(() {
                      from = e;
                      widget.fromController.text =
                          DateFormat('dd-MM-yy').format(e);
                      widget.onFromChanged(e);
                    });
                    logger.i("86");
                  },
                );
              },
              from: from,
              to: to,
              onToChanged: (e) {
                setState(() {
                  to = e;
                  widget.onToChanged(e);
                  widget.toController.text = DateFormat('dd-MM-yy').format(e);
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
