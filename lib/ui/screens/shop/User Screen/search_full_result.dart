import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/shop_controller.dart';
import 'package:gully_app/data/model/product_model.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/ui/screens/shop/User%20Screen/nearby_shop_screen.dart';
import 'package:gully_app/ui/screens/shop/User%20Screen/product_detail_screen.dart';
import 'package:gully_app/ui/screens/shop/User%20Screen/shop_search_screen.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/shop/product_card.dart';
import 'package:gully_app/utils/utils.dart';

class SearchFullResult extends StatefulWidget {
  final String searchQuery;
  const SearchFullResult({super.key, required this.searchQuery});

  @override
  State<SearchFullResult> createState() => _SearchFullResultState();
}

class _SearchFullResultState extends State<SearchFullResult>
    with SingleTickerProviderStateMixin {
  final shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GradientBuilder(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: SafeArea(
              child: AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                titleSpacing: 5,
                title: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      GestureDetector(
                        onTap: () => Get.to(
                          () => ShopSearchScreen(
                              searchQuery: shopController.searchQuery.value),
                          transition: Transition.fadeIn,
                          duration: const Duration(milliseconds: 300),
                        ),
                        child: Container(
                          height: 42,
                          width: Get.width * 0.83,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Colors.grey),
                              const SizedBox(width: 10),
                              Obx(() => Text(
                                    shopController.searchQuery.value,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(48),
                  child: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: Colors.white,
                    indicatorWeight: 2.5,
                    tabs: [
                      Tab(text: 'Shops'),
                      Tab(text: 'Products'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Obx(() {
            final shops = shopController.searchedShops;
            final products = shopController.searchedProducts;
            final isLoading = shopController.isSearching.value;
            final corrected = shopController.correctedQuery.value.trim();
            final original = shopController.originalQuery.value.trim();

            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Obx(() {
                  if (shopController.iscorrectedQuery.value) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: RichText(
                              text: TextSpan(
                                text: 'Showing results for ',
                                style: const TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: '"$corrected"',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Search instead for "$original"',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
                Expanded(
                  child: TabBarView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (shops.isEmpty)
                            const Expanded(
                              child: Center(child: Text("No shops found")),
                            )
                          else
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                itemCount: shops.length,
                                itemBuilder: (context, index) {
                                  return NearbyShopCard(shop: shops[index]);
                                },
                              ),
                            ),
                        ],
                      ),
                      products.isEmpty
                          ? const Center(child: Text("No products found"))
                          : Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: ListView.separated(
                                  itemCount: products.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 10,
                                  ),
                                  itemBuilder: (context, index) {
                                    return SearchResultProductCard(
                                      product: products[index],
                                      isAdmin: false,
                                    );
                                  },
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class SearchResultProductCard extends StatelessWidget {
  final ProductModel product;
  final ShopModel? shop;
  final bool isAdmin;

  const SearchResultProductCard({
    Key? key,
    required this.product,
    this.shop,
    this.isAdmin = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductDiscount? discount = product.productDiscount;
    String percentageoff = '';
    if (discount != null && discount.discountType == 'percent') {
      final remainingPercentage = 100 - discount.discountPrice;
      percentageoff = '${remainingPercentage.toStringAsFixed(2)}% OFF';
      print("percentageoff: $percentageoff");
    }

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailScreen(
            product: product,
            isadmin: isAdmin,
            shop: shop,
          )),
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 180,
              width: 130,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: product.productsImage != null &&
                        product.productsImage!.isNotEmpty
                    ? Image.network(
                        toImageUrl(product.productsImage!.first),
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  ),
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                                child: Icon(Icons.error, color: Colors.grey)),
                      )
                    : Image.asset('assets/images/logo.png', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productBrand,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.productName,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (product.productsDescription != null)
                    Text(
                      product.productsDescription!,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  const SizedBox(height: 2),
                  discount?.discountType == "percent"
                      ? FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Text(
                                '₹${discount!.discountPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '₹${product.productsPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                percentageoff,
                                style: const TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
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
                                'Fixed Price',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
