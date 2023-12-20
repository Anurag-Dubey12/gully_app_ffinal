import 'package:flutter/material.dart';

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // draw arc outside container from bottom
    // path.moveTo(0, size.height);
    path.moveTo(0, 0);
    // path.lineTo(size.width, 120);
    // Define the control points and end point to create the U shape
    path.lineTo(0, size.height / 5);
    path.quadraticBezierTo(
        size.width / 2, size.height / 4, size.width, size.height / 5);
    path.lineTo(size.width, 0);

    // Line to the bottom-right corner to complete the clip area
    // path.lineTo(size.width, size.height);
    // Line to the bottom-left corner to close the path
    // path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
