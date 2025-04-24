import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/product_model.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/ui/screens/shop/User%20Screen/product_detail_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/ui/widgets/shop/actionButton.dart';
import 'package:gully_app/ui/widgets/shop/build_info_card.dart';
import 'package:gully_app/ui/widgets/shop/build_timing_row.dart.dart';
import 'package:gully_app/ui/widgets/shop/product_card.dart';
import 'package:gully_app/utils/image_picker_helper.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _launchEmail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _launchMaps(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Maps';
    }
  }

  Map<String, List<ProductModel>> _organizeByCategories(
      List<ProductModel> products) {
    final Map<String, List<ProductModel>> categorizedProducts = {};
    for (var product in products) {
      if (!categorizedProducts.containsKey(product.productCategory)) {
        categorizedProducts[product.productCategory] = [];
      }
      categorizedProducts[product.productCategory]!.add(product);
    }
    return categorizedProducts;
  }

  @override
  Widget build(BuildContext context) {
    return GradientBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
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
        ),
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
                    onTap: () => _launchPhone(widget.shop.shopContact),
                    color: Colors.green,
                  ),
                  actionButton(
                    icon: Icons.email,
                    label: 'Email',
                    onTap: () => _launchEmail(widget.shop.shopEmail),
                    color: Colors.blue,
                  ),
                  actionButton(
                    icon: Icons.directions,
                    label: 'Directions',
                    onTap: () => _launchMaps(
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
          const SizedBox(height: 10),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Products",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () => filterOptions(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.grey[400]!, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'Filter',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.filter,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAllCategoriesList(categorizedProduct)
                ],
              );
            },
          ),
          const SizedBox(height: 16),
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
                  onTap: () => filterOptions(),
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
                    onTap: () => _launchPhone(widget.shop.shopContact),
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.email_outlined, color: Colors.blue),
                    title: Text(widget.shop.shopEmail),
                    onTap: () => _launchEmail(widget.shop.shopEmail),
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

  void filterOptions() {
    final List<String> sectionheader = [
      "Category",
      "Sub Category",
      "Brand",
    ];
    int selectedIndex = 0;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SizedBox(
              height: Get.height * 0.7,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text('Filter Product',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        child: const Text('Reset',
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          color: Colors.grey.shade200,
                          child: ListView.builder(
                            itemCount: sectionheader.length,
                            itemBuilder: (context, index) {
                              final isSelected = index == selectedIndex;
                              return GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 12),
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey.shade200,
                                  child: Text(
                                    sectionheader[index],
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              getFilterContent(selectedIndex, setModalState)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: PrimaryButton(
                        onTap: () {},
                        title: "Apply Filter",
                      )),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget getFilterContent(int index, StateSetter setModalState) {
    final controller = Get.find<ShopController>();
    controller.getCategory();
    switch (index) {
      case 0:
        return Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controller.category
                  .map((category) => CheckboxListTile.adaptive(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(category),
                        value: controller.selectedcategory.contains(category),
                        onChanged: (value) {
                          if (value == true) {
                            controller.selectedcategory.add(category);
                            controller.selectedCategory.value += 1;
                          } else {
                            controller.selectedcategory.remove(category);
                            controller.selectedCategory.value -= 1;
                          }
                          setModalState(() {});
                        },
                      ))
                  .toList(),
            ));
      case 1:
        return Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controller.productssubCategory
                  .map((subCat) => CheckboxListTile.adaptive(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(subCat),
                        value: controller.subcategory.contains(subCat),
                        onChanged: (value) {
                          if (value == true) {
                            controller.subcategory.add(subCat);
                            controller.selectedsubCategory.value += 1;
                          } else {
                            controller.subcategory.remove(subCat);
                            controller.selectedsubCategory.value -= 1;
                          }
                          setModalState(() {});
                        },
                      ))
                  .toList(),
            ));
      case 2:
        return Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controller.productsBrand
                  .map((brand) => CheckboxListTile.adaptive(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(brand),
                        value: controller.brands.contains(brand),
                        onChanged: (value) {
                          if (value == true) {
                            controller.brands.add(brand);
                            controller.selectedbrand.value += 1;
                          } else {
                            controller.brands.remove(brand);
                            controller.selectedbrand.value -= 1;
                          }
                          setModalState(() {});
                        },
                      ))
                  .toList(),
            ));
      default:
        return const SizedBox.shrink();
    }
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
            physics: const BouncingScrollPhysics(), // Improved scroll physics
            itemBuilder: (context, index) {
              return ProductCard(
                product: products[index],
                shop: widget.shop,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
