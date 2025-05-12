import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/ui/screens/shop/Shop%20owner%20Screen/product_adding_screen.dart';
import 'package:gully_app/ui/screens/shop/User%20Screen/register_shop.dart';
import 'package:gully_app/ui/screens/shop/User%20Screen/shop_packages.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/shop/actionButton.dart';
import 'package:gully_app/ui/widgets/shop/build_info_card.dart';
import 'package:gully_app/ui/widgets/shop/build_timing_row.dart.dart';
import 'package:gully_app/ui/widgets/shop/filter_bottomsheet.dart';
import 'package:gully_app/ui/widgets/shop/product_card.dart';
import 'package:gully_app/utils/image_picker_helper.dart';
import 'package:gully_app/utils/launch_external_service.dart';
import 'package:gully_app/utils/utils.dart';

import '../../../../data/controller/shop_controller.dart';

class ShopDashboard extends StatefulWidget {
  final ShopModel shop;
  final bool isAdmin;
  const ShopDashboard({Key? key, required this.shop, this.isAdmin = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<ShopDashboard> {
  final ShopController controller = Get.find<ShopController>();
  bool _showAllTimings = false;
  bool isMore = false;
  List<String> categories = [];
  late Future<List<ProductData>> _shopProductsFuture;
  final ScrollController scrollController = ScrollController();
  int _page = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  List<ProductData> products = [];
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
              ...widget.shop.shopTiming.entries.map((entry) {
                return shopDayTimingRow(
                  entry.key,
                  widget.shop,
                  isHighlighted: entry.key == currentDay,
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchShopProducts();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 10 &&
          !_isLoadingMore &&
          _hasMore) {
        fetchShopProducts();
      }
    });
  }

  Future<void> fetchShopProducts() async {
    setState(() => _isLoadingMore = true);
    try {
      final newProducts =
          await controller.getShopProducts(widget.shop.id, _page);
      setState(() {
        products.addAll(newProducts);
        _page++;
        _hasMore = newProducts.isNotEmpty;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Failed to get data:${e}");
      }
    } finally {
      setState(() => _isLoadingMore = false);
    }
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
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (getExpirationTag(widget.shop) != null)
                      GestureDetector(
                        onTap: () {
                          final tag = getExpirationTag(widget.shop);
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
                            getExpirationTag(widget.shop)!,
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
          actions: [
            if (widget.isAdmin)
              IconButton(
                icon: const Icon(Icons.mode_edit_rounded, color: Colors.white),
                onPressed: () {
                  Get.to(() => RegisterShop(
                        shop: widget.shop,
                      ));
                },
              ),
          ],
        ),
        floatingActionButton: widget.isAdmin
            ? ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: FloatingActionButton(
                  onPressed: () async {
                    print(controller.totalImagesAdded.value);
                    if (widget.shop.isSubscriptionPurchased) {
                      if (controller.totalImagesAdded.value <=
                          controller.totalPackagelimit.value) {
                        final result = await Get.to(
                            () => AddProduct(shop: widget.shop),
                            transition: Transition.fadeIn,
                            duration: const Duration(milliseconds: 500));
                        if (result != null &&
                            result is Map &&
                            result['IsDone'] == true) {
                          // setState(() {
                          //   _shopProductsFuture =
                          //       controller.getShopProducts(widget.shop.id, 1);
                          // });
                          fetchShopProducts();
                        }
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
      controller: scrollController,
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

                          //TODO: Need to look out filter section Entire
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () async {
                                final res = await Get.to(() => FilterOptions(),
                                    transition: Transition.fadeIn,
                                    duration:
                                        const Duration(milliseconds: 300));
                                if (res != null && res is Map) {}
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
                    const SizedBox(height: 4),
                    if (products.isEmpty && _isLoadingMore)
                      const Center(child: CircularProgressIndicator())
                    else if (products.isEmpty)
                      const Center(
                          child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("No products available"),
                      ))
                    else
                      ...products.map((productData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Text(
                                productData.category,
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
                                scrollDirection: Axis.horizontal,
                                itemCount: productData.product.length,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                itemBuilder: (context, index) {
                                  return ProductCard(
                                      product: productData.product[index]);
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }),
                    if (_isLoadingMore)
                      const Center(
                          child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: CircularProgressIndicator(),
                      )),
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
      controller: scrollController,
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
          const SizedBox(height: 4),
          if (products.isEmpty && _isLoadingMore)
            const Center(child: CircularProgressIndicator())
          else if (products.isEmpty)
            const Center(
                child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("No products available"),
            ))
          else
            ...products.map((productData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Text(
                      productData.category,
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
                      scrollDirection: Axis.horizontal,
                      itemCount: productData.product.length,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemBuilder: (context, index) {
                        return ProductCard(product: productData.product[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }),
          if (_isLoadingMore)
            const Center(
                child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(),
            )),
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
                            ...widget.shop.shopTiming.entries.map((entry) {
                              return shopDayTimingRow(
                                entry.key,
                                widget.shop,
                                isHighlighted: entry.key == currentDay,
                              );
                            }).toList(),
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
}
