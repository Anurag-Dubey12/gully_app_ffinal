import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/theme.dart';

class DrawerCard extends StatefulWidget {
  final String title;
  final Widget? child;
  final IconData icon;
  final Function? onTap;
  const DrawerCard({
    super.key,
    required this.title,
    this.child,
    required this.icon,
    this.onTap,
  });

  @override
  State<DrawerCard> createState() => _DrawerCardState();
}

class _DrawerCardState extends State<DrawerCard> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key(widget.title),
      children: [
        ListTile(
          onTap: () {
            if (widget.child == null) {
              widget.onTap!();
            } else {
              setState(() {
                isExpanded = !isExpanded;
              });
            }
          },
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppTheme.secondaryYellowColor,
            ),
            child: Icon(widget.icon, color: Colors.white, size: 26),
          ),
          title: Row(
            children: [
              Text(
                widget.title,
                style: Get.textTheme.labelMedium?.copyWith(
                    color: const Color.fromARGB(255, 244, 244, 244),
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
              const Spacer(),
              if (widget.child != null)
                const RotatedBox(
                    quarterTurns: 3,
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 15,
                      color: Colors.white,
                    ))
            ],
          ),
          minVerticalPadding: 10,
        ),
        isExpanded ? widget.child! : const SizedBox()
      ],
    );
  }
}
