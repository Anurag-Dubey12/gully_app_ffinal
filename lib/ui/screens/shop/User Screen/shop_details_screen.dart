import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/theme.dart';
import 'product_detail_screen.dart';

class ShopDetailsScreen extends StatefulWidget {
  final ShopModel shop;
  const ShopDetailsScreen({super.key, required this.shop});

  @override
  State<StatefulWidget> createState() => DetailsState();
}

class DetailsState extends State<ShopDetailsScreen> {
  String selectedMainCategory = 'All';
  String? selectedSubCategory;
  List<dynamic> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    // filteredProducts = List.from(widget.shop['products'] ?? []);
  }

  // void applyFilter(String mainCategory, String? subCategory) {
  //   setState(() {
  //     selectedMainCategory = mainCategory;
  //     selectedSubCategory = subCategory;
  //     if (mainCategory == 'All') {
  //       filteredProducts = List.from(widget.shop['products'] ?? []);
  //     } else if (subCategory == null) {
  //       filteredProducts = (widget.shop['products'] as List<dynamic>? ?? [])
  //           .where((product) => product['category'] == mainCategory)
  //           .toList();
  //     } else {
  //       filteredProducts = (widget.shop['products'] as List<dynamic>? ?? [])
  //           .where((product) =>
  //               product['category'] == mainCategory &&
  //               product['subcategory'] == subCategory)
  //           .toList();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text("Shop Details",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(
                        widget.shop.shopImage.first,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.shop.shopName,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.shop.shopAddress,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[800]),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          // productList("Best Sellers", product, shopNumber),
          // const SizedBox(height: 10),
          // productList("New Arrivals", product, shopNumber),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Product",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[400]!, width: 1),
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
                            Iconsax.filter,
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
          filteredProducts.isEmpty
              ? const Center(
                  child: Text("No Data Found"),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return productCard(product, "7328783272837238");
                  },
                ),
        ],
      ),
    );
  }

  Widget productCard(Map<String, dynamic> product, String shopNumber) {
    final totalDiscount = product['discount'] != null
        ? double.parse(product['discount'].toString())
        : 0.0;
    final totalPrice = product['price'] != null
        ? double.parse(product['price'].toString())
        : 0.0;
    final discountPrice = totalPrice - totalDiscount;
    final hasDiscount = totalDiscount > 0;

    return GestureDetector(
      onTap: () {
        // Get.to(() => ProductDetailScreen(
        //       product: product,
        //       isadmin: false,
        //     ));
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(4)),
                child: Image.asset(
                  product['image'] ?? 'assets/images/logo.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (hasDiscount)
                    Row(
                      children: [
                        Text(
                          '₹${totalPrice.toInt()}',
                          style: const TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '₹${discountPrice.toInt()}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      '₹${totalPrice.toInt()}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    '₹ ${product['discount']} Flat Off',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _launchCaller(shopNumber),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white),
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.call, size: 20, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              "Call Owner",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget productList(String title, List<dynamic> products, String shopNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final totalDiscount = product['discount'] != null
                  ? double.parse(product['discount'].toString())
                  : 0.0;
              final totalPrice = product['price'] != null
                  ? double.parse(product['price'].toString())
                  : 0.0;
              final discountPrice = totalPrice - totalDiscount;
              final hasDiscount = totalDiscount > 0;
              return GestureDetector(
                onTap: () {
                  // Get.to(() => ProductDetailScreen(
                  //       product: product,
                  //       isadmin: false,
                  //     ));
                },
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey, width: 0.5)),
                  margin: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            color: Colors.grey[200],
                          ),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: Image.asset(
                                  product['image'] ?? 'assets/images/logo.png',
                                ),
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
                              product['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            if (hasDiscount)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '₹${totalPrice.toInt()}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '₹${discountPrice.toInt()}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Text(
                                '₹${totalPrice.toInt()}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              '₹ ${product['discount']} Flat Off',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _launchCaller(shopNumber),
                              child: Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.call,
                                          size: 20, color: Colors.white),
                                      SizedBox(width: 5),
                                      Center(
                                        child: Text(
                                          "Call  Owner",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
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
  }

  void _launchCaller(String phoneNumber) async {
    final url = "tel:$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
