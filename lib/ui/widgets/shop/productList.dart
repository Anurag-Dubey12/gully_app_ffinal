import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gully_app/data/controller/shop_controller.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/shop/product_card.dart';

class ProductList extends StatefulWidget {
  final String shopId;
  final bool isAdmin;
  final ScrollController scrollController;
  const ProductList(
      {super.key,
      required this.shopId,
      this.isAdmin = false,
      required this.scrollController});
  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final controller = Get.find<ShopController>();
  List<ProductData> products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int page = 1;

  @override
  void initState() {
    super.initState();
    fetchShopProducts();

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels >=
              widget.scrollController.position.maxScrollExtent - 300 &&
          !_isLoading &&
          _hasMore) {
        fetchShopProducts();
      }
    });
  }

  Future<void> fetchShopProducts() async {
    setState(() => _isLoading = true);

    try {
      final newProducts = await controller.getShopProducts(widget.shopId, page);
      setState(() {
        products.addAll(newProducts);
        page++;
        _hasMore = newProducts.isNotEmpty;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Failed to get data:${e}");
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (products.isEmpty) {
      return const Center(child: Text("No products available"));
    }

    return ListView.builder(
      controller: widget.scrollController,
      itemCount: products.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == products.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final productData = products[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                scrollDirection: Axis.horizontal,
                itemCount: productData.product.length,
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
      },
    );
  }
}
