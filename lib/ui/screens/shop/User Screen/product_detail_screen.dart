import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/config/app_constants.dart';
import 'package:gully_app/data/controller/shop_controller.dart';
import 'package:gully_app/data/model/product_model.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/ui/screens/shop/Shop%20owner%20Screen/product_adding_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/ui/widgets/shop/product_card.dart';
import 'package:gully_app/utils/image_picker_helper.dart';
import 'package:gully_app/utils/launch_external_service.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../widgets/gradient_builder.dart';

class ProductDetailScreen extends StatefulWidget {
  final ShopModel? shop;
  final bool isadmin;
  const ProductDetailScreen({Key? key, required this.isadmin, this.shop})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  int _currentImageIndex = 0;
  bool isMore = false;
  bool isActive = false;
  final controller = Get.find<ShopController>();

  late AnimationController _slideController;
  late AnimationController _fixedPriceslideController;
  late AnimationController _lineController;
  late AnimationController _discountController;
  late Animation<Offset> _slideAnimation;
  late Animation<Offset> _fixedPriceslideAnimation;
  late Animation<Offset> _percentageOffAnimation;
  late Animation<double> _lineAnimation;
  late Animation<double> _discountFadeAnimation;
  late Animation<double> _discountScaleAnimation;
  bool showDiscountAndOff = false;
  bool showFixedPrice = false;
  late double _textWidth;
  late final product;
  
  // MARK: _getTextWidth
  /// Measures and returns the width of the given [text] with the specified [style].
  /// This utility is useful when you need precise control over UI elements
  /// based on the rendered width of a text string.
  /// Returns the width in logical pixels.
  double _getTextWidth(String text, TextStyle style) {
    // Initialize a TextPainter to calculate text metrics.
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(); // Perform layout to compute the size.

    // Return the computed text width.
    return textPainter.width;
  }

  @override
  void initState() {
    super.initState();
    product = controller.shopProduct.value;
    final priceText = '₹${product.productsPrice.toStringAsFixed(0)}';
    _textWidth = _getTextWidth(
      priceText,
      const TextStyle(
        color: Colors.grey,
        fontSize: 22,
      ),
    );

    _slideController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fixedPriceslideController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _discountController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _fixedPriceslideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fixedPriceslideController,
      curve: Curves.easeInOut,
    ));

    _discountFadeAnimation = CurvedAnimation(
      parent: _discountController,
      curve: Curves.easeInOut,
    );
    _discountScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _discountController, curve: Curves.easeInOut),
    );
    _percentageOffAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _discountController, curve: Curves.easeOutBack));

    _lineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _lineController,
      curve: Curves.easeInOut,
    ));

    if (product.productDiscount?.discountType == "percent") {
      _slideController.forward().whenComplete(() {
        _lineController.forward().whenComplete(() {
          setState(() {
            showDiscountAndOff = true;
          });
          _discountController.forward();
        });
      });
    } else {
      _fixedPriceslideController.forward().whenComplete(() {
        setState(() {
          showFixedPrice = true;
        });
        _discountController.forward();
      });
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _discountController.dispose();
    _lineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isActive = product.isActive;
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
                    product.productName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 120),
              ],
            ),
            leading: const BackButton(
              color: Colors.white,
            ),
          ),
          bottomNavigationBar: widget.isadmin
              ? Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          onTap: () {
                            final shop = controller.shop.value;

                            if (shop == null) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (!shop.isSubscriptionPurchased) {
                              errorSnackBar(
                                  "Your subscription has expired. Editing is currently disabled. Please renew your subscription to continue.");
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog.adaptive(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        24, 24, 24, 16),
                                    title: const Row(
                                      children: [
                                        Icon(Icons.remove_circle_outline,
                                            color: Colors.orange, size: 28),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'Unlist Product',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: Text(
                                      product.isActive
                                          ? AppConstants.unlistProduct
                                          : AppConstants.relistProduct,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          try {
                                            bool isOk = await controller
                                                .setProductStatus(product.id,
                                                    isActive ? true : false);
                                            if (isOk) {
                                              Get.snackbar(
                                                'Success',
                                                isActive
                                                    ? 'Product Unlisted'
                                                    : 'Product Relisted',
                                                backgroundColor: Colors.green,
                                                colorText: Colors.white,
                                                duration:
                                                    const Duration(seconds: 2),
                                              );
                                              setState(() {
                                                product.isActive =
                                                    !product.isActive;
                                                isActive = product.isActive;
                                              });
                                              Navigator.of(context).pop();
                                            }
                                          } catch (e) {
                                            errorSnackBar(
                                                "Failed to update Product Status");
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          product.isActive
                                              ? 'Unlist'
                                              : 'Relist',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          title:
                              '${product.isActive ? 'Unlist' : 'Relist'} these Product',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: PrimaryButton(
                          onTap: () {
                            final shop = controller.shop.value;

                            if (shop == null) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (!shop.isSubscriptionPurchased) {
                              errorSnackBar(
                                  "Your subscription has expired. Editing is currently disabled. Please renew your subscription to continue.");
                            } else {
                              Get.off(() => AddProduct(
                                    product: product,
                                  ));
                            }
                          },
                          title: 'Edit Product',
                        ),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Want to know more? Contact the shop for details.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      PrimaryButton(
                        onTap: () => launchPhone(widget.shop!.shopContact),
                        title: "Call Now",
                      ),
                    ],
                  ),
                ),
          body: widget.isadmin ? adminProductView() : userProductView(),
        ),
      ),
    );
  }

  Widget adminProductView() {
    return Obx(() {
      final productdata = controller.shopProduct.value;
      if (productdata == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.productsImage != null)
              Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      itemCount: productdata.productsImage?.length ?? 0,
                      controller: PageController(viewportFraction: 0.85),
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final imagePath = productdata.productsImage![index];
                        return GestureDetector(
                          onTap: () => imageViewer(context, imagePath, true),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                toImageUrl(imagePath),
                                fit: BoxFit.cover,
                                width: Get.width,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: Get.width,
                                      height: 120,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/images/logo.png',
                                      fit: BoxFit.contain);
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
                      count: productdata.productsImage?.length ?? 0,
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
            const SizedBox(height: 5),
            SizedBox(
              width: 200,
              child: Text(
                productdata.productName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            showPrice(productdata),
            const SizedBox(height: 5),
            const Text(
              "Product Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedCrossFade(
                  crossFadeState: isMore
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                  firstChild: Text(
                    productdata.productsDescription ??
                        'No Description Provided',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  secondChild: Text(
                    productdata.productsDescription ??
                        'No Description Provided',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                InkWell(
                  onTap: () => setState(() => isMore = !isMore),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      isMore ? 'Read less' : 'Read more',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      );
    });
  }

  Widget userProductView() {
    return Obx(() {
      final productdata = controller.shopProduct.value;

      if (productdata == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (productdata.productsImage != null)
              Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      itemCount: productdata.productsImage?.length ?? 0,
                      controller: PageController(viewportFraction: 0.85),
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final imagePath = productdata.productsImage![index];
                        return GestureDetector(
                          onTap: () => imageViewer(context, imagePath, true),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                toImageUrl(imagePath),
                                fit: BoxFit.cover,
                                width: Get.width,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: Get.width,
                                      height: 120,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/images/logo.png',
                                      fit: BoxFit.cover);
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
                      count: productdata.productsImage?.length ?? 0,
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
            const SizedBox(height: 5),
            SizedBox(
              width: 200,
              child: Text(
                productdata.productName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            showPrice(productdata),
            const SizedBox(height: 5),
            const Text(
              "Product Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              productdata.productsDescription!,
            ),
            const SizedBox(height: 20),
            const Divider(
              color: Colors.grey,
              height: 1,
            ),
            const SizedBox(height: 5),
            const Text(
              "Similar Products",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 5),
            SimilarProductsWidget(
              productId: productdata.id,
            ),
            // Text(
            //   "Similar Products from ${shop!.shopName}",
            //   style: const TextStyle(
            //     fontWeight: FontWeight.w600,
            //     fontSize: 18,
            //     color: Colors.black,
            //     letterSpacing: 1.2,
            //   ),
            // ),
            // const SizedBox(height: 5),
            // SimilarShopProductsWidget(
            //   productId: product.id,
            //   shopId: product.shopId,
            // ),
          ],
        ),
      );
    });
  }

  Widget showPrice(ProductModel product) {
    final ProductDiscount? discount = product.productDiscount;
    String percentageOff = '';
    double? discountedPrice;

    if (discount != null) {
      if (discount.discountType == 'percent' ||
          discount.discountType == 'fixed') {
        discountedPrice = product.productsPrice - discount.discountPrice;

        if (discountedPrice < 0) discountedPrice = 0;

        final percentOff =
            ((discount.discountPrice / product.productsPrice) * 100)
                .clamp(0, 100);
        percentageOff = '${percentOff.toStringAsFixed(0)}% OFF';
      }
    }
    return product.productDiscount?.discountType == "percent"
        ? Row(
            children: [
              SlideTransition(
                position: _slideAnimation,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Text(
                      '₹${product.productsPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 22,
                        decorationColor: Colors.white,
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _lineAnimation,
                      builder: (context, child) {
                        return Positioned(
                          child: Container(
                            height: 2,
                            width: _lineAnimation.value * _textWidth,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (showDiscountAndOff)
                FadeTransition(
                  opacity: _discountFadeAnimation,
                  child: ScaleTransition(
                    scale: _discountScaleAnimation,
                    child: Text(
                      '₹${discountedPrice!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              const Spacer(),
              if (showDiscountAndOff)
                SlideTransition(
                  position: _percentageOffAnimation,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      percentageOff,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          )
        : Row(
            children: [
              SlideTransition(
                position: _fixedPriceslideAnimation,
                child: Text(
                  '₹${product.productsPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    decorationColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (showFixedPrice)
                SlideTransition(
                  position: _percentageOffAnimation,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "Fixed Price",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 6),
            ],
          );
  }
}

class SimilarProductsWidget extends StatefulWidget {
  final String productId;

  const SimilarProductsWidget({super.key, required this.productId});

  @override
  State<SimilarProductsWidget> createState() => _SimilarProductsWidgetState();
}

class _SimilarProductsWidgetState extends State<SimilarProductsWidget> {
  final ScrollController _scrollController = ScrollController();
  final List<ProductModel> _products = [];
  final controller = Get.find<ShopController>();
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final int _limit = 5;

  @override
  void initState() {
    super.initState();
    _fetchProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _fetchProducts();
      }
    });
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    final newProducts = await controller.getSimilarProduct(
      productId: widget.productId,
      page: _page,
      limit: _limit,
    );

    setState(() {
      _isLoading = false;
      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        _page++;
        _products.addAll(newProducts);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_products.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_products.isEmpty) {
      return const Center(child: Text("No products available"));
    }

    return SizedBox(
      height: 320,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _products.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _products.length) {
            return const Center(
                child: SizedBox(width: 60, child: CircularProgressIndicator()));
          }

          final product = _products[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ProductCard(product: product),
          );
        },
      ),
    );
  }
}

class SimilarShopProductsWidget extends StatefulWidget {
  final String productId;
  final String shopId;

  const SimilarShopProductsWidget(
      {super.key, required this.productId, required this.shopId});

  @override
  State<SimilarShopProductsWidget> createState() =>
      _SimilarShopProductsWidgetState();
}

class _SimilarShopProductsWidgetState extends State<SimilarShopProductsWidget> {
  final ScrollController _scrollController = ScrollController();
  final List<ProductModel> _products = [];
  final controller = Get.find<ShopController>();
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final int _limit = 5;

  @override
  void initState() {
    super.initState();
    _fetchProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _fetchProducts();
      }
    });
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    final newProducts = await controller.getSimilarShopProduct(
      productId: widget.productId,
      shopId: widget.shopId,
      page: _page,
      limit: _limit,
    );

    setState(() {
      _isLoading = false;
      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        _page++;
        _products.addAll(newProducts);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_products.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_products.isEmpty) {
      return const Center(child: Text("No products available"));
    }

    return SizedBox(
      height: 320,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _products.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _products.length) {
            return const Center(
                child: SizedBox(width: 60, child: CircularProgressIndicator()));
          }

          final product = _products[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ProductCard(product: product),
          );
        },
      ),
    );
  }
}
