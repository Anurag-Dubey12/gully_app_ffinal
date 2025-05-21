import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/shop_controller.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/data/model/product_model.dart';
import 'package:gully_app/ui/screens/shop/Shop%20owner%20Screen/shop_dashboard.dart';
import 'package:gully_app/ui/screens/shop/User%20Screen/nearby_shop_screen.dart';
import 'package:gully_app/ui/screens/shop/User%20Screen/product_detail_screen.dart';
import 'package:gully_app/ui/screens/shop/User%20Screen/search_full_result.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/utils.dart';

class SearchResultItem {
  final ShopModel? shop;
  final ProductModel? product;

  SearchResultItem({this.shop, this.product});
}

class ShopSearchScreen extends StatefulWidget {
  final String? searchQuery;
  const ShopSearchScreen({super.key, this.searchQuery});

  @override
  State<ShopSearchScreen> createState() => _ShopSearchScreenState();
}

class _ShopSearchScreenState extends State<ShopSearchScreen> {
  final shopController = Get.find<ShopController>();
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  void onSearchTextChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      shopController.searchShopsAndProducts(query);
    });
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();

    super.dispose();
  }

  List<SearchResultItem> getMixedResults() {
    final shops = shopController.searchedShops
        .map((s) => SearchResultItem(shop: s))
        .toList();
    final products = shopController.searchedProducts
        .map((p) => SearchResultItem(product: p))
        .toList();
    final combined = [...shops, ...products]..shuffle(Random());
    return combined;
  }

  Widget buildShopCard(ShopModel shop) {
    final imageUrl = shop.shopImage.isNotEmpty ? shop.shopImage.first : null;

    return GestureDetector(
      onTap: () {
        final shopController = Get.find<ShopController>();
        shopController.shop.value = shop;
        Get.to(() => const ShopDashboard(
              isAdmin: false,
            ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: imageUrl != null
                ? Image.network(
                    toImageUrl(imageUrl),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.store, size: 40),
          ),
          title: Text(shop.shopName, style: const TextStyle(fontSize: 14)),
          subtitle: Text(
            shop.shopAddress,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }

  Widget buildProductCard(ProductModel product) {
    final imageUrl =
        (product.productsImage != null && product.productsImage!.isNotEmpty)
            ? product.productsImage!.first
            : null;

    return GestureDetector(
      onTap: () {
        final controller = Get.find<ShopController>();
        controller.shopProduct.value = product;
        Get.to(() => ProductDetailScreen(
              isadmin: false,
            ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: imageUrl != null
                ? Image.network(
                    toImageUrl(imageUrl),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image_not_supported, size: 40),
          ),
          title:
              Text(product.productName, style: const TextStyle(fontSize: 14)),
          subtitle: Text(
            "₹${product.productsPrice.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 12, color: Colors.green),
          ),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff3F5BBF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: TextField(
          controller: searchController,
          onChanged: onSearchTextChanged,
          autofocus: true,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: "Search for shops or products...",
            border: InputBorder.none,
            hintStyle: const TextStyle(color: Colors.white),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      searchController.clear();
                      shopController.searchedShops.clear();
                      shopController.searchedProducts.clear();
                      setState(() {});
                    },
                  )
                : null,
          ),
          onSubmitted: (query) {
            if (searchController.text.isNotEmpty) {
              shopController.searchQuery.value = searchController.text;
              Get.to(
                  () => SearchFullResult(
                        searchQuery: shopController.searchQuery.value,
                      ),
                  transition: Transition.fadeIn,
                  duration: const Duration(milliseconds: 300));
            }
          },
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (shopController.isSearching.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (searchController.text.isEmpty) {
          return const Center(
              child: Text("Search for nearby shops or products"));
        }

        final results = getMixedResults();

        if (results.isEmpty) {
          return const Center(child: Text("No results found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final item = results[index];
            if (item.shop != null) {
              return buildShopCard(item.shop!);
            } else if (item.product != null) {
              return buildProductCard(item.product!);
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      }),
    );
  }
}
