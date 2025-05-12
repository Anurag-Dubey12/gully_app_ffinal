import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gully_app/data/api/shop_api.dart';
import 'package:gully_app/data/model/product_model.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/utils/geo_locator_helper.dart';
import 'package:gully_app/utils/utils.dart';

class ProductData {
  final String category;
  final List<ProductModel> product;

  ProductData({required this.category, required this.product});
}

class ShopController extends GetxController with StateMixin {
  final ShopApi shopApi;
  ShopController({required this.shopApi}) {
    getCurrentLocation();
    Geolocator.getServiceStatusStream().listen((event) {
      getCurrentLocation();
    });
    change(GetStatus.empty());
  }

  // MARK: GetCurrentLocation
  Future<void> getCurrentLocation() async {
    final position = await determinePosition();
    coordinates.value = LatLng(position.latitude, position.longitude);
    coordinates.refresh();
  }

  set setCoordinates(LatLng value) {
    coordinates.value = value;

    coordinates.refresh();
  }

  Rx<ProductModel?> productModel = Rx<ProductModel?>(null);
  Rx<LatLng> coordinates = const LatLng(0, 0).obs;

  // MARK: RegisterShop
  Future<bool> registerShop(Map<String, dynamic> shop) async {
    final response = await shopApi.registerShop(shop);
    if (response.status == false) {
      errorSnackBar(response.message!);
      return false;
    }
    change(GetStatus.success(ShopModel.fromJson(response.data!)));
    return true;
  }

  RxList<ShopModel> myShops = <ShopModel>[].obs;
  // MARK: GetMyShop
  Future<List<ShopModel>> getMyShop() async {
    final response = await shopApi.getMyShops();
    final dataMap = response.data as Map<String, dynamic>;
    final List<dynamic> jsonList = dataMap['shops'] as List<dynamic>;
    myShops.value = jsonList
        .map((e) => ShopModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return myShops;
  }

  RxList<ShopModel> nearbyShop = <ShopModel>[].obs;
  List<double> shoplocation = [];

  // MARK: getNearbyShop
  Future<List<ShopModel>> getNearbyShop() async {
    final response = await shopApi.getNearbyShop(
        latitude: coordinates.value.latitude,
        longitude: coordinates.value.longitude);
    if (response.status == false) {
      return [];
    }

    nearbyShop.value = (response.data!['nearbyshop'] as List<dynamic>)
        .map((e) => ShopModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return nearbyShop;
  }

  RxList<String> category = <String>[].obs;
  RxList<String> selectedcategory = <String>[].obs;

  // MARK: GetCategory
  Future<List<String>> getCategory() async {
    try {
      final response = await shopApi.getCategory();
      if (response.status == false) {
        errorSnackBar("Failed to get Category");
        return [];
      }
      return category.value = List<String>.from(response.data!['category']);
    } catch (e) {
      if (kDebugMode) {
        print("Failed to Fetch The Sub Category:${e.toString()}");
      }
      return [];
    }
  }

  RxMap<String, List<String>> subcategories = <String, List<String>>{}.obs;
  RxList<String> subcategory = <String>[].obs;
  RxList<String> selectedsubcategory = <String>[].obs;

  // MARK: GetSubCategory
  Future<List<String>> getsubCategory(String category) async {
    try {
      final response = await shopApi.getsubCategory(category);
      if (response.status == false) {
        errorSnackBar("Failed to get Category");
        return [];
      }
      subcategory.value = List<String>.from(response.data!['subCategory']);
      return List<String>.from(response.data!['subCategory']);
    } catch (e) {
      if (kDebugMode) {
        print("Failed to Fetch The Sub Category:${e.toString()}");
      }
      return [];
    }
  }

  RxList<String> selectedbrands = <String>[].obs;
  RxList<String> brands = <String>[].obs;

  // MARK: GetBrands
  Future<List<String>> getbrands() async {
    try {
      final response = await shopApi.getbrands();
      if (response.status == false) {
        errorSnackBar("Failed to get Category");
        return [];
      }
      return brands.value = List<String>.from(response.data!['Brands']);
    } catch (e) {
      if (kDebugMode) {
        print("Failed to Fetch The Sub Category:${e.toString()}");
      }
      return [];
    }
  }

  // MARK: AddShopProduct
  Future<bool> addShopProduct(Map<String, dynamic> product) async {
    final response = await shopApi.addShopProduct(product);
    if (response.status == false) {
      errorSnackBar(response.message!);
      return false;
    }
    change(GetStatus.success(ProductModel.fromJson(response.data!)));
    return true;
  }

  RxList<ProductModel> product = <ProductModel>[].obs;
  RxList<ProductData> products = <ProductData>[].obs;
  RxList<String> productsCategory = <String>[].obs;
  RxList<String> productssubCategory = <String>[].obs;
  RxList<String> productsBrand = <String>[].obs;
  RxInt totalImagesAdded = 0.obs;
  RxInt totalPackagelimit = 0.obs;
  // MARK: getShopProducts
  Future<List<ProductData>> getShopProducts(String shopId, int page) async {
    final response = await shopApi.getShopProduct(shopId, page);
    if (response.status == false) {
      errorSnackBar(response.message!);
      return [];
    }

    final Map<String, dynamic> categorizedProducts = response.data!['products'];
    final List<ProductData> parsedProducts = [];
    int imageCount = 0;
    categorizedProducts.forEach((categoryName, productList) {
      final List<ProductModel> productsInCategory =
          (productList as List<dynamic>)
              .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList();

      for (final product in productsInCategory) {
        imageCount += product.productsImage?.length ?? 0;
      }

      parsedProducts.add(ProductData(
        category: categoryName,
        product: productsInCategory,
      ));
    });

    totalImagesAdded.value = imageCount;
    products.value = parsedProducts;
    return parsedProducts;
  }

// Future<List<ProductModel>> getShopProductPaginated({
//   required String shopId,
//   int page = 1,
//   int limit = 10,
// }) async {
//   final response = await shopApi.getShopProduct(shopId, page, limit);

//   if (response.status == false) {
//     errorSnackBar(response.message ?? "Failed to load products");
//     return [];
//   }

//   final data = response.data!;
//   final shopproducts = (data['products'] as List<dynamic>)
//       .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
//       .toList();

//   int imageCount = 0;
//   for (final image in shopproducts) {
//     imageCount += image.productsImage?.length ?? 0;
//   }

//   totalImagesAdded.value += imageCount;

//   // Set categories (only once on first page)
//   if (page == 1) {
//     productsCategory.value = List<String>.from(data['categories'] ?? []);
//     productssubCategory.value = List<String>.from(data['subCategories'] ?? []);
//     productsBrand.value = List<String>.from(data['brands'] ?? []);
//   }

//   return shopproducts;
// }

  // MARK: setProductStatus
  Future<bool> setProductStatus(String productId, bool isActive) async {
    final response = await shopApi.setProductStatus(productId, isActive);
    if (response.status == false) {
      errorSnackBar("Failed to Change Product Status");
      if (kDebugMode) {
        print("Failed to change Product Status:${response.message}");
      }
      return false;
    }
    GetStatus.success(ProductModel.fromJson(response.data!));
    return true;
  }

  // MARK: updateSubscriptionStatus
  Future<ShopModel> updateSubscriptionStatus(
      Map<String, dynamic> shopsubscription) async {
    final response = await shopApi.updateSubscriptionStatus(shopsubscription);
    if (response.status == false) {
      if (kDebugMode) {
        print("Failed to update shop subscription ");
      }
    }
    return ShopModel.fromJson(response.data!);
  }

  // MARK: Add Addtional Package
  Future<bool> addAddtionalPackage(
      Map<String, dynamic> shopsubscription) async {
    final response = await shopApi.addAddtionalPackage(shopsubscription);
    if (response.status == false) {
      if (kDebugMode) {
        print("Failed to update shop subscription ");
      }
      return false;
    }
    return true;
  }

  RxString searchQuery = ''.obs;
  RxList<ShopModel> searchedShops = <ShopModel>[].obs;
  RxList<ProductModel> searchedProducts = <ProductModel>[].obs;
  RxBool isSearching = false.obs;
  RxBool iscorrectedQuery = false.obs;
  RxString originalQuery = ''.obs;
  RxString correctedQuery = ''.obs;

// MARK: searchShopsAndProducts
  Future<void> searchShopsAndProducts(String query) async {
    if (query.isEmpty) {
      searchedShops.clear();
      searchedProducts.clear();
      return;
    }

    isSearching.value = true;
    try {
      final response = await shopApi.searchShopsAndProducts(query);
      if (response.status == false) {
        errorSnackBar("Search failed");
        return;
      }
      final result = response.data as Map<String, dynamic>;

      if (result.containsKey('shops')) {
        final List<dynamic> shopsJson = result['shops'] as List<dynamic>;
        searchedShops.value = shopsJson
            .map((e) => ShopModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        searchedShops.clear();
      }

      if (result.containsKey('products')) {
        final List<dynamic> productsJson = result['products'] as List<dynamic>;
        searchedProducts.value = productsJson
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        searchedProducts.clear();
      }
      if (result['searchInfo']['correctedQuery'] != null) {
        iscorrectedQuery.value = true;
        originalQuery.value = result['searchInfo']['originalQuery'];
        correctedQuery.value = result['searchInfo']['correctedQuery'];
      } else {
        iscorrectedQuery.value = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Search error: ${e.toString()}");
      }
    } finally {
      isSearching.value = false;
    }
  }

  // MARK: GetSimilarProduct
  RxList<ProductModel> similarproduct = <ProductModel>[].obs;
  Future<List<ProductModel>> getSimilarProduct({
    required String productId,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await shopApi.getSimilarProduct(
        productId: productId,
        latitude: coordinates.value.latitude,
        longitude: coordinates.value.longitude,
        page: page,
        limit: limit);
    if (response.status == false) {
      errorSnackBar(response.message!);
      return [];
    }
    final shopproducts = (response.data!['similarProduct'] as List<dynamic>)
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return similarproduct.value = shopproducts;
  }

  // MARK: getSimilarShopProduct
  RxList<ProductModel> similarshopproduct = <ProductModel>[].obs;
  Future<List<ProductModel>> getSimilarShopProduct({
    required String productId,
    required String shopId,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await shopApi.getSimilarShopProduct(
        productId: productId, shopId: shopId, page: page, limit: limit);
    if (response.status == false) {
      errorSnackBar(response.message!);
      return [];
    }
    final shopproducts = (response.data!['similarshopproduct'] as List<dynamic>)
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return similarshopproduct.value = shopproducts;
  }

  final RxList<ProductModel> similarProducts = <ProductModel>[].obs;
  final RxBool isLoadingMore = false.obs;
  int currentPage = 1;
  bool hasMore = true;

  // Future<void> fetchSimilarProducts({
  //   required String productId,
  //   bool isInitialLoad = false,
  //   int limit = 20,
  // }) async {
  //   if (isLoadingMore.value || !hasMore) return;

  //   isLoadingMore.value = true;
  //   final response = await shopApi.getSimilarProduct(
  //     productId: productId,
  //     latitude: coordinates.value.latitude,
  //     longitude: coordinates.value.longitude,
  //     page: currentPage,
  //     limit: limit,
  //   );

  //   if (response.status == false) {
  //     errorSnackBar(response.message!);
  //     isLoadingMore.value = false;
  //     return;
  //   }

  //   final List<ProductModel> newProducts =
  //       (response.data!['similarProduct'] as List)
  //           .map((e) => ProductModel.fromJson(e))
  //           .toList();

  //   if (isInitialLoad) {
  //     similarProducts.assignAll(newProducts);
  //   } else {
  //     similarProducts.addAll(newProducts);
  //   }
  //   print(similarProducts);
  //   if (newProducts.length < limit) {
  //     hasMore = false;
  //   } else {
  //     currentPage++;
  //   }

  //   isLoadingMore.value = false;
  // }
}
