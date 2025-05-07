import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
import 'package:gully_app/data/model/package_model.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/ui/screens/shop/Shop%20owner%20Screen/shop_payment_page.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';

class ShopPackages extends StatefulWidget {
  final ShopModel shop;
  final bool isAdditional;
  const ShopPackages(
      {required this.shop, super.key, this.isAdditional = false});

  @override
  State<StatefulWidget> createState() => SponsorPackageScreenState();
}

class SponsorPackageScreenState extends State<ShopPackages> {
  int? selectedIndex;
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
      body: !controller.isConnected.value
          ? const Center(
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
            )
          : Column(
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
                  future: widget.isAdditional
                      ? controller.getAdditionalPackages()
                      : controller.getPackage('shop'),
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
                                controller.selectedpackage.value = package;
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
                        onTap: () => Get.to(() => ShopPaymentPage(
                            shop: widget.shop,
                            selectedpackage:
                                controller.selectedpackage.value!)),
                        title: 'Continue',
                      ),
                    ],
                  ),
                ),
              ],
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (package.features != null)
                    Column(children: [
                      ...package.features!.take(3).map((feature) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle,
                                    size: 18, color: Colors.green.shade600),
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
                          )),
                      GestureDetector(
                        onTap: () => showPackageDetails(context, package),
                        child: const Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ]),
                ],
              ),
            ),
            Container(
              height: 70,
              width: 2,
              decoration: const BoxDecoration(color: Colors.grey),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "₹${package.price}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "For ${package.duration} month",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void showPackageDetails(BuildContext context, Package package) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                package.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              if (package.description != null)
                Text(
                  package.description!,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Price: ₹${package.price}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 20),
                  if (package.duration != null)
                    Text(
                      "Validity: ${package.duration}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Product edits allowed: ${package.maxEditAllowed}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              if (package.features != null && package.features!.isNotEmpty) ...[
                const Text(
                  "Key Features",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ...package.features!.map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle,
                              size: 18, color: Colors.green.shade600),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              feature,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ],
          ),
        );
      },
    );
  }
}
