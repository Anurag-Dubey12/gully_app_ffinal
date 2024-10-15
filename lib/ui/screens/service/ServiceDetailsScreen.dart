import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/service_model.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../data/controller/service_controller.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final ServiceModel service;
  final ServiceController _serviceController = Get.find<ServiceController>();

  ServiceDetailsScreen({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(service.providerName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image carousel
            CarouselSlider(
              options: CarouselOptions(height: 200.0),
              items: service.galleryImages.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: Get.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.providerName,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Provided by: ${service.providerName}',
                  
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description:',
                    
                  ),
                  Text(service.serviceDescription),
                  const SizedBox(height: 16),
                  Text(
                    'Service Charges: ₹${service.serviceCharges}',
                    
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Years of Experience: ${service.yearsOfExperience}',
                  
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Offered Services:',
                    
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: service.offeredServiceList
                        .map((s) => Chip(label: Text(s)))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Location: ${service.providerLocation}',
                  
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Package Details:',
                    
                  ),
                  ListTile(
                    title: Text(service.servicePackage.name),
                    subtitle: Text(service.servicePackage.duration),
                    trailing: Text('₹${service.servicePackage.price}'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {

        },
        label: const Text('Book Now'),
        icon: const Icon(Icons.book),
      ),
    );
  }
}