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
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.product.productsImage != null)
                  Column(
                    children: [
                      SizedBox(
                        height: 300,
                        child: PageView.builder(
                          itemCount: widget.product.productsImage?.length ?? 0,
                          controller: PageController(viewportFraction: 0.85),
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final imagePath =
                                widget.product.productsImage![index];
                            return GestureDetector(
                              onTap: () =>
                                  imageViewer(context, imagePath, true),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    toImageUrl(imagePath),
                                    fit: BoxFit.cover,
                                    width: Get.width,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: AnimatedSmoothIndicator(
                          activeIndex: _currentImageIndex,
                          count: widget.product.productsImage?.length ?? 0,
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
                // GestureDetector(
                //   onTap: () {},
                //   child: Text(
                //     widget.shop.shopName,
                //     style: const TextStyle(
                //       color: Colors.blue,
                //       decoration: TextDecoration.underline,
                //       fontSize: 16,
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ),
                // Text(
                //   "${widget.product.productCategory}-${widget.product.productSubCategory}",
                //   style: const TextStyle(
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        widget.product.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "₹${widget.product.productsPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  "Product Description",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.product.productsDescription!,
                ),
                const SizedBox(height: 5),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       "More From ${widget.shop.shopName}",
                //       style: const TextStyle(fontWeight: FontWeight.bold),
                //     ),
                //     GestureDetector(
                //       onTap: () {},
                //       child: const Text(
                //         "View More",
                //         style: TextStyle(
                //           decoration: TextDecoration.underline,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
