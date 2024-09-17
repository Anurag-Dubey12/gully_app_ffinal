import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../utils/app_logger.dart';
import '../../theme/theme.dart';
import '../primary_button.dart';

class PackageScreen extends StatefulWidget {
  const PackageScreen({super.key});

  @override
  State<StatefulWidget> createState() => PackageScreenState();
}

class PackageScreenState extends State<PackageScreen> {
  String selectedPackage = '';

  final List<Map<String, dynamic>> packages = [
    {
      'package': 'Basic',
      'price': 1000,
      'Duration': '3 Months',
    },
    {
      'package': 'Standard',
      'price': 2000,
      'Duration': '6 Months',
    },
    {
      'package': 'Gold',
      'price': 3000,
      'Duration': '1 Year',
    },
  ];

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: const Text(
          'Your Packages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: PrimaryButton(
            onTap: () {
              if (selectedPackage.isNotEmpty) {
                final selectedPackageDetails = packages.firstWhere(
                  (package) => package['package'] == selectedPackage,
                  orElse: () => {},
                );
                Get.back(result: selectedPackageDetails);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a package')),
                );
              }
            },
            title: 'Confirm My Package',
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final package = packages[index];
                  return PackageInfo(
                    package: package,
                    isSelected: package['package'] == selectedPackage,
                    onSelect: () {
                      setState(() {
                        selectedPackage = package['package'];
                        logger.d("Package Seleced:${package['package']}");
                      });
                    },
                  );
                },
                childCount: packages.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PackageInfo extends StatelessWidget {
  final Map<String, dynamic> package;
  final bool isSelected;
  final VoidCallback onSelect;

  const PackageInfo({
    required this.package,
    required this.isSelected,
    required this.onSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final packageName = package['package'];
    final price = package['price'];
    final duration = package['Duration'];

    return GestureDetector(
      onTap: onSelect,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryColor.withOpacity(0.2)
                  : Colors.white,
              border: Border.all(
                color:
                    isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    packageName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Price: $price',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Duration: $duration',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    "More Info",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  collapsedBackgroundColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "This is package info",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Some more details about this package",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Contact support for more information",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            right: 10,
              top: 10,
              child: Icon(Icons.check_circle,
                  color:
                      isSelected ? AppTheme.primaryColor : Colors.transparent)),
        ],
      ),
    );
  }
}
