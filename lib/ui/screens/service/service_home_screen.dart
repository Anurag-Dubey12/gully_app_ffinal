import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/service_model.dart';
import 'package:gully_app/ui/screens/service/service_profile_screen.dart';

import '../../../data/controller/service_controller.dart';

class ServiceHomeScreen extends StatefulWidget {
  const ServiceHomeScreen({Key? key}) : super(key: key);

  @override
  State<ServiceHomeScreen> createState() => _ServiceHomeScreenState();
}

class _ServiceHomeScreenState extends State<ServiceHomeScreen> {
  final ServiceController serviceController = Get.find<ServiceController>();

  @override
  void initState() {
    serviceController.getService();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Services"),
        backgroundColor: const Color(0xff3F5BBF),
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 5,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {},
                child: Ink(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(width: 18),
                      Icon(
                        Icons.search_rounded,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Search...',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ServiceModel>>(
                future: serviceController.getService(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if ((snapshot.data?.isEmpty ?? true)) {
                    return SizedBox(
                      width: Get.width,
                      child: const Center(
                        child: Text('No Service Found',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final service = snapshot.data![index];
                      return ServiceListItem(service: service);
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
class ServiceListItem extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onTap;

  const ServiceListItem({
    Key? key,
    required this.service,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap ?? () {
          Get.to(() => ServiceProfileScreen(service: service));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      service.description,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '₹${service.fees}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      service.address,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
