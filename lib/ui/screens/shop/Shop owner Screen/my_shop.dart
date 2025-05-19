import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/screens/shop/User%20Screen/register_shop.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../data/controller/shop_controller.dart';
import '../../../../data/model/shop_model.dart';
import 'my_shop_dashboard.dart';
import '../../../theme/theme.dart';
import '../../../widgets/arc_clipper.dart';

class MyShop extends GetView<ShopController> {
  const MyShop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ShopController controller = Get.find<ShopController>();
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/sports_icon.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            ClipPath(
              clipper: ArcClipper(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xff368EBF),
                      AppTheme.primaryColor,
                    ],
                    center: Alignment(-0.4, -0.8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.9),
                      blurRadius: 20,
                      spreadRadius: 20,
                      offset: const Offset(0, 90),
                    ),
                  ],
                ),
                width: double.infinity,
              ),
            ),
            Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: const BackButton(color: Colors.white),
                  title: Text(
                    "My Shops",
                    style: Get.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  actions: controller.myShops.isNotEmpty
                      ? [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Get.to(
                                  () => const RegisterShop(),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 500),
                                );
                              },
                              icon: const Icon(Icons.add_business, size: 18),
                              label: const Text("Register Shop"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppTheme.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                textStyle: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          )
                        ]
                      : null,
                ),
                Expanded(
                  child: FutureBuilder<List<ShopModel>>(
                    future: controller.getMyShop(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Failed to Retrieve Shop"),
                        );
                      }
                      if (snapshot.data!.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.store_mall_directory_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "No Shops Found",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "You haven't registered any shops yet. Get started by creating your first shop.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                PrimaryButton(
                                    title: "Register My Shop",
                                    onTap: () => Get.to(
                                        () => const RegisterShop(),
                                        transition: Transition.fadeIn,
                                        duration:
                                            const Duration(milliseconds: 500)))
                              ],
                            ),
                          ),
                        );
                      }

                      return Obx(() => ListView.builder(
                            itemCount: controller.myShops.length,
                            padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.02,
                              vertical: Get.height * 0.02,
                            ),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: ShopCard(shop: snapshot.data![index]),
                              );
                            },
                          ));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShopCard extends StatefulWidget {
  final ShopModel shop;

  const ShopCard({Key? key, required this.shop}) : super(key: key);

  @override
  State<ShopCard> createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  int totalPackageImageLimit = 0;
  final shopController = Get.find<ShopController>();
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.05, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Start entry animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int getShopPackageImageLimit() {
    final baseLimit = widget.shop.package?.maxMedia ?? 0;

    final additionalLimit = widget.shop.additionalPackages != null
        ? widget.shop.additionalPackages!
            .map((pkg) => pkg.maxMedia ?? 0)
            .fold(0, (sum, value) => sum + value)
        : 0;

    final totalLimit = baseLimit + additionalLimit;

    shopController.totalPackagelimit.value = totalLimit;
    return totalLimit;
  }

  @override
  Widget build(BuildContext context) {
    final shop = widget.shop;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        shopController.shop.value = shop;
        Get.to(
            () => const ShopDashboard(
                  isAdmin: true,
                ),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 300));
        getShopPackageImageLimit();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all()),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: shop.shopImage.isNotEmpty
                          ? Image.network(
                              toImageUrl(shop.shopImage.first),
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    color: Colors.white,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 150,
                                  width: 150,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.broken_image,
                                      color: Colors.grey),
                                );
                              },
                            )
                          : Image.asset(
                              "assets/images/logo.png",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shop.shopName,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            shop.shopDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.location_on,
                                  size: 16, color: colorScheme.secondary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  shop.shopAddress,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.phone,
                                  size: 16, color: colorScheme.secondary),
                              const SizedBox(width: 6),
                              Text(
                                shop.shopContact,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
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
          ),
        ),
      ),
    );
  }
}
