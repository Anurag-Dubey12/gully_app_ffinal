import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
import 'package:intl/intl.dart';

import '../../../data/model/package_model.dart';
import '../../../utils/app_logger.dart';
import '../../theme/theme.dart';
import '../primary_button.dart';

class PackageScreen extends StatefulWidget {
  final Package? package;
  const PackageScreen({this.package, super.key});

  @override
  State<StatefulWidget> createState() => PackageScreenState();
}

class PackageScreenState extends State<PackageScreen> {
  String? selectedPackage;
  String? endDate;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    if(widget.package!=null){

    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MiscController>();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: const Text(
          'Choose Your Subscription',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body:Column(
        children: [
          Container(
            color: AppTheme.primaryColor,
            height: Get.height * 0.21,
            width: double.infinity,
            child: Center(
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                height: 150,
              ),
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder<List<Package>>(
            future: controller.getPackage('Banner'),
            builder: (context, snapshot) {
              return Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 1),
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final package = snapshot.data![index];
                    final isSelected = selectedIndex == index;
                    return PackageCard(
                      package: package,
                      isSelected: isSelected,
                      onSelect: () {
                        setState(() {
                          selectedIndex = index;
                          selectedPackage = package.name;
                        });
                      },
                    );
                  },
                ),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                PrimaryButton(
                  onTap: () {
                    if (selectedPackage != null) {
                      Get.back(result: {'package': selectedPackage});
                    }
                    // if (selectedPackage != null) {
                    //   final selectedPackageDetails = packages.firstWhere(
                    //         (package) => package['package'] == selectedPackage,
                    //     orElse: () => {},
                    //   );
                    //   selectedPackageDetails['EndDate'] = endDate;
                    //   Get.back(result: selectedPackageDetails);
                    // } else {
                    //
                    // }
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
      onTap: () {},
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
  final Package package;
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
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (isPopular)
                //   Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                //     decoration: BoxDecoration(
                //       color: Colors.amber.shade100,
                //       borderRadius: BorderRadius.circular(6),
                //     ),
                //     child: const Text(
                //       'Popular',
                //       style: TextStyle(
                //         fontSize: 12,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.black87,
                //       ),
                //     ),
                //   ),
                Text(
                  package.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${package.price} for ${package.duration}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            Radio<String>(
              value: package.id,
              groupValue: isSelected ? package.id : null,
              onChanged: (value) => onSelect(),
              activeColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}