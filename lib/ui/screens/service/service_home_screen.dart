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
  final ServiceController _serviceController = Get.find<ServiceController>();


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
                onTap: () {
                },
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

          // Expanded(
          //   child: Obx(() => ListView.builder(
          //         itemCount: _serviceController.servicelist.length,
          //         padding: const EdgeInsets.all(16),
          //         itemBuilder: (context, index) {
          //           final service = _serviceController.servicelist[index];
          //           return Card(
          //             elevation: 5,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(12),
          //             ),
          //             margin: const EdgeInsets.only(bottom: 16),
          //             child: InkWell(
          //               onTap: () {
          //                 Get.to(() => ServiceProfileScreen(service: service));
          //               },
          //               borderRadius: BorderRadius.circular(12),
          //               child: Padding(
          //                 padding: const EdgeInsets.all(16),
          //                 child: Row(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     // ClipRRect(
          //                     //   borderRadius: BorderRadius.circular(8),
          //                     //   child:service.providerimage.isNotEmpty && service.providerimage!=null ? Image.asset(
          //                     //     service.providerimage,
          //                     //     width: 100,
          //                     //     height: 100,
          //                     //     fit: BoxFit.contain,
          //                     //   ):Image.asset('assets/images/logo.png')
          //                     // ),
          //                     ClipRRect(
          //                         borderRadius: BorderRadius.circular(8),
          //                         child: Image.asset(
          //                           'assets/images/logo.png',
          //                           width: 100,
          //                           height: 100,
          //                           fit: BoxFit.contain,
          //                         )),
          //                     const SizedBox(width: 10),
          //                     Expanded(
          //                       child: Column(
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           Text(
          //                             service.name,
          //                             style: const TextStyle(
          //                               fontWeight: FontWeight.bold,
          //                               fontSize: 18,
          //                               color: Colors.black,
          //                             ),
          //                           ),
          //                           const SizedBox(height: 6),
          //                           Text(
          //                             service.description,
          //                             style: const TextStyle(
          //                               color: Colors.grey,
          //                               fontSize: 14,
          //                             ),
          //                           ),
          //                           Text(
          //                             '₹${service.fees}',
          //                             style: const TextStyle(
          //                               fontWeight: FontWeight.bold,
          //                               fontSize: 16,
          //                               color: Colors.green,
          //                             ),
          //                           ),
          //                           Text(
          //                             service.address,
          //                             style: const TextStyle(
          //                               color: Colors.black54,
          //                               fontSize: 14,
          //                             ),
          //                             maxLines: 1,
          //                             overflow: TextOverflow.ellipsis,
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           );
          //         },
          //       )),
          // ),
        ],
      ),
    );
  }
}
