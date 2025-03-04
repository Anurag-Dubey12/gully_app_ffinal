
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/ui/screens/sponsor_payment_page.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../data/controller/auth_controller.dart';
import '../../../data/controller/banner_promotion_controller.dart';
import '../../../data/model/package_model.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/utils.dart';
import '../../theme/theme.dart';
import '../primary_button.dart';

class SponsorPackageScreen extends StatefulWidget {
  final TournamentModel tournament;
  const SponsorPackageScreen({required this.tournament, super.key});

  @override
  State<StatefulWidget> createState() => SponsorPackageScreenState();
}

class SponsorPackageScreenState extends State<SponsorPackageScreen> {
  int? selectedIndex;
  Package? selectedPackage;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MiscController>();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: const Text(
          'Choose Your Package',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body:!controller.isConnected.value ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_off,
              size: 48,
              color: Colors.black54,
            ),
            SizedBox(height: 16),
            Text(
              'No internet connection',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ): Column(
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
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Text(
          //     'Choose a sponsorship package to start adding your sponsor details. This will help you select the best plan for your sponsorship needs.',
          //     style: TextStyle(
          //       fontSize: 16,
          //       fontWeight: FontWeight.w500,
          //       color: Colors.black,
          //     ),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          const SizedBox(height: 10),
          FutureBuilder<List<Package>>(
            future: controller.getPackage('sponsorship'),
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
                          controller.selectedpackage.value=package;
                        });
                      },
                    );
                  },
                ),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                PrimaryButton(
                  onTap: () {
                    Get.to(()=>SponsorPaymentPage(tournament: widget.tournament,package: controller.selectedpackage.value));
                  },
                  title: 'Continue',
                ),
                // const SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     _buildTextLink('Terms of use'),
                //     const Text(' | '),
                //     _buildTextLink('Privacy Policy'),
                //   ],
                // ),
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
            Expanded(
              child: Column(
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
                    "${package.name} - ₹${package.price}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (package.features != null)
                    Column(
                      children: package.features!
                          .map((feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, size: 18, color: Colors.green.shade600),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                feature,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                          .toList(),
                    ),
                ],
              ),
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