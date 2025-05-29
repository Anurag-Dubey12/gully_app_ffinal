import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/ui/screens/shop/Shop%20owner%20Screen/product_adding_screen.dart';
import 'package:gully_app/ui/screens/shop/Shop%20owner%20Screen/shop_analytics_screen.dart';
import 'package:gully_app/ui/screens/shop/User%20Screen/register_shop.dart';
import 'package:gully_app/ui/screens/shop/User%20Screen/shop_packages.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/home_screen/top_header.dart';
import 'package:gully_app/ui/widgets/shop/actionButton.dart';
import 'package:gully_app/ui/widgets/shop/build_info_card.dart';
import 'package:gully_app/ui/widgets/shop/build_timing_row.dart.dart';
import 'package:gully_app/ui/widgets/shop/filter_bottomsheet.dart';
import 'package:gully_app/ui/widgets/shop/product_card.dart';
import 'package:gully_app/utils/image_picker_helper.dart';
import 'package:gully_app/utils/launch_external_service.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../data/controller/shop_controller.dart';

class ShopDashboard extends StatefulWidget {
  final bool isAdmin;
  const ShopDashboard({Key? key, this.isAdmin = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<ShopDashboard> {
  final ShopController controller = Get.find<ShopController>();
  bool _showAllTimings = false;
  bool isMore = false;
  List<String> categories = [];
  final ScrollController scrollController = ScrollController();
  int _page = 1;
  bool _isLoadingMore = false;
  late final shop;
  bool _hasMore = true;
  List<ProductData> products = [];
  List<ProductData> filteredProducts = [];
  bool isFilterApplied = false;
  Widget shopTimingSection(ShopModel shop) {
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
              shopDayTimingRow(currentDay, shop, isHighlighted: true)
            else
              ...shop.shopTiming.entries.map((entry) {
                return shopDayTimingRow(
                  entry.key,
                  shop,
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
    shop = controller.shop.value;
    if (shop != null) fetchShopProducts(shop);
    // shop = controller.shop.value;
    controller.getShopImageCount(controller.shop.value!.id);
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 10 &&
          !_isLoadingMore &&
          _hasMore) {
        // fetchShopProducts(shop!);
        if (!isFilterApplied) {
          fetchShopProducts(shop!);
        }
      }
    });
  }

  Future<void> fetchShopProducts(ShopModel shop) async {
    setState(() => _isLoadingMore = true);
    try {
      final newProducts = await controller.getShopProducts(shop.id, _page);
      setState(() {
        products.addAll(controller.products.value);
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

  Future<void> fetchFilteredProducts(Map<String, dynamic> filterData) async {
    setState(() {
      _isLoadingMore = true;
      filteredProducts.clear();
    });

    try {
      final filteredResults = await controller.getFilterProduct(filterData);
      setState(() {
        filteredProducts = filteredResults;
        isFilterApplied = true;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Failed to get filtered data: ${e}");
      }
    } finally {
      setState(() => _isLoadingMore = false);
    }
  }

  void clearFilters() {
    setState(() {
      isFilterApplied = false;
      filteredProducts.clear();
      controller.appliedFilter.value = 0;
      controller.resetData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.appliedFilter.value = 0;
    controller.resetData();
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
              ? Obx(() {
                  final shop = controller.shop.value;
                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          shop!.shopName,
                          style: Get.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (getExpirationTag(shop) != null)
                        GestureDetector(
                          onTap: () {
                            final tag = getExpirationTag(shop);
                            if (tag != null && tag.startsWith("Expired")) {
                              Get.to(() => ShopPackages(
                                    shop: shop,
                                    isAdditional: false,
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
                              getExpirationTag(shop)!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                    ],
                  );
                })
              : Text(
                  shop.shopName,
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
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      Get.to(() => RegisterShop(shop: controller.shop.value),
                          transition: Transition.fadeIn,
                          duration: const Duration(milliseconds: 500));
                      break;
                    case 'analytics':
                      Get.to(
                          () => ShopAnalyticsScreen(
                                shopId: controller.shop.value!.id,
                              ),
                          transition: Transition.fadeIn,
                          duration: const Duration(milliseconds: 300));
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit Shop'),
                  ),
                  const PopupMenuItem(
                    value: 'analytics',
                    child: Text('View Shop Analytics'),
                  ),
                ],
              ),
          ],
        ),
        floatingActionButton: widget.isAdmin
            ? ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: FloatingActionButton(
                  onPressed: () async {
                    if (shop.isSubscriptionPurchased) {
                      if ((controller.totalPackagelimit.value -
                              controller.totalImagesAdded.value) >
                          0) {
                        final result = await Get.to(
                            () => AddProduct(shop: shop),
                            transition: Transition.fadeIn,
                            duration: const Duration(milliseconds: 500));
                        if (result != null &&
                            result is Map &&
                            result['IsDone'] == true) {
                          setState(() {
                            _page = 1;
                            products.clear();
                            _hasMore = true;
                          });
                          await fetchShopProducts(shop);
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
                                            shop: shop,
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
                      errorSnackBar(
                          "No active subscription found. Please subscribe to continue.");
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

  Future<void> refresh() async {
    setState(() {
      _page = 1;
      products.clear();
      _hasMore = true;
    });
    fetchShopProducts(shop);
  }

  Widget adminShopView() {
    return Obx(() {
      final shop = controller.shop.value;

      if (shop == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
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
                items: shop.shopImage.map((imageUrl) {
                  return Builder(
                    builder: (context) => GestureDetector(
                      onTap: () => imageViewer(context, imageUrl, true),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: toImageUrl(imageUrl),
                            imageBuilder: (context, imageProvider) => Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: Get.width,
                                height: 200,
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: Get.width,
                              height: 200,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(Icons.broken_image,
                                    size: 40, color: Colors.grey),
                              ),
                            ),
                          ),
                          Container(
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
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  shop.shopName,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
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
                          shop.shopDescription,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                        secondChild: Text(
                          shop.shopDescription,
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
                    shop.shopAddress,
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
                        onTap: () => launchPhone(shop.shopContact),
                        color: Colors.green,
                      ),
                      actionButton(
                        icon: Icons.email,
                        label: 'Email',
                        onTap: () => launchEmail(shop.shopEmail),
                        color: Colors.blue,
                      ),
                      actionButton(
                        icon: Icons.directions,
                        label: 'Directions',
                        onTap: () => launchMaps(
                          shop.locationHistory.point.coordinates[1],
                          shop.locationHistory.point.coordinates[0],
                        ),
                        color: Colors.orange,
                      ),
                      if (shop.shoplink != null)
                        actionButton(
                          icon: Icons.phone,
                          label: 'Website',
                          onTap: () => launchWebsite(shop.shoplink ?? ''),
                          color: Colors.deepPurple,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: shopTimingSection(shop),
              ),
              const SizedBox(height: 5),
              shop.packageEndDate == null
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
                                    filter: ImageFilter.blur(
                                        sigmaX: 50, sigmaY: 50),
                                    child: Container(color: Colors.transparent),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () {
                                              Get.to(() => ShopPackages(
                                                    shop: shop,
                                                    isAdditional: false,
                                                  ));
                                            },
                                            icon:
                                                const Icon(Icons.star_rounded),
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
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: GestureDetector(
                                      onTap: () async {
                                        final res = await Get.to(
                                            () => const FilterOptions(),
                                            transition: Transition.fadeIn,
                                            duration: const Duration(
                                                milliseconds: 500));
                                        if (res != null && res is Map) {
                                          bool isFilterEmpty =
                                              (res['category'] == null ||
                                                      res['category']
                                                          .isEmpty) &&
                                                  (res['subcategory'] == null ||
                                                      res['subcategory']
                                                          .isEmpty) &&
                                                  (res['brand'] == null ||
                                                      res['brand'].isEmpty);

                                          if (isFilterEmpty) {
                                            clearFilters();
                                          } else {
                                            Map<String, dynamic> filterData = {
                                              "productCategory":
                                                  res['category'],
                                              "productSubCategory":
                                                  res['subcategory'],
                                              "productBrand": res['brand'],
                                              "shopId":
                                                  controller.shop.value!.id,
                                              "page": 1
                                            };

                                            await fetchFilteredProducts(
                                                filterData);
                                            controller.appliedFilter.value =
                                                getAppliedFilterSectionCount(
                                                    res);
                                          }
                                        }
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                          ),
                                          child: Stack(
                                            children: [
                                              const Row(
                                                children: [
                                                  Icon(Icons.filter_list,
                                                      size: 18,
                                                      color: Colors.black87),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    "Filter",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black87),
                                                  ),
                                                ],
                                              ),
                                              if (controller
                                                      .appliedFilter.value >
                                                  0)
                                                Obx(
                                                  () => Positioned(
                                                    left: 7,
                                                    top: 1,
                                                    child: Container(
                                                      width: 10,
                                                      height: 10,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.red,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "${controller.appliedFilter.value}",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          )),
                                    ),
                                  ),
                                  if (isFilterApplied)
                                    Container(
                                      constraints:
                                          const BoxConstraints(minWidth: 80),
                                      padding: const EdgeInsets.only(right: 5),
                                      child: GestureDetector(
                                        onTap: clearFilters,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.red.shade200),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.clear,
                                                  size: 16, color: Colors.red),
                                              SizedBox(width: 4),
                                              Text(
                                                "Clear",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        if ((isFilterApplied ? filteredProducts : products)
                                .isEmpty &&
                            _isLoadingMore)
                          const Center(child: CircularProgressIndicator())
                        else if ((isFilterApplied ? filteredProducts : products)
                            .isEmpty)
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Icon(
                                  isFilterApplied
                                      ? Icons.filter_list_off
                                      : Icons.shopping_bag_outlined,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  isFilterApplied
                                      ? "No products match your filter criteria"
                                      : "No products available",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                                if (isFilterApplied)
                                  TextButton(
                                    onPressed: clearFilters,
                                    child: const Text("Clear Filter"),
                                  ),
                              ],
                            ),
                          ))
                        else
                          ...(isFilterApplied ? filteredProducts : products)
                              .map((productData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    itemBuilder: (context, index) {
                                      return ProductCard(
                                        product: productData.product[index],
                                        isAdmin: widget.isAdmin,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          }),
                        if (_isLoadingMore && !isFilterApplied)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.hourglass_top,
                                      size: 32, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text(
                                    "Hang on, your data is being loaded...",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
              !shop.isSubscriptionPurchased
                  ? const SizedBox.shrink()
                  : const SizedBox(height: 16),
            ],
          ),
        ),
      );
    });
  }

  Widget userShopView() {
    return Obx(() {
      final shop = controller.shop.value;
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
                  items: shop!.shopImage.map((imageUrl) {
                    return GestureDetector(
                      onTap: () => imageViewer(context, imageUrl, true),
                      child: CachedNetworkImage(
                        imageUrl: toImageUrl(imageUrl),
                        imageBuilder: (context, imageProvider) => Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: Get.width,
                            height: 150,
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: Get.width,
                          height: 150,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image,
                              color: Colors.grey, size: 40),
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
                        shop.shopName,
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
                        onTap: () => _showShopDetailsSheet(shop),
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
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () async {
                            final res = await Get.to(
                                () => const FilterOptions(),
                                transition: Transition.fadeIn,
                                duration: const Duration(milliseconds: 500));
                            if (res != null && res is Map) {
                              bool isFilterEmpty = (res['category'] == null ||
                                      res['category'].isEmpty) &&
                                  (res['subcategory'] == null ||
                                      res['subcategory'].isEmpty) &&
                                  (res['brand'] == null ||
                                      res['brand'].isEmpty);

                              if (isFilterEmpty) {
                                clearFilters();
                              } else {
                                Map<String, dynamic> filterData = {
                                  "productCategory": res['category'],
                                  "productSubCategory": res['subcategory'],
                                  "productBrand": res['brand'],
                                  "shopId": controller.shop.value!.id,
                                  "page": 1
                                };

                                await fetchFilteredProducts(filterData);
                                controller.appliedFilter.value =
                                    getAppliedFilterSectionCount(res);
                              }
                            }
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Stack(
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.filter_list,
                                          size: 18, color: Colors.black87),
                                      SizedBox(width: 6),
                                      Text(
                                        "Filter",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                  if (controller.appliedFilter.value > 0)
                                    Obx(
                                      () => Positioned(
                                        left: 7,
                                        top: 1,
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "${controller.appliedFilter.value}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              )),
                        ),
                      ),
                      if (isFilterApplied)
                        Container(
                          constraints: const BoxConstraints(minWidth: 80),
                          padding: const EdgeInsets.only(right: 5),
                          child: GestureDetector(
                            onTap: clearFilters,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.clear,
                                      size: 16, color: Colors.red),
                                  SizedBox(width: 4),
                                  Text(
                                    "Clear",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            if ((isFilterApplied ? filteredProducts : products).isEmpty &&
                _isLoadingMore)
              const Center(child: CircularProgressIndicator())
            else if ((isFilterApplied ? filteredProducts : products).isEmpty)
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      isFilterApplied
                          ? Icons.filter_list_off
                          : Icons.shopping_bag_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isFilterApplied
                          ? "No products match your filter criteria"
                          : "No products available",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    if (isFilterApplied)
                      TextButton(
                        onPressed: clearFilters,
                        child: const Text("Clear Filter"),
                      ),
                  ],
                ),
              ))
            else
              ...(isFilterApplied ? filteredProducts : products)
                  .map((productData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
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
                          return ProductCard(
                            product: productData.product[index],
                            isAdmin: widget.isAdmin,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }),
            if (_isLoadingMore && !isFilterApplied)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.hourglass_top, size: 32, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        "Hang on, your data is being loaded...",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      );
    });
  }

  int getAppliedFilterSectionCount(Map res) {
    int count = 0;

    if (res['category'] != null &&
        ((res['category'] is String && res['category'].toString().isNotEmpty) ||
            (res['category'] is List && res['category'].isNotEmpty))) {
      count++;
    }
    if (res['subcategory'] != null &&
        ((res['subcategory'] is String &&
                res['subcategory'].toString().isNotEmpty) ||
            (res['subcategory'] is List && res['subcategory'].isNotEmpty))) {
      count++;
    }
    if (res['brand'] != null &&
        ((res['brand'] is String && res['brand'].toString().isNotEmpty) ||
            (res['brand'] is List && res['brand'].isNotEmpty))) {
      count++;
    }

    return count;
  }

  void _showShopDetailsSheet(ShopModel shop) {
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
                    title: Text(shop.shopName,
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
                            shop.shopDescription,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                          secondChild: Text(
                            shop.shopDescription,
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
                    title: Text(shop.shopAddress),
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.phone_outlined, color: Colors.green),
                    title: Text(shop.shopContact),
                    onTap: () => launchPhone(shop.shopContact),
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.email_outlined, color: Colors.blue),
                    title: Text(shop.shopEmail),
                    onTap: () => launchEmail(shop.shopEmail),
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
                            shopDayTimingRow(currentDay, shop,
                                isHighlighted: true)
                          else
                            ...shop.shopTiming.entries.map((entry) {
                              return shopDayTimingRow(
                                entry.key,
                                shop,
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
