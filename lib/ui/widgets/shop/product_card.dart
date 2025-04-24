import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/product_model.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/ui/screens/shop/User%20Screen/product_detail_screen.dart';
import 'package:gully_app/utils/utils.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final ShopModel shop;
  const ProductCard({Key? key, required this.product, required this.shop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductDiscount? discount = product.productDiscount;
    String percentageoff = '';
    if (discount != null) {
      if (discount.discountType == 'percent') {
        var calculatedoff =
            (discount.discountPrice / product.productsPrice) * 100;
        percentageoff = '${calculatedoff.toStringAsFixed(2)}% OFF';
      }
    }

    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetailScreen(
              product: product,
              isadmin: true,
              shop: shop,
            ));
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: 180,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: product.productsImage != null &&
                        product.productsImage!.isNotEmpty
                    ? Image.network(
                        toImageUrl(product.productsImage!.last),
                        width: Get.width,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.error, color: Colors.grey),
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/logo.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productBrand,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  product.productDiscount?.discountType == "percent"
                      ? Row(
                          children: [
                            Text(
                              '₹${product.productDiscount?.discountPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '₹${product.productsPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.white),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              percentageoff,
                              style: const TextStyle(
                                color: Colors.yellow,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Text(
                              '₹${product.productsPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Fixed Price',
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
