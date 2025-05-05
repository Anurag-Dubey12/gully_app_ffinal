import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/shop_controller.dart';
import 'package:gully_app/data/model/business_hours_model.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/ui/screens/shop/Shop%20owner%20Screen/my_shop_dashboard.dart';
import 'package:gully_app/ui/screens/shop/User%20Screen/shop_search_screen.dart';
import 'package:gully_app/utils/image_picker_helper.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../data/controller/auth_controller.dart';

class ShopHome extends StatefulWidget {
  const ShopHome({super.key});
  @override
  State<StatefulWidget> createState() => ShopHomeState();
}

class ShopHomeState extends State<ShopHome> {
  final authController = Get.find<AuthController>();
  final shopController = Get.find<ShopController>();

  Future<void> refreshShopData() async {
    await shopController.getNearbyShop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff3F5BBF),
        title: const Text(
          'Nearby Shop',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () {
              Get.to(() => const ShopSearchScreen());
            },
          ),
        ],
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: refreshShopData,
        child: FutureBuilder<List<ShopModel>>(
          future: shopController.getNearbyShop(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              print(snapshot.error);
              return Center(
                child: Text("Failed to Retrieve Shop: ${snapshot.error}"),
              );
            }

            final shopList = snapshot.data ?? [];

            if (shopList.isEmpty) {
              return const Center(child: Text("No nearby shops found."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: shopList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: NearbyShopCard(shop: shopList[index]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class NearbyShopCard extends StatefulWidget {
  final ShopModel shop;
  const NearbyShopCard({Key? key, required this.shop}) : super(key: key);

  @override
  State<NearbyShopCard> createState() => _NearbyShopCardState();
}

class _NearbyShopCardState extends State<NearbyShopCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

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
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getShopStatus(Map<String, BusinessHoursModel>? timing) {
    if (timing == null) return "Closed";

    final now = DateTime.now();
    final weekday = now.weekday;
    final days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ][weekday - 1];

    final todayTiming = timing[days];

    if (todayTiming == null || !todayTiming.isOpen) return "Closed";

    try {
      final openTime = DateFormat("hh:mm a").parse(todayTiming.openTime ?? "");
      final closeTime =
          DateFormat("hh:mm a").parse(todayTiming.closeTime ?? "");

      final open = DateTime(
          now.year, now.month, now.day, openTime.hour, openTime.minute);
      final close = DateTime(
          now.year, now.month, now.day, closeTime.hour, closeTime.minute);

      if (now.isBefore(open)) {
        final minsToOpen = open.difference(now).inMinutes;
        return minsToOpen <= 30 ? "Opening Soon" : "Closed";
      }

      if (now.isAfter(close)) return "Closed";

      final minsToClose = close.difference(now).inMinutes;
      return minsToClose <= 30 ? "Closing Soon" : "Open";
    } catch (e) {
      return "Closed";
    }
  }

  String getClosingTime(Map<String, BusinessHoursModel>? timing) {
    if (timing == null) return "";

    final now = DateTime.now();
    final weekday = now.weekday;
    final days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ][weekday - 1];

    final todayTiming = timing[days];

    if (todayTiming == null || !todayTiming.isOpen) return "";
    return todayTiming.closeTime ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final shop = widget.shop;
    final status = getShopStatus(shop.shopTiming);
    final closingTime = getClosingTime(shop.shopTiming);

    return GestureDetector(
      onTap: () {
        Get.to(() => ShopDashboard(
              shop: widget.shop,
              isAdmin: false,
            ));
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
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150,
                      child: widget.shop.shopImage.isNotEmpty
                          ? ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.shop.shopImage.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final imageUrl =
                                    toImageUrl(widget.shop.shopImage[index]);
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GestureDetector(
                                    onTap: () => imageViewer(context,
                                        widget.shop.shopImage[index], true),
                                    child: Image.network(
                                      imageUrl,
                                      height: 150,
                                      width: 150,
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
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          height: 150,
                                          width: 150,
                                          color: Colors.grey[200],
                                          child: const Icon(Icons.broken_image,
                                              color: Colors.grey),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "assets/images/logo.png",
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          shop.shopName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              status,
                              style: TextStyle(
                                color: status == "Open"
                                    ? Colors.green
                                    : status == "Closing Soon"
                                        ? Colors.orange
                                        : status == "Opening Soon"
                                            ? Colors.blue
                                            : Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (status == "Open" || status == "Closing Soon")
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  "Closes $closingTime",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                    Text(
                      shop.shopDescription,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            shop.shopAddress,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
