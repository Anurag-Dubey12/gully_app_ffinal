import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/utils/app_logger.dart';

import '../../../data/model/service_model.dart';
import '../../screens/service/service_profile_screen.dart';
import '../../theme/theme.dart';

class ServicesList extends StatelessWidget {
  final ServiceModel service;

  const ServicesList({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.1),
            //     spreadRadius: 1,
            //     blurRadius: 10,
            //     offset: const Offset(0, 1),
            //   ),
            // ],
            border: Border.all(color: Colors.black)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   width: 80,
                  //   height: 80,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(8),
                  //     border: Border.all(
                  //       color: Colors.grey.withOpacity(0.2),
                  //       width: 1,
                  //     ),
                  //   ),
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(8),
                  //     child: Image.asset(
                  //       "assets/images/logo.png",
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Expanded(
                            //   child: Text(
                            //     service.name,
                            //     style: const TextStyle(
                            //       fontSize: 16,
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.black,
                            //     ),
                            //     maxLines: 1,
                            //     overflow: TextOverflow.ellipsis,
                            //   ),
                            // ),
                            Expanded(
                                child: Text(
                              service.category,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            )),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '₹${service.fees}/day',
                                style: const TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),
                        // Row(
                        //   children: [
                        //     Icon(
                        //       Icons.location_on_outlined,
                        //       size: 16,
                        //       color: Colors.grey[600],
                        //     ),
                        //     const SizedBox(width: 4),
                        //     Expanded(
                        //       child: Text(
                        //         service.address ?? 'Location not available',
                        //         style: const TextStyle(
                        //           fontSize: 12,
                        //           color: Colors.black,
                        //         ),
                        //         maxLines: 1,
                        //         overflow: TextOverflow.ellipsis,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.work_outline_rounded,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${service.experience} Years',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Experience',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: 24,
                    width: 1,
                    color: Colors.grey.withOpacity(0.2),
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  const Row(
                    children: [
                      Icon(
                        Icons.verified_outlined,
                        size: 16,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 24,
                    width: 1,
                    color: Colors.grey.withOpacity(0.2),
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => ServiceProfileScreen(service: service));
                      //logger.d"ServiceProfileScreen");
                    },
                    style: TextButton.styleFrom(
                        // padding: const EdgeInsets.symmetric(horizontal: 10),
                        textStyle: const TextStyle(fontSize: 12),
                        side: const BorderSide(color: AppTheme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        )),
                    child: const Text("View"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
