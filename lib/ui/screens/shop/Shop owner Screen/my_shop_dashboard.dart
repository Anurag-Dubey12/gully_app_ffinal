import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/product_model.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/ui/screens/shop/User%20Screen/product_detail_screen.dart';
import 'package:gully_app/ui/screens/shop/User%20Screen/shop_packages.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/banner/package_screen.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/ui/widgets/shop/actionButton.dart';
import 'package:gully_app/ui/widgets/shop/build_info_card.dart';
import 'package:gully_app/ui/widgets/shop/build_timing_row.dart.dart';
import 'package:gully_app/ui/widgets/shop/filter_bottomsheet.dart';
import 'package:gully_app/ui/widgets/shop/product_card.dart';
import 'package:gully_app/utils/image_picker_helper.dart';
import 'package:gully_app/utils/launch_external_service.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/controller/shop_controller.dart';

class ShopDashboard extends StatefulWidget {
  ShopModel shop;
  final bool isAdmin;
  ShopDashboard({Key? key, required this.shop, this.isAdmin = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<ShopDashboard> {
  final ShopController controller = Get.find<ShopController>();
  String _selectedCategory = 'All';
  bool _isAppBarCollapsed = false;
  bool _showAllTimings = false;
  bool isMore = false;
  List<String> categories = [];

  Widget shopTimingSection() {
    String currentDay = getCurrentDay();
    return buildInfoCard(
      title: "Shop Timings",
      icon: Icons.access_time,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showAllTimings = !_showAllTimings;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_showAllTimings)
              shopDayTimingRow(currentDay, widget.shop, isHighlighted: true)
            else
              ...widget.shop.shopTiming?.entries.map((entry) {
                    return shopDayTimingRow(
                      entry.key,
                      widget.shop,
                      isHighlighted: entry.key == currentDay,
                    );
                  }).toList() ??
                  [],
          ],
        ),
      ),
    );
  }

  Map<String, List<ProductModel>> _organizeByCategories(
      List<ProductModel> products) {
    final Map<String, List<ProductModel>> categorizedProducts = {};
    for (var product in products) {
      if (!categorizedProducts.containsKey(product.productCategory)) {
        categorizedProducts[product.productCategory] = [];
      }
      categorizedProducts[product.productCategory]?.add(product);
    }
    return categorizedProducts;
  }

  String? getExpirationTag() {
    final now = DateTime.now();
    final packageEndDate = widget.shop.packageEndDate;

    if (packageEndDate == null) return null;

    final daysDifference = packageEndDate.difference(now).inDays;

    if (daysDifference >= 0 && daysDifference <= 6) {
      return "Expires in $daysDifference day${daysDifference == 1 ? '' : 's'}";
    } else if (daysDifference < 0) {
      return "Expired ${-daysDifference} day${-daysDifference == 1 ? '' : 's'} ago";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GradientBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: widget.isAdmin
              ? Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.shop.shopName,
                        style: Get.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (getExpirationTag() != null)
                      GestureDetector(
                        onTap: () {
                          final tag = getExpirationTag();
                          if (tag != null && tag.startsWith("Expired")) {
                            Get.to(() => ShopPackages(
                                  shop: widget.shop,
                                  isAdditional: true,
                                ));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            getExpirationTag()!,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                  ],
                )
              : Text(
                  widget.shop.shopName,
                  style: Get.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
          leading: const BackButton(
            color: Colors.white,
          ),
          centerTitle: true,
        ),
        floatingActionButton: widget.isAdmin
            ? ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: FloatingActionButton(
                  onPressed: () {
                    if (widget.shop.isSubscriptionPurchased) {
                      if (controller.totalImagesAdded.value <=
                          controller.totalPackagelimit.value) {
                      } else {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          backgroundColor: Colors.white,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.warning_amber_rounded,
                                      size: 48, color: Colors.redAccent),
                                  const SizedBox(height: 12),
                                  const Text(
                                    "Image Limit Reached",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "You've reached the maximum number of images allowed in your current package. "
                                    "Each product you add uses images, and your current image balance is full.",
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "To continue, you can purchase an additional package. "
                                    "This will increase your image allowance on top of your current plan.",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Get.to(() => ShopPackages(
                                            shop: widget.shop,
                                            isAdditional: true,
                                          ));
                                    },
                                    child: const Text(
                                      "Get Additional Package",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    } else {
                      errorSnackBar("You have not SUbscribe ");
                    }
                  },
                  child: const Icon(Icons.add),
                ),
              )
            : const SizedBox.shrink(),
        body: widget.isAdmin ? adminShopView() : userShopView(),
      ),
    );
  }

  Widget adminShopView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              viewportFraction: 1.0,
              autoPlay: true,
              enlargeCenterPage: false,
              autoPlayInterval: const Duration(seconds: 5),
            ),
            items: widget.shop.shopImage.map((imageUrl) {
              return Builder(
                builder: (context) => GestureDetector(
                  onTap: () => imageViewer(context, imageUrl, true),
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(toImageUrl(imageUrl)),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(widget.shop.shopName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: buildInfoCard(
              title: "Description",
              icon: Icons.description,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedCrossFade(
                    crossFadeState: isMore
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 200),
                    firstChild: Text(
                      widget.shop.shopDescription,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    secondChild: Text(
                      widget.shop.shopDescription,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  InkWell(
                    onTap: () => setState(() => isMore = !isMore),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        isMore ? 'Read less' : 'Read more',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: buildInfoCard(
              title: "Address",
              icon: Icons.location_on,
              child: Text(
                widget.shop.shopAddress,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: buildInfoCard(
              title: "Shop Contacts ",
              icon: Icons.contact_phone,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  actionButton(
                    icon: Icons.phone,
                    label: 'Call',
                    onTap: () => launchPhone(widget.shop.shopContact),
                    color: Colors.green,
                  ),
                  actionButton(
                    icon: Icons.email,
                    label: 'Email',
                    onTap: () => launchEmail(widget.shop.shopEmail),
                    color: Colors.blue,
                  ),
                  actionButton(
                    icon: Icons.directions,
                    label: 'Directions',
                    onTap: () => launchMaps(
                      widget.shop.locationHistory.point.coordinates[1],
                      widget.shop.locationHistory.point.coordinates[0],
                    ),
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: shopTimingSection(),
          ),
          const SizedBox(height: 5),
          !widget.shop.isSubscriptionPurchased
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "My Shop Products",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 400,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                color: Colors.white.withOpacity(0.3),
                              ),
                              BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                                child: Container(color: Colors.transparent),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.lock_outline_rounded,
                                        size: 48,
                                        color: Colors.black87,
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        "You need a subscription to start adding products to your store.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black87,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.to(() => ShopPackages(
                                                shop: widget.shop,
                                                isAdditional: false,
                                              ));
                                        },
                                        icon: const Icon(Icons.star_rounded),
                                        label: const Text("Subscribe Now"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Shop Products",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () {
                                final stopwatch = Stopwatch();
                                print("StopWatch Started");
                                stopwatch.start();
                                Get.to(() => FilterOptions(),
                                    transition: Transition.fadeIn,
                                    duration:
                                        const Duration(milliseconds: 300));
                                print("StopWatch :${stopwatch.elapsed}");
                                stopwatch.stop();
                                // Get.bottomSheet(
                                //     BottomSheet(
                                //         backgroundColor: Colors.white,
                                //         onClosing: () {},
                                //         builder: (c) => FilterOptions()),
                                //     isDismissible: true,
                                //     isScrollControlled: true,
                                //     enableDrag: false);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.filter_list, size: 18),
                                    SizedBox(width: 6),
                                    Text("Filter",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<List<ProductModel>>(
                      future: controller.getShopProduct(widget.shop.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text("Error: ${snapshot.error}"),
                            ),
                          );
                        }
                        if (snapshot.data == null || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text("No products available"),
                            ),
                          );
                        }
                        Map<String, List<ProductModel>> categorizedProduct =
                            _organizeByCategories(snapshot.data!);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAllCategoriesList(categorizedProduct)
                          ],
                        );
                      },
                    ),
                  ],
                ),
          !widget.shop.isSubscriptionPurchased
              ? const SizedBox.shrink()
              : const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget userShopView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 150,
                  viewportFraction: 1.0,
                  autoPlay: true,
                  enlargeCenterPage: false,
                  autoPlayInterval: const Duration(seconds: 5),
                ),
                items: widget.shop.shopImage.map((imageUrl) {
                  return GestureDetector(
                    onTap: () => imageViewer(context, imageUrl, true),
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(toImageUrl(imageUrl)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              IgnorePointer(
                child: Container(
                  height: 150,
                  width: Get.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.shop.shopName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(blurRadius: 6, color: Colors.black54),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    GestureDetector(
                      onTap: _showShopDetailsSheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "View Shop Details",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Shop Products",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    // await Get.bottomSheet(
                    //     BottomSheet(
                    //         backgroundColor: Colors.white,
                    //         onClosing: () {},
                    //         builder: (c) => FilterOptions()),
                    //     isDismissible: true,
                    //     isScrollControlled: true,
                    //     enableDrag: false);
                    Get.to(() => const FilterOptions(),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 500));
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.filter_list, size: 18),
                        SizedBox(width: 6),
                        Text("Filter",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          FutureBuilder<List<ProductModel>>(
            future: controller.getShopProduct(widget.shop.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Failed to Load Product"),
                  ),
                );
              }

              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("No products available"),
                  ),
                );
              }
              Map<String, List<ProductModel>> categorizedProducts =
                  _organizeByCategories(snapshot.data!);

              return _buildAllCategoriesList(categorizedProducts);
            },
          ),
        ],
      ),
    );
  }

  void _showShopDetailsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        bool modelisMore = false;
        String currentDay = getCurrentDay();
        bool showModelAllTimings = false;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.storefront_outlined,
                        color: AppTheme.primaryColor),
                    title: Text(widget.shop.shopName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.description,
                        color: AppTheme.primaryColor),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedCrossFade(
                          crossFadeState: modelisMore
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 200),
                          firstChild: Text(
                            widget.shop.shopDescription,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                          secondChild: Text(
                            widget.shop.shopDescription,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              setModalState(() => modelisMore = !modelisMore),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              isMore ? 'Read less' : 'Read more',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on_outlined,
                        color: Colors.redAccent),
                    title: Text(widget.shop.shopAddress),
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.phone_outlined, color: Colors.green),
                    title: Text(widget.shop.shopContact),
                    onTap: () => launchPhone(widget.shop.shopContact),
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.email_outlined, color: Colors.blue),
                    title: Text(widget.shop.shopEmail),
                    onTap: () => launchEmail(widget.shop.shopEmail),
                  ),
                  GestureDetector(
                    onTap: () {
                      setModalState(() {
                        showModelAllTimings = !showModelAllTimings;
                      });
                    },
                    child: buildInfoCard(
                      title: "Shop Timings",
                      icon: Icons.access_time,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          showModelAllTimings
                              ? const Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                      "Tap to hide the full list of timings"))
                              : const Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                      "Tap to see the full list of shop timings")),
                          const SizedBox(height: 10),
                          if (!showModelAllTimings)
                            shopDayTimingRow(currentDay, widget.shop,
                                isHighlighted: true)
                          else
                            ...widget.shop.shopTiming?.entries.map((entry) {
                                  return shopDayTimingRow(
                                    entry.key,
                                    widget.shop,
                                    isHighlighted: entry.key == currentDay,
                                  );
                                }).toList() ??
                                [],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAllCategoriesList(
      Map<String, List<ProductModel>> categorizedProducts) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categorizedProducts.entries.map((entry) {
          return _buildCategorySection(entry.key, entry.value);
        }).toList());
  }

  Widget _buildCategorySection(String category, List<ProductModel> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ProductCard(
                product: products[index],
                shop: widget.shop,
                isAdmin: widget.isAdmin,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
