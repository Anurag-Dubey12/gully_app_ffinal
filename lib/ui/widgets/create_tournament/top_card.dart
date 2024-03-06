import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'select_from_to_card.dart';

class TopCard extends StatefulWidget {
  final Function onFromChanged;
  final Function onToChanged;
  final DateTime? from;
  final DateTime? to;
  final TextEditingController controller;

  const TopCard(
      {super.key,
      required this.controller,
      required this.onFromChanged,
      required this.onToChanged,
      this.from,
      this.to});

  @override
  State<TopCard> createState() => _TopCardState();
}

class _TopCardState extends State<TopCard> {
  DateTime? from;
  DateTime? to;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectFromToCard(
              onFromChanged: (e) {
                setState(
                  () {
                    setState(() {
                      from = e;
                      widget.onFromChanged(e);
                    });
                  },
                );
              },
              from: widget.from,
              to: widget.to,
              onToChanged: (e) {
                setState(() {
                  to = e;
                  widget.onToChanged(e);
                });
              },
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
