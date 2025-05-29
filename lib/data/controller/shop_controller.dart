import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gully_app/data/api/shop_api.dart';
import 'package:gully_app/data/model/product_model.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/ui/screens/shop/Shop%20owner%20Screen/shop_analytics_screen.dart';
import 'package:gully_app/utils/geo_locator_helper.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:intl/intl.dart';

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
  RxBool isShopUploading = false.obs;
  // MARK: RegisterShop
  Future<bool> registerShop(Map<String, dynamic> shop) async {
    try {
      isShopUploading.value = true;
      final response = await shopApi.registerShop(shop);
      if (response.status == false) {
        errorSnackBar(response.message!);
        return false;
      }

      // change(GetStatus.success(ShopModel.fromJson(response.data!)));
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    } finally {
      isShopUploading.value = false;
    }
  }

  Rx<ShopModel?> shop = Rx<ShopModel?>(null);

// MARK: EditShop
  Future<bool> editShop(Map<String, dynamic> shopData) async {
    try {
      isShopUploading.value = true;
      final response = await shopApi.editShop(shopData);

      if (response.status == false) {
        errorSnackBar(response.message ?? "Something went wrong.");
        return false;
      }
      final shopJson = response.data!['shop'];
      if (shopJson == null) {
        errorSnackBar("Invalid response format: 'shop' data missing.");
        return false;
      }
      shop.value = ShopModel.fromJson(shopJson);
      return true;
    } catch (e) {
      if (kDebugMode) print("Edit Shop Error: $e");
      errorSnackBar("Failed to update shop. Please try again.");
      return false;
    } finally {
      isShopUploading.value = false;
    }
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
  final isDataLoading = false.obs;
  // MARK: GetSubCategory
  Future<List<String>> getsubCategory(String category) async {
    try {
      isDataLoading.value = true;
      final response = await shopApi.getsubCategory(category);
      if (response.status == false) {
        errorSnackBar("Failed to get Category");
        isDataLoading.value = false;
        return [];
      }
      subcategory.value = List<String>.from(response.data!['subCategory']);
      isDataLoading.value = false;
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

  RxBool isProductUploading = false.obs;
  // MARK: AddShopProduct
  Future<bool> addShopProduct(Map<String, dynamic> product) async {
    try {
      isProductUploading.value = true;
      final response = await shopApi.addShopProduct(product);
      if (response.status == false) {
        errorSnackBar(response.message!);
        return false;
      }
      change(GetStatus.success(ProductModel.fromJson(response.data!)));
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    } finally {
      isProductUploading.value = false;
    }
  }

  Rx<ProductModel?> shopProduct = Rx<ProductModel?>(null);

  // MARK: EditShopProduct
  Future<bool> editProduct(Map<String, dynamic> product) async {
    try {
      isProductUploading.value = true;
      final response = await shopApi.editProduct(product);
      if (response.status == false) {
        errorSnackBar(response.message ?? "Something went wrong.");
        return false;
      }
      final productJson = response.data!['product'];
      if (productJson == null) {
        errorSnackBar("Invalid response format: 'shop' data missing.");
        return false;
      }
      shopProduct.value = ProductModel.fromJson(productJson);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    } finally {
      isProductUploading.value = false;
    }
  }

  // MARK: GetProduct
  Future<bool> getProduct(String product) async {
    try {
      final response = await shopApi.getProduct(product);
      if (response.status == false) {
        errorSnackBar(response.message ?? "Something went wrong.");
        return false;
      }
      final productJson = response.data!['product'];
      if (productJson == null) {
        errorSnackBar("Invalid response format: 'shop' data missing.");
        return false;
      }
      final updatedproduct = ProductModel.fromJson(productJson);
      shopProduct.value = updatedproduct;
      if (kDebugMode) {
        print(updatedproduct.productsPrice);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  // MARK: GetShop
  Future<bool> getShop(String shopId) async {
    try {
      final response = await shopApi.getShop(shopId);
      if (response.status == false) {
        errorSnackBar(response.message ?? "Something went wrong.");
        return false;
      }
      final shopJson = response.data!['shop'];
      if (shopJson == null) {
        errorSnackBar("Invalid response format: 'shop' data missing.");
        return false;
      }
      final shopData = ShopModel.fromJson(shopJson);
      shop.value = shopData;
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  RxList<ProductModel> product = <ProductModel>[].obs;
  RxList<ProductData> products = <ProductData>[].obs;
  RxList<String> productsCategory = <String>[].obs;
  RxList<String> productssubCategory = <String>[].obs;
  RxList<String> productsBrand = <String>[].obs;

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
    if (page == 1) {
      products.clear();
    }
    products.value = parsedProducts;
    return parsedProducts;
  }

  RxBool isEdited = false.obs;
  RxInt totalImagesAdded = 0.obs;
  RxInt totalPackagelimit = 0.obs;
  // MARK: getShopImageCount
  Future<int> getShopImageCount(String shopId) async {
    final response = await shopApi.getShopImageCount(shopId);
    if (response.status == false) {
      errorSnackBar(response.message!);
    }
    totalImagesAdded.value = response.data!['totalImageCount'];
    totalPackagelimit.value = response.data!['totalMediaLimit'];
    return totalImagesAdded.value;
  }

  RxList<ProductData> filterproducts = <ProductData>[].obs;
  // MARK: GetFilterProduct
  Future<List<ProductData>> getFilterProduct(
      Map<String, dynamic> filterItem) async {
    final response = await shopApi.getFilterProduct(filterItem);
    if (response.status == false) {
      errorSnackBar(response.message!);
      return [];
    }

    final Map<String, dynamic> categorizedProducts =
        response.data!['filterProducts'];
    final List<ProductData> parsedProducts = [];
    categorizedProducts.forEach((categoryName, productList) {
      final List<ProductModel> productsInCategory =
          (productList as List<dynamic>)
              .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList();
      parsedProducts.add(ProductData(
        category: categoryName,
        product: productsInCategory,
      ));
    });
    filterproducts.value = parsedProducts;
    return parsedProducts;
  }

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
  Future<bool> updateSubscriptionStatus(
      Map<String, dynamic> shopsubscription) async {
    final response = await shopApi.updateSubscriptionStatus(shopsubscription);
    if (response.status == false) {
      if (kDebugMode) {
        print("Failed to update shop subscription ");
      }
    }
    return true;
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

  void resetData() {
    selectedcategory.clear();
    selectedbrands.clear();
    selectedsubcategory.clear();
    subcategories.clear();
    appliedFilter.value = 0;
  }

  // ***********************    Shop Analytics Section      ****************************

  final isLoading = true.obs;
  final selectedPeriod = 'Last 7 Days'.obs;
  final availablePeriods =
      ['Last 7 Days', 'Last 15 Days', 'Last 30 Days', 'All Time'].obs;

  // Analytics data
  final mostViewedProducts = <ProductAnalytics>[].obs;
  final mostViewedProductsList = <ProductAnalytics>[].obs;
  final productViewsOverTime = <DateTime, int>{}.obs;
  final shopVisits = <DateTime, int>{}.obs;
  final appliedFilter = 0.obs;
  final totalProductViews = 0.obs;
  final totalShopVisits = 0.obs;
  final totalProducts = 0.obs;
  final activeProducts = 0.obs;
  final uniqueVisitors = 0.obs;
  final categoryDistribution = <Map<String, dynamic>>[].obs;

  // Chart data
  final productViewsChartData = <FlSpot>[].obs;
  final shopVisitsChartData = <FlSpot>[].obs;

  // Date labels for charts
  final dateLabels = <String>[].obs;

  // MARK: Change Period
  void changePeriod(String period) async {
    selectedPeriod.value = period;
    await loadAnalyticsData(shop.value!.id);
  }

  // MARK: GetTimeRangeParam
  String getTimeRangeParam() {
    switch (selectedPeriod.value) {
      case 'Last 7 Days':
        return '7days';
      case 'Last 15 Days':
        return '15days';
      case 'Last 30 Days':
        return '30days';
      case 'All Time':
        return 'all';
      default:
        return '7days';
    }
  }

  // Future<void> initShopAnalytics(String shopId) async {
  //   isLoading.value = true;
  //   try {
  //     await loadAnalyticsData(shopId: shopId);
  //   } catch (e) {
  //     print('Error initializing shop analytics: $e');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // MARK: loadAnalyticsData
  Future<void> loadAnalyticsData(String shopId) async {
    if (shopId.isEmpty) {
      return;
    }
    isLoading.value = true;
    try {
      await Future.wait([
        getShopOverview(shopId),
        getProductViewData(shopId),
        getVisitorData(shopId)
      ]);
      processChartData();
    } catch (e) {
      print('Error loading analytics data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // MARK: getShopOverview
  Future<void> getShopOverview(String shopId) async {
    try {
      final response = await shopApi.getShopAnalytics(shopId);
      final data = response.data;
      totalProductViews.value = data!['totalProductViews'] ?? 0;
      totalShopVisits.value = data['totalShopVisits'] ?? 0;
      totalProducts.value = data['totalProducts'] ?? 0;
      activeProducts.value = data['activeProducts'] ?? 0;
      mostViewedProducts.clear();
      if (data['topProducts'] != null) {
        final List topProducts = data['topProducts'];
        for (var product in topProducts) {
          if (product['product'] != null) {
            mostViewedProducts.add(ProductAnalytics(
              product: ProductModel.fromJson(product['product']),
              viewCount: product['viewCount'] ?? 0,
            ));
            mostViewedProductsList.add(ProductAnalytics(
              product: ProductModel.fromJson(product['product']),
              viewCount: product['viewCount'] ?? 0,
            ));
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting shop overview: $e');
      }
    }
  }

  // MARK: getProductViewData
  Future<void> getProductViewData(String shopId) async {
    try {
      final response =
          await shopApi.getProductViewAnalytics(shopId, getTimeRangeParam());
      final data = response.data;
      productViewsOverTime.clear();

      if (data!['dailyViewTrend'] != null) {
        final List trend = data['dailyViewTrend'];
        for (var point in trend) {
          final date = DateTime.parse(point['date']);
          final count = point['count'] ?? 0;
          productViewsOverTime[date] = count;
        }
      }
      categoryDistribution.clear();
      if (data['categoryDistribution'] != null) {
        final List categories = data['categoryDistribution'];
        for (var category in categories) {
          categoryDistribution.add({
            'category': category['category'] ?? 'Unknown',
            'viewCount': category['viewCount'] ?? 0,
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting product view data: $e');
      }
    }
  }

  // MARK: getVisitorData
  Future<void> getVisitorData(String shopId) async {
    try {
      final response =
          await shopApi.getVisitorAnalytics(shopId, getTimeRangeParam());
      final data = response.data;
      uniqueVisitors.value = data!['uniqueVisitors'] ?? 0;

      shopVisits.clear();
      if (data['dailyVisitorTrend'] != null) {
        final List trend = data['dailyVisitorTrend'];
        for (var point in trend) {
          final date = DateTime.parse(point['date']);
          final count = point['count'] ?? 0;
          shopVisits[date] = count;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting visitor data: $e');
      }
    }
  }

  // MARK: processChartData
  void processChartData() {
    productViewsChartData.clear();
    // dateLabels.clear();

    final sortedDates = productViewsOverTime.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    for (int i = 0; i < sortedDates.length; i++) {
      final date = sortedDates[i];
      final count = productViewsOverTime[date] ?? 0;
      productViewsChartData.add(FlSpot(i.toDouble(), count.toDouble()));
      dateLabels.add(DateFormat('MM/dd').format(date));
    }
    shopVisitsChartData.clear();

    final sortedVisitDates = shopVisits.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    for (int i = 0; i < sortedVisitDates.length; i++) {
      final date = sortedVisitDates[i];
      final count = shopVisits[date] ?? 0;
      shopVisitsChartData.add(FlSpot(i.toDouble(), count.toDouble()));
    }
  }

  String getCurrentShopId() {
    return '';
  }

  // MARK: recordProductView
  Future<void> recordProductView(String productId, String shopId) async {
    try {
      await shopApi.recordProductView(productId, shopId);
    } catch (e) {
      if (kDebugMode) {
        print('Error recording product view: $e');
      }
    }
  }

  // MARK: recordShopVisit
  Future<void> recordShopVisit(String shopId) async {
    try {
      await shopApi.recordShopVisit(shopId);
    } catch (e) {
      if (kDebugMode) {
        print('Error recording shop view view: $e');
      }
    }
  }

  List<String> getDateLabels() {
    return dateLabels;
  }

  // ***********************    Credential verification Section      ****************************
  RxBool isOtpSent = false.obs;
  RxBool isOtpVerified = false.obs;
  RxBool isOtpInProgress = false.obs;

  // MARK: SendOTP
  Future<bool> sendOTP(String phoneNumber) async {
    try {
      isOtpInProgress.value = true;
      await Future.delayed(const Duration(seconds: 2));
      final response = await shopApi.sendOTP(phoneNumber);
      if (response.status == false) {
        errorSnackBar(response.message ?? "Something went wrong.");
        return false;
      }
      print("The otp sent value:${isOtpSent.value}");
      return true;
    } catch (e) {
      // rethrow;
      return false;
    } finally {
      isOtpInProgress.value = false;
    }
  }

  // MARK: VerifyOtp
  Future<bool> verifyOtp({required String otp}) async {
    try {
      isOtpInProgress.value = true;
      await Future.delayed(const Duration(seconds: 2));

      final response = await shopApi.verifyOtp(otp);

      if (response.status == false) {
        errorSnackBar(response.message ?? "Invalid OTP");
        return false;
      }
      return true;
    } catch (e) {
      errorSnackBar("OTP verification failed. Please try again.");
      return false;
    } finally {
      isOtpInProgress.value = false;
    }
  }
}
