import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/controller/shop_controller.dart';
import '../../widgets/gradient_builder.dart';
import 'ProductDetailScreen.dart';
import 'add_product.dart';

class ShopDashboard extends StatefulWidget {
  final String shopName;
  final String shopId;

  ShopDashboard({Key? key, required this.shopName, required this.shopId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<ShopDashboard> {
  final ShopController _shopController = Get.find<ShopController>();

  @override
  void initState() {
    super.initState();
    _shopController.loadProductsForShop(widget.shopId);
  }

  Map<String, List<Map<String, dynamic>>> _groupProductsByCategory() {
    Map<String, List<Map<String, dynamic>>> groupedProducts = {};
    for (var product in _shopController.products) {
      String category = product['category'] ?? 'Uncategorized';
      if (!groupedProducts.containsKey(category)) {
        groupedProducts[category] = [];
      }
      groupedProducts[category]!.add(product);
    }
    return groupedProducts;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/sports_icon.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: GradientBuilder(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              widget.shopName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: const BackButton(
              color: Colors.white,
            ),
          ),
          body: Obx(() {
            var groupedProducts = _groupProductsByCategory();
            return ListView.builder(
              itemCount: groupedProducts.length,
              itemBuilder: (context, index) {
                String category = groupedProducts.keys.elementAt(index);
                List<Map<String, dynamic>> products =
                    groupedProducts[category]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (context, productIndex) {
                          final product = products[productIndex];
                          return Container(
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                            margin: EdgeInsets.only(
                                left: 16,
                                right: productIndex == products.length - 1
                                    ? 16
                                    : 0),
                            child: Card(
                              child: InkWell(
                                onTap: () {
                                  Get.to(() =>
                                      ProductDetailScreen(product: product));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 100,
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: product['images'] != null &&
                                              product['images'].isNotEmpty
                                          ? Image.file(
                                              File(product['images'][0]),
                                              fit: BoxFit.cover)
                                          : Icon(Icons.image,
                                              color: Colors.grey[600]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              product['name'] ?? '',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                              'Price: ${product['price'] ?? 0}'),
                                          Text(
                                              'Discount: ${product['discount'] ?? 0}%'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  ],
                );
              },
            );
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Get.to(() => const AddProduct());
              if (result != null && result is List<Map<String, dynamic>>) {
                _shopController.addProductsToShop(widget.shopId, result);
              }
            },
            tooltip: 'Add Product',
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

