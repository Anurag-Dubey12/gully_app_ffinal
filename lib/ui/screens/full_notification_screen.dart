import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';

class FullNotificationScreen extends StatefulWidget {
  const FullNotificationScreen({super.key});

  @override
  State<FullNotificationScreen> createState() => _FullNotificationScreenState();
}

class _FullNotificationScreenState extends State<FullNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return GradientBuilder(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: const Text('Notification',
            style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          width: Get.width,
          height: Get.height / 1.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 10))
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Congrats on the win!',
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                Divider(
                  color: Colors.grey[200],
                ),
                const Spacer(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Download file'),
                    Icon(
                      Icons.file_copy,
                      color: AppTheme.secondaryYellowColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
