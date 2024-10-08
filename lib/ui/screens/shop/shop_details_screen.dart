import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/theme.dart';
import 'product_detail_screen.dart';

class ShopDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> shop;
  const ShopDetailsScreen({super.key, required this.shop});

  @override
  State<StatefulWidget> createState() => DetailsState();
}

class DetailsState extends State<ShopDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final products = widget.shop['products'] as List<dynamic>? ?? [];
    final shopNumber=widget.shop['shop_number'];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop Details",
            style: TextStyle(color: Colors.black, fontSize: 20)),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.favorite_border, color: Colors.black),
          //   onPressed: () {},
          // ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
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
                      radius: 40,
                      backgroundImage: AssetImage(
                        widget.shop['logo'] ?? 'assets/images/logo.png',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.shop['name'],
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.shop['details'],
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.shop['location'],
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          productList("Latest products", products,shopNumber),
          const SizedBox(height: 10),
          productList("Featured products", products,shopNumber),
          // const SizedBox(height: 10),
          // productList("Hot Deals", products,shop_number),
          const SizedBox(height: 10),

          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     const Padding(
          //       padding: EdgeInsets.all(16),
          //       child: Text(
          //         'All Products',
          //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //     ListView.builder(
          //       shrinkWrap: true,
          //       physics: const NeverScrollableScrollPhysics(),
          //       itemCount: products.length,
          //       itemBuilder: (context, index) {
          //         final product = products[index];
          //         return Card(
          //           margin: const EdgeInsets.symmetric(
          //               horizontal: 16, vertical: 8),
          //           elevation: 3,
          //           shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(12)),
          //           child: Padding(
          //             padding: const EdgeInsets.all(12.0),
          //             child: Row(
          //               children: [
          //                 ClipRRect(
          //                   borderRadius: BorderRadius.circular(8),
          //                   child: Image.asset(
          //                     product['image'] ?? 'assets/images/logo.png',
          //                     width: 80,
          //                     height: 80,
          //                     fit: BoxFit.contain,
          //                   ),
          //                 ),
          //                 const SizedBox(width: 16),
          //                 Expanded(
          //                   child: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Text(
          //                         product['name'],
          //                         style: const TextStyle(
          //                             fontSize: 18,
          //                             fontWeight: FontWeight.bold),
          //                       ),
          //                       const SizedBox(height: 4),
          //                       Text(
          //                         product['category'],
          //                         style: TextStyle(
          //                             color: Colors.grey[600], fontSize: 14),
          //                       ),
          //                       const SizedBox(height: 4),
          //                       Text(
          //                         '${product['price']}',
          //                         style: const TextStyle(
          //                             fontWeight: FontWeight.bold,
          //                             color: Colors.green,
          //                             fontSize: 16),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget productList(String title, List<dynamic> products,String shopNumber) {
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
                  Get.to(() => ProductDetailScreen(
                        product: product,
                        isadmin: false,
                      ));
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
                                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.call, size: 20, color: Colors.white),
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