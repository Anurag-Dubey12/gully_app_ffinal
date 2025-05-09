import 'package:flutter/material.dart';

class BlinkingLiveText extends StatefulWidget {
  final String status;
  final Color color;
  const BlinkingLiveText({super.key, required this.status, required this.color});

  @override
  _BlinkingLiveTextState createState() => _BlinkingLiveTextState();
}

class _BlinkingLiveTextState extends State<BlinkingLiveText> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500)
    );
    if (widget.status == "Live") {
      _animationController.repeat(reverse: true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status != "Live") {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          widget.status,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          widget.status,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}