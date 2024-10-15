import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/service_model.dart';
import 'package:gully_app/ui/screens/service/ServiceDetailsScreen.dart';
import 'package:gully_app/ui/screens/service/service_profile_screen.dart';
import 'package:gully_app/data/controller/service_controller.dart';

import '../../theme/theme.dart';

class MyService extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ServicesState();
}

class _ServicesState extends State<MyService> {
  final ServiceController _serviceController = Get.put(ServiceController());

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    await _serviceController.loadServiceData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Service"),
        backgroundColor: AppTheme.primaryColor,
        elevation: 2,
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
      body: Obx(() {
        if (_serviceController.servicelist.isEmpty) {
          return const Center(child: Text('No services available'));
        }
        return ListView.builder(
          itemCount: _serviceController.servicelist.length,
          itemBuilder: (context, index) {
            ServiceModel service = _serviceController.servicelist[index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black
                )
              ),
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
                title: Text(service.providerName),
                subtitle: Text(service.serviceDescription),
                trailing: Text('₹${service.serviceCharges}'),
                onTap: () {
                  Get.to(() => ServiceProfileScreen(service: service));
                },
              ),
            );
          },
        );
      }),
    );
  }
}