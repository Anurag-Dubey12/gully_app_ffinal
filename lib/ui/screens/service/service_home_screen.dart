import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/service_model.dart';
import 'package:gully_app/ui/screens/service/service_profile_screen.dart';

import '../../../data/controller/service_controller.dart';
import '../../../utils/app_logger.dart';

class ServiceHomeScreen extends StatefulWidget {
  const ServiceHomeScreen({Key? key}) : super(key: key);

  @override
  State<ServiceHomeScreen> createState() => _ServiceHomeScreenState();
}

class _ServiceHomeScreenState extends State<ServiceHomeScreen> {
  final ServiceController serviceController = Get.find<ServiceController>();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _stopAutoRefresh();
    super.dispose();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(minutes: 5), (_) {
      _refreshData();
    });
  }

  void _stopAutoRefresh() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _refreshData() async {
    try {
      await serviceController.getService();
    } catch (e) {
      logger.e('Error refreshing data: $e');
    }
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
                    color: const Color(0xFFE8E5E8),
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
          Get.to(() => ServiceProfileScreen(service: service,isAdmin: false,));
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
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: GestureDetector(
              //     onTap: () {
              //       imageViewer(context, authController.state!.profilePhoto,true);
              //     },
              //     child: CircleAvatar(
              //       radius: 40,
              //       backgroundImage: authController.state!.profilePhoto.isNotEmpty
              //           ? FallbackImageProvider(
              //           toImageUrl(authController.state!.profilePhoto),
              //           'assets/images/logo.png'
              //       ) as ImageProvider
              //           : const AssetImage('assets/images/logo.png'),
              //       backgroundColor: Colors.transparent,
              //     ),
              //   ),
              // ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.category?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      service.name?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      service.description?? '',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '₹${service.fees}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    // Text(
                    //   service.address?? '',
                    //   style: const TextStyle(
                    //     color: Colors.black54,
                    //     fontSize: 14,
                    //   ),
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
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
