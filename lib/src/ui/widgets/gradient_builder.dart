import 'package:flutter/material.dart';

class GradientBuilder extends StatelessWidget {
  final Widget child;
  const GradientBuilder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage(
              'assets/images/sports_icon.png',
            ),
            fit: BoxFit.cover),
      ),
      child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff3F5BBF),
                Color.fromARGB(182, 63, 91, 191),
                Color.fromARGB(41, 63, 91, 191),
                Color.fromARGB(26, 63, 91, 191),
                Color.fromARGB(31, 63, 91, 191),
                Color.fromARGB(47, 63, 91, 191),
              ],
              stops: [0.04, 0.14, 0.3, 1, 1, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: RadialGradient(colors: [
                Color(0xff5FBCFF),
                Color.fromARGB(34, 95, 188, 255),
              ], stops: [
                0.2,
                0.9,
              ], center: Alignment.topLeft),
            ),
            child: child,
          )),
    );
  }
}
