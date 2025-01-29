import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/theme/theme.dart';
import '../../../data/controller/shop_controller.dart';
import '../../widgets/gradient_builder.dart';
import 'product_detail_screen.dart';
import 'add_product.dart';

class ShopDashboard extends StatefulWidget {
  final String shopName;
  final String shopId;

  const ShopDashboard({Key? key, required this.shopName, required this.shopId})
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
                      final totalDiscount = product['discount'] != null
                          ? double.parse(product['discount'].toString())
                          : 0.0;
                      final totalPrice = product['price'] != null
                          ? double.parse(product['price'].toString())
                          : 0.0;
                      final discountPrice = totalPrice - totalDiscount;

                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey)),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => ProductDetailScreen(product: product,isadmin: true,));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                    color: Colors.grey[200],
                                  ),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: product['images'] != null &&
                                            product['images'].isNotEmpty
                                            ? Image.file(
                                          File(product['images'][0]),
                                          fit: BoxFit.cover,
                                        )
                                            : Icon(Icons.image,
                                            color: Colors.grey[600], size: 50),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['discount'] != null
                                          ? '₹$discountPrice'
                                          : '₹$totalPrice',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    if (product['discount'] != null)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '₹${product['price'] ?? 0}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.grey,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            '₹ ${product['discount']} Flat Off',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    Text('${product['name'] ?? 0}'),
                                    Text('${product['Quantity'] ?? 0}'),
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
          floatingActionButton: ClipOval(
            child: FloatingActionButton(
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
      ),
    );
  }
}
