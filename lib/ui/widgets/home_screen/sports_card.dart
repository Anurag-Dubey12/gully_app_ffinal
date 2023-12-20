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
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          color: index == 0 ? const Color(0xffDD6F50) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
                color: index == 0
                    ? AppTheme.secondaryYellowColor.withOpacity(0.3)
                    : Colors.black12,
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 1))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/cricket_icon.png',
                height: 45,
                color: index == 0 ? Colors.white : Colors.grey.shade400,
                width: 45,
              ),
              const SizedBox(height: 5),
              Text(
                'Cricket',
                style: TextStyle(
                    color: index == 0 ? Colors.white : Colors.grey,
                    fontSize: 14),
              )
            ],
          ),
        ),
      ),
    );
  }
}
