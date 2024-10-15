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

  void update_EndDate(String packagename) {
    final package = packages.firstWhere((p) => p['package'] == packagename);
    final duration = package['Duration'];
    late DateTime endDateTime;

    switch (duration) {
      case '3 Months':
        endDateTime = DateTime.now().add(const Duration(days: 90));
        break;
      case '6 Months':
        endDateTime = DateTime.now().add(const Duration(days: 180));
        break;
      case '1 Year':
        endDateTime = DateTime.now().add(const Duration(days: 365));
        break;
    }
    setState(() {
      endDate = DateFormat('dd/MM/yyyy').format(endDateTime);
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
          'Subscription',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: AppTheme.primaryColor,
                    height: 210,
                    width: double.infinity,
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                        height: 200,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Choose Your Subscription",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Column(
                    children: packages.map((package) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: PackageCard(
                        package: package,
                        isSelected: package['package'] == selectedPackage,
                        onSelect: () {
                          setState(() {
                            selectedPackage = package['package'];
                            update_EndDate(selectedPackage!);
                            logger.d("Package Selected: ${package['package']}");
                          });
                        },
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                PrimaryButton(
                  onTap: () {
                    if (selectedPackage != null) {
                      final selectedPackageDetails = packages.firstWhere(
                            (package) => package['package'] == selectedPackage,
                        orElse: () => {},
                      );
                      selectedPackageDetails['EndDate'] = endDate;
                      Get.back(result: selectedPackageDetails);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a package')),
                      );
                    }
                  },
                  title: 'Continue',
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTextLink('Terms of use'),
                    const Text(' | '),
                    _buildTextLink('Privacy Policy'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextLink(String text) {
    return GestureDetector(
      onTap: () {

      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class PackageCard extends StatelessWidget {
  final Map<String, dynamic> package;
  final bool isSelected;
  final VoidCallback onSelect;

  const PackageCard({
    Key? key,
    required this.package,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE6F0FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? package['Border_color'] : Colors.transparent,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package['package'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: package['Border_color'],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Price: ${package['price']}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Duration: ${package['Duration']}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: package['Border_color'],
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}