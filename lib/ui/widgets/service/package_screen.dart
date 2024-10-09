import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_logger.dart';
import '../../theme/theme.dart';
import '../primary_button.dart';
import 'PackageInfo.dart';

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
