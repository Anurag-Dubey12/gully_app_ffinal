import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'product_detail_screen.dart';

class ShopDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> shop;
  const ShopDetailsScreen({Key? key, required this.shop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = shop['products'] ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop Details",
            style: TextStyle(color: Colors.black,fontSize: 20),),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // SliverAppBar(
          //   expandedHeight: 200.0,
          //   floating: false,
          //   pinned: false,
          //   flexibleSpace: FlexibleSpaceBar(
          //     title: Text(shop['name'],
          //         style: const TextStyle(color: Colors.black)),
          //     background: ClipRRect(
          //       borderRadius: BorderRadius.circular(16),
          //       child: ImageFiltered(
          //         imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          //         child: Image.asset(
          //           shop['coverImage'] ?? 'assets/images/logo.png',
          //           fit: BoxFit.cover,
          //         ),
          //       ),
          //     ),
          //   ),
          //   actions: [
          //     IconButton(
          //       icon: const Icon(Icons.favorite_border, color: Colors.white),
          //       onPressed: () {},
          //     ),
          //     IconButton(
          //       icon: const Icon(Icons.share, color: Colors.white),
          //       onPressed: () {},
          //     ),
          //   ],
          // ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(
                            shop['logo'] ?? 'assets/images/logo.png'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shop['name'],
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              shop['details'],
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
                          shop['location'],
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[800]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(vertical: 16),
          //     decoration: BoxDecoration(
          //       color: Colors.blue[50],
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         Column(
          //           children: [
          //             Icon(Icons.star, color: Colors.blue[700]),
          //             const SizedBox(height: 4),
          //             Text('${shop['rating'] ?? 0}',
          //                 style: const TextStyle(
          //                     fontSize: 18, fontWeight: FontWeight.bold)),
          //             Text('Rating', style: TextStyle(color: Colors.grey[600])),
          //           ],
          //         ),
          //         Column(
          //           children: [
          //             Icon(Icons.shopping_bag, color: Colors.blue[700]),
          //             const SizedBox(height: 4),
          //             Text('${shop['totalProducts'] ?? 0}',
          //                 style: const TextStyle(
          //                     fontSize: 18, fontWeight: FontWeight.bold)),
          //             Text('Products',
          //                 style: TextStyle(color: Colors.grey[600])),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Featured Products',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => ProductDetailScreen(
                                product: product,
                                isadmin: false,
                              ));
                        },
                        child: Container(
                          width: 150,
                          margin: const EdgeInsets.only(left: 16),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                  child: Image.asset(
                                    product['image'] ??
                                        'assets/images/logo.png',
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text('${product['price']}',
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.star,
                                              color: Colors.amber, size: 16),
                                          Text('${product['rating']}',
                                              style: const TextStyle(
                                                  fontSize: 12)),
                                        ],
                                      ),
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
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'All Products',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                product['image'] ?? 'assets/images/logo.png',
                                width: 80,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product['category'],
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${product['price']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
