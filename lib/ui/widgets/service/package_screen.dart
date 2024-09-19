import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_logger.dart';
import '../../theme/theme.dart';
import '../primary_button.dart';

class PackageScreen extends StatefulWidget {
  final Map<String, dynamic>? selectedPackages;
  const PackageScreen({this.selectedPackages, super.key});

  @override
  State<StatefulWidget> createState() => PackageScreenState();
}

class PackageScreenState extends State<PackageScreen> {
  String? selectedPackage;
  String? endDate;

  final List<Map<String, dynamic>> packages = [

    {
      'package': 'Basic',
      'price': 1000,
      'Duration': '3 Months',
      'Border_color': Colors.orange,
    },
    {
      'package': 'Standard',
      'price': 2000,
      'Duration': '6 Months',
      'Border_color': Colors.blue
    },
    {
      'package': 'Gold',
      'price': 3000,
      'Duration': '1 Year',
      'Border_color': Colors.red
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedPackage = widget.selectedPackages?['package'];
  }
  void update_EndDate(String packagename){
    final package=packages.firstWhere((p)=>p['package']==packagename);
    final duration=package['Duration'];
    late DateTime endDateTime;

    switch(duration){
      case '3 Months':
        endDateTime=DateTime.now().add(const Duration(days: 90));
        break;
      case '6 Months':
        endDateTime=DateTime.now().add(const Duration(days: 180));
        break;
      case '1 Year':
        endDateTime=DateTime.now().add(const Duration(days: 365));
        break;
    }
    setState(() {
      endDate=DateFormat('dd/MM/yyyy').format(endDateTime);
    });
  }

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
              if (selectedPackage != null) {
                final selectedPackageDetails = packages.firstWhere(
                      (package) => package['package'] == selectedPackage,
                  orElse: () => {},
                );
                selectedPackageDetails['EndDate']=endDate;
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
                        update_EndDate(selectedPackage!);
                        logger.d("Package Selected: ${package['package']}");
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
    final borderColor = package['Border_color'];
    return GestureDetector(
      onTap: onSelect,
      child: Stack(
        children: [
          Container(
            width: Get.width,
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryColor.withOpacity(0.2)
                  : Colors.white,
              border: Border.all(
                color: isSelected ? borderColor : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  packageName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? borderColor : AppTheme.primaryColor,
                  ),
                ),
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
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              right: 10,
              top: 35,
              child: Icon(
                Icons.check_circle,
                color: borderColor,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }
}