import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/screens/shop/add_product.dart';
import 'package:gully_app/utils/image_picker_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:io';

import '../../widgets/gradient_builder.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final bool isadmin;
  const ProductDetailScreen(
      {Key? key, required this.product, required this.isadmin})
      : super(key: key);
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String>? images = widget.isadmin
        ? widget.product['images']?.cast<String>()
        : widget.product['logo']?.cast<String>() ??
            [
              'assets/images/logo.png',
              'assets/images/logo.png',
              'assets/images/logo.png'
            ];

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
                    widget.product['name'] ?? 'Product Info',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 120),
                if(widget.isadmin)
                GestureDetector(
                    onTap: () {
                      Get.to(() => AddProduct(
                            product: widget.product,
                          ));
                    },
                    child: const Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                    )),
                const SizedBox(width: 10),
                if(widget.isadmin)
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
                if (images != null && images.isNotEmpty)
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
                        items: images.map((imagePath) {
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
                                  child: Image.file(
                                    File(imagePath),
                                    fit: BoxFit.cover,
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
                          count: images.length,
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
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    "Product Info",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Table(
                  border: TableBorder.all(color: Colors.grey, width: 1),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                  },
                  children: [
                    _ProductInfo('Name', widget.product['name'] ?? 'N/A'),
                    _ProductInfo(
                        'Category', widget.product['category'] ?? 'N/A'),
                    _ProductInfo(
                        'Subcategory', widget.product['subcategory'] ?? 'N/A'),
                    _ProductInfo(
                        'Price', '${widget.product['price'] ?? 'N/A'}'),
                    _ProductInfo(
                        'Discount', '₹${widget.product['discount'] ?? '0'}'),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Description:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.product['description'] ?? 'No description available.',
                  style: const TextStyle(fontSize: 16),
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
