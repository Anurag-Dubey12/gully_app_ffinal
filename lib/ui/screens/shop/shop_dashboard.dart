import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/theme/theme.dart';
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
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _shopController.loadProductsForShop(widget.shopId);
  }

  List<String> _getCategories() {
    Set<String> categories = {'All'};
    for (var product in _shopController.products) {
      categories.add(product['category'] ?? 'Uncategorized');
    }
    return categories.toList();
  }

  List<Map<String, dynamic>> _getProductsForCategory(String category) {
    if (category == 'All') {
      return _shopController.products;
    }
    return _shopController.products
        .where((product) => product['category'] == category)
        .toList();
  }

  Widget CategoryButton(String category) {
    bool isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedCategory = category;
          });
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.black,
          backgroundColor: isSelected ? AppTheme.primaryColor : Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: const BorderSide(color: Colors.black)),
        ),
        child: Text(category),
      ),
    );
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
            var categories = _getCategories();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(
                    "Categories",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: categories
                        .map((category) => CategoryButton(category))
                        .toList(),
                  ),
                ),
                // Product grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount:
                        _getProductsForCategory(_selectedCategory).length,
                    itemBuilder: (context, index) {
                      final product =
                          _getProductsForCategory(_selectedCategory)[index];
                      return Card(
                        child: InkWell(
                          onTap: () {
                            Get.to(() => ProductDetailScreen(product: product));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: Get.width,
                                  child: product['images'] != null &&
                                          product['images'].isNotEmpty
                                      ? Image.file(File(product['images'][0]),
                                          fit: BoxFit.cover)
                                      : Icon(Icons.image,
                                          color: Colors.grey[600]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          product['name'] ?? '',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text('₹${product['price'] ?? 0}'),
                                      ],
                                    ),
                                    Text('${product['subcategory'] ?? 0}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Get.to(() => const AddProduct());
              if (result != null && result is List<Map<String, dynamic>>) {
                _shopController.updateProductForShop(
                    widget.shopId, '0001', result as Map<String, dynamic>);
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
