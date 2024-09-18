
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/screens/service/user_service_details.dart';

class ServiceHomeScreen extends StatefulWidget{
  const ServiceHomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileState();
}
class _ProfileState extends State<ServiceHomeScreen>{

  final List<Map<String, dynamic>> services = [
    {
      'title': 'Cricket Coaching',
      'description': 'Get trained by professional coaches to improve your skills.',
      'icon': 'assets/images/logo.png',
      'price': 1500,
      'images': [
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
      ],
      'name': 'John Doe',
      'place': 'Mumbai',
      'age': 35,
      'experience': '10 years',
      'service': 'Personalized cricket coaching designed to cater to players of all levels, from beginners to advanced.'
    },
    {
      'title': 'Equipment Rental',
      'description': 'Rent cricket gear for your practice sessions and matches.',
      'icon': 'assets/images/logo.png',
      'price': 500,
      'images': [
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
      ],
      'name': 'Jane Smith',
      'place': 'Delhi',
      'age': 29,
      'experience': '5 years',
      'service': 'Affordable and reliable cricket equipment rental service for individuals and teams.'
    },
    {
      'title': 'Match Organizing',
      'description': 'We organize matches and tournaments for all levels.',
      'icon': 'assets/images/logo.png',
      'price': 2000,
      'images': [
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
      ],
      'name': 'Michael Brown',
      'place': 'Bangalore',
      'age': 40,
      'experience': '15 years',
      'service': 'Comprehensive match and tournament organization for amateur and professional levels.'
    },
    {
      'title': 'Fitness Training',
      'description': 'Specialized fitness training for cricketers.',
      'icon': 'assets/images/logo.png',
      'price': 1200,
      'images': [
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
      ],
      'name': 'Emily Davis',
      'place': 'Kolkata',
      'age': 33,
      'experience': '7 years',
      'service': 'Tailored fitness training programs to meet the demands of modern cricket.'
    },
    {
      'title': 'Mental Coaching',
      'description': 'Enhance your mental strength with our mental coaching.',
      'icon': 'assets/images/logo.png',
      'price': 1000,
      'images': [
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
        'assets/images/logo.png',
      ],
      'name': 'Sarah Johnson',
      'place': 'Chennai',
      'age': 38,
      'experience': '12 years',
      'service': 'Expert mental coaching for athletes to boost performance and mental toughness.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Expanded(
          child: ListView.builder(
            itemCount: services.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final service = services[index];
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
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
                            service['icon'],
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                service['description'],
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '₹${service['price']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    service['place'],
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}