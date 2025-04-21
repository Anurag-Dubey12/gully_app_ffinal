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
import 'package:gully_app/utils/image_picker_helper.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/controller/shop_controller.dart';

class ShopDashboard extends StatefulWidget {
  final ShopModel shop;

  const ShopDashboard({Key? key, required this.shop}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<ShopDashboard>
    with AutomaticKeepAliveClientMixin {
  final ShopController controller = Get.find<ShopController>();
  String _selectedCategory = 'All';
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarCollapsed = false;
  bool _showAllTimings = false;
  bool isMore = false;
  List<String> categories = [];

  // Override to help with SurfaceView buffer issues
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load product data more efficiently
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadProductsForShop(widget.shop.id);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final double offset = _scrollController.offset;
    final bool isCollapsed = offset > 180;
    if (isCollapsed != _isAppBarCollapsed) {
      setState(() {
        _isAppBarCollapsed = isCollapsed;
      });
    }
  }

  Widget _buildTimingSection() {
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
              buildDayTimingRow(currentDay, widget.shop, isHighlighted: true)
            else
              ...widget.shop.shopTiming?.entries.map((entry) {
                    return buildDayTimingRow(
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
    super.build(context); // Required by AutomaticKeepAliveClientMixin

    return GradientBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "${widget.shop.shopName} Shop",
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
        body: RepaintBoundary(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                  child: _buildTimingSection(),
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<ProductModel>>(
                  future: controller.getShopProduct("67ea8204d3eaae65cdc7a455"),
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
          ),
        ),
      ),
    );
  }

  void filterOptions() {
    final List<String> sectionheader = [
      "Category",
      "Sub Category",
      "Brand",
      "Price"
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
                        onPressed: () {
                          // Reset filter logic
                        },
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
    switch (index) {
      case 0:
        return Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controller.productsCategory
                  .map((category) => CheckboxListTile.adaptive(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(category),
                        value: controller.category.contains(category),
                        onChanged: (value) {
                          if (value == true) {
                            controller.category.add(category);
                            controller.selectedCategory.value += 1;
                          } else {
                            controller.category.remove(category);
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
      case 3:
        return Obx(() {
          double currentValue = controller.higestPriceProduct.value;
          double maxPrice = controller.higestPriceProduct.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price Range: Up to ₹${currentValue.toStringAsFixed(0)}'),
              Slider(
                min: 0,
                max: maxPrice,
                value: currentValue == 0 ? maxPrice / 2 : currentValue,
                onChanged: (value) {
                  controller.higestPriceProduct.value = value;
                  setModalState(() {});
                },
              ),
            ],
          );
        });
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            padding: const EdgeInsets.symmetric(horizontal: 12),
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

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final ShopModel shop;
  const ProductCard({Key? key, required this.product, required this.shop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetailScreen(
              product: product,
              isadmin: true,
              shop: shop,
            ));
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12, bottom: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: 180,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: product.productsImage != null &&
                        product.productsImage!.isNotEmpty
                    ? Image.network(
                        toImageUrl(product.productsImage!.last),
                        width: Get.width,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.error, color: Colors.grey),
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/logo.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productBrand,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '₹${product.productsPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '₹1149',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '39% OFF',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
