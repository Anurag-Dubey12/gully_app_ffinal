import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/notification_model.dart';

import '../../data/controller/notification_controller.dart';
import '../../utils/date_time_helpers.dart';
import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.markAllAsRead();
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/sports_icon.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            ClipPath(
              clipper: ArcClipper(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xff368EBF),
                      AppTheme.primaryColor,
                    ],
                    center: Alignment(-0.4, -0.8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.secondaryYellowColor.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 70),
                    )
                  ],
                ),
                width: double.infinity,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    iconTheme: const IconThemeData(color: Colors.white),
                    title: Text(
                      'Notifications',
                      style: Get.textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.04),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.03,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                        child: Obx(
                              () => controller.notifications.value.isEmpty
                              ? const Center(
                            child: Text('No notifications'),
                          )
                              : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.notifications.value.length,
                            itemBuilder: (context, index) {
                              return NotificationCard(
                                notification:
                                controller.notifications.value[index],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.02), // Bottom padding
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dismissible(
          direction: DismissDirection.endToStart,
          key: Key(notification.notificationId ?? ''),
          onDismissed: (e) {
            Get.find<NotificationController>().removeNotification(notification);
          },
          background: Container(
            color: Colors.red,
            child: const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: Get.width / 1.8,
                    child: Text(
                      notification.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      style: Get.textTheme.headlineMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 120,
                    child: Text(
                      formatDateTime(
                        'dd/MMM/yyy hh:mm a',
                        notification.createdAt,
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      maxLines: 1,
                      softWrap: true,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Text(
                notification.body,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                style: Get.textTheme.headlineMedium?.copyWith(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            color: Colors.grey[200],
          ),
        ),
      ],
    );
  }
}