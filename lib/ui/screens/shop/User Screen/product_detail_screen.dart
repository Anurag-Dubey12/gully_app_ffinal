import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/product_model.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/ui/screens/shop/Shop%20owner%20Screen/add_product.dart';
import 'package:gully_app/utils/image_picker_helper.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:io';

import '../../../widgets/gradient_builder.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  final ShopModel shop;
  final bool isadmin;
  const ProductDetailScreen(
      {Key? key,
      required this.product,
      required this.isadmin,
      required this.shop})
      : super(key: key);
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;

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
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.product.productName ?? 'Product Info',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 120),
                if (widget.isadmin)
                  GestureDetector(
                      onTap: () {
                        // Get.to(() => AddProduct(
                        //       product: widget.product,
                        //     ));
                      },
                      child: const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                      )),
                const SizedBox(width: 10),
                if (widget.isadmin)
                  GestureDetector(
                      child: const Icon(
                    Icons.delete_outlined,
                    color: Colors.white,
                  ))
              ],
            ),
            leading: const BackButton(
              color: Colors.white,
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.product.productsImage != null)
                  Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 200,
                          autoPlay: false,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                        ),
                        items: widget.product.productsImage?.map((imagePath) {
                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () =>
                                    imageViewer(context, imagePath, false),
                                child: Container(
                                  width: Get.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Image.network(
                                    toImageUrl(imagePath),
                                    width: Get.width,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: AnimatedSmoothIndicator(
                          activeIndex: _currentImageIndex,
                          count: widget.product.productsImage!.length,
                          effect: ExpandingDotsEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            activeDotColor: Theme.of(context).primaryColor,
                            dotColor: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    widget.shop.shopName,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  widget.product.productName,
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  TableRow _ProductInfo(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }
}
