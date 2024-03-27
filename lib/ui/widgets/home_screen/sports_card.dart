import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class SportsCard extends StatelessWidget {
  final int index;
  const SportsCard({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        width: 60,
        decoration: BoxDecoration(
          color: index == 0
              ? const Color.fromARGB(255, 255, 157, 46)
              : Colors.white,
          borderRadius: BorderRadius.circular(21),
          boxShadow: [
            BoxShadow(
                color: index == 0
                    ? AppTheme.secondaryYellowColor.withOpacity(0.3)
                    : Colors.black12,
                blurRadius: 2,
                spreadRadius: 1,
                offset: const Offset(0, -1))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              index != 0
                  ? const SizedBox()
                  : Image.asset(
                      'assets/images/cricket_icon.png',
                      color: index == 0 ? Colors.white : Colors.grey.shade400,
                      height: 18,
                      width: 18,
                    ),
              const SizedBox(height: 5),
              Text(
                index != 0 ? 'Upcoming' : 'Cricket',
                style: TextStyle(
                    color: index == 0 ? Colors.white : Colors.grey,
                    fontSize: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}
