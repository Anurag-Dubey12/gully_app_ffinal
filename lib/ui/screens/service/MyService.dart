import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/service_model.dart';
import 'package:gully_app/ui/screens/service/ServiceDetailsScreen.dart';
import 'package:gully_app/ui/screens/service/user_service_details.dart';
import 'package:gully_app/data/controller/service_controller.dart';

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
        title: Text('My Services'),
      ),
      body: Obx(() {
        if (_serviceController.servicelist.isEmpty) {
          return Center(child: Text('No services available'));
        }
        return ListView.builder(
          itemCount: _serviceController.servicelist.length,
          itemBuilder: (context, index) {
            ServiceModel service = _serviceController.servicelist[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(service.providerimage),
                ),
                title: Text(service.name),
                subtitle: Text(service.description),
                trailing: Text('₹${service.serviceCharges}'),
                onTap: () {

                  Get.to(() => ServiceProfileScreen(
                    service: {
                      'name': service.name,
                      'place': service.location,
                      'age': service.providerAge,
                      'experience': '${service.yearsOfExperience} years',
                      'service': service.description,
                      'price': service.serviceCharges,
                      'icon': service.providerimage,
                      'images': service.imageUrls,
                    },
                  ));
                },
              ),
            );
          },
        );
      }),
    );
  }
}