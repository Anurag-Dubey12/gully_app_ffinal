import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/service_controller.dart';
import 'package:gully_app/data/model/service_model.dart';
import 'package:gully_app/ui/screens/service/service_profile_screen.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';

class MyRegisterService extends StatefulWidget {
  const MyRegisterService({super.key});

  @override
  State<StatefulWidget> createState() => MyServices();
}

class MyServices extends State<MyRegisterService> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceController>();
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/sports_icon.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: GradientBuilder(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("My Services"),
            backgroundColor: Colors.transparent,
            titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),
          body: FutureBuilder(
            future: controller.getuserService(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              return Obx(() {
                if (controller.userservice.isEmpty) {
                  return const Center(child: Text('No services available'));
                }
                return ListView.separated(
                  itemCount: controller.userservice.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final registerService = controller.userservice[index];
                    return Services(index: index, service: registerService);
                  },
                );
              });
            },
          ),
        ),
      ),
    );
  }
}

class Services extends StatelessWidget {
  final int index;
  final ServiceModel service;

  const Services({
    super.key,
    required this.index,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceController>();

    return GestureDetector(
      onTap: () => Get.to(
            () => ServiceProfileScreen(service: service, isAdmin: true),
      ),
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.category ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        service.description ?? 'No description available',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 2,
                        softWrap: true,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          serviceinfo(
                            Icons.access_time,
                            '${service.duration ?? 0} mins',
                          ),
                          const SizedBox(width: 10),
                          serviceinfo(
                            Icons.work,
                            '${service.experience ?? 0} years',
                          ),
                          const SizedBox(width: 10),
                          serviceinfo(
                            Icons.currency_rupee,
                            '${service.fees ?? 0}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Service'),
                        content: Text('Are you sure you want to delete ${service.category} service?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Get.close();
                              await controller.deleteService(service.id);
                              await controller.getuserService();
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red.shade400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceinfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}