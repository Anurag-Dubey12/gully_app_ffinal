import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/api/shop_api.dart';
import 'package:gully_app/data/model/product_model.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/data/model/vendor_model.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopController extends GetxController with StateMixin {
  Rx<vendor_model?> vendor = Rx<vendor_model?>(null);
  Rx<ShopModel?> shop = Rx<ShopModel?>(null);
  RxList sociallinks = [].obs;
  RxList<ShopModel> shops = <ShopModel>[].obs;
  Rx<XFile?> vendorDocumentImage = Rx<XFile?>(null);
  RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
  final ShopApi shopApi;
  ShopController({required this.shopApi}) {
    // getCurrentLocation();
    // Geolocator.getServiceStatusStream().listen((event) {
    //   getCurrentLocation();
    // });
    change(GetStatus.empty());
  }
  @override
  void onInit() {
    super.onInit();
    loadShopsData();
  }

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
  Future<List<ShopModel>> getMyShop() async {
    final response = await shopApi.getMyShops();
    final dataMap = response.data as Map<String, dynamic>;
    final List<dynamic> jsonList = dataMap['shops'] as List<dynamic>;
    myShops.value = jsonList
        .map((e) => ShopModel.fromJson(e as Map<String, dynamic>))
        .toList();
    if (kDebugMode) {
      print("The Myshop Data: ${myShops.value.map((e) => e.ownerEmail)}");
    }
    return myShops;
  }

  RxList<String> category = <String>[].obs;
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

  RxList<String> subcategory = <String>[].obs;
  Future<List<String>> getsubCategory(String category) async {
    try {
      final response = await shopApi.getsubCategory(category);
      if (response.status == false) {
        errorSnackBar("Failed to get Category");
        return [];
      }
      return subcategory.value =
          List<String>.from(response.data!['subCategory']);
    } catch (e) {
      if (kDebugMode) {
        print("Failed to Fetch The Sub Category:${e.toString()}");
      }
      return [];
    }
  }

  RxList<String> brands = <String>[].obs;
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

  Future<bool> addShopProduct(Map<String, dynamic> product) async {
    final response = await shopApi.addShopProduct(product);
    if (response.status == false) {
      errorSnackBar(response.message!);
      return false;
    }
    change(GetStatus.success(ProductModel.fromJson(response.data!)));
    return true;
  }

  RxInt selectedCategory = 0.obs;
  RxInt selectedsubCategory = 0.obs;
  RxInt selectedbrand = 0.obs;
  RxDouble setPrice = 0.0.obs;
  RxList<ProductModel> product = <ProductModel>[].obs;
  RxList<String> productsCategory = <String>[].obs;
  RxList<String> productssubCategory = <String>[].obs;
  RxList<String> productsBrand = <String>[].obs;
  RxDouble higestPriceProduct = 0.0.obs;
  Future<List<ProductModel>> getShopProduct(String shopid) async {
    final response = await shopApi.getShopProduct(shopid);
    product.value = (response.data!['products'] as List<dynamic>)
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
    productsCategory.value =
        product.map((category) => category.productCategory).toSet().toList();
    productssubCategory.value = product
        .map((subcatgeory) => subcatgeory.productSubCategory)
        .toSet()
        .toList();
    productsBrand.value =
        product.map((brand) => brand.productBrand).toSet().toList();
    higestPriceProduct.value = product
        .map((highest) => highest.productsPrice)
        .reduce((a, b) => a > b ? a : b);
    return product;
  }

  void updateVendorDetails(vendor_model vendorData) {
    vendor.value = vendorData;
  }

  void updateShopDetails(ShopModel shopData) {
    shop.value = shopData;
    saveShopData();
  }

  void updateVendorDocumentImage(XFile? image) {
    vendorDocumentImage.value = image;
  }

  vendor_model? getVendorDetails() {
    return vendor.value;
  }

  XFile? getVendorDocumentImage() {
    return vendorDocumentImage.value;
  }

  void resetAllData() {
    vendor.value = null;
    vendorDocumentImage.value = null;
  }

  //Shared Preferences
  void addShop(ShopModel shopData) {
    shops.add(shopData);
    saveShopData();
  }

  void updateShop(int index, ShopModel shopData) {
    if (index >= 0 && index < shops.length) {
      shops[index] = shopData;
      saveShopData();
    }
  }

  void removeShop(int index) {
    if (index >= 0 && index < shops.length) {
      shops.removeAt(index);
      saveShopData();
    }
  }

  Future<void> saveShopData() async {
    final pref = await SharedPreferences.getInstance();
    final shopsJson = shops.map((shop) => shop.toJson()).toList();
    await pref.setString('shops', json.encode(shopsJson));
    //logger.d'The shops data is saved');
  }

  Future<void> loadShopsData() async {
    final pref = await SharedPreferences.getInstance();
    final jsonData = pref.getString('shops');
    if (jsonData != null) {
      final List<dynamic> shopsJson = json.decode(jsonData);
      shops.value =
          shopsJson.map((shopJson) => ShopModel.fromJson(shopJson)).toList();
    }
  }

  Future<void> loadProductsForShop(String shopId) async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getString('products_$shopId');
    if (productsJson != null) {
      final List<dynamic> decodedProducts = json.decode(productsJson);
      products.value = List<Map<String, dynamic>>.from(decodedProducts);
    }
  }

  Future<void> addProductsToShop(
      String shopId, List<Map<String, dynamic>> newProducts) async {
    products.addAll(newProducts);
    await saveProductsForShop(shopId);
  }

  Future<void> saveProductsForShop(String shopId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('products_$shopId', json.encode(products.toList()));
  }

  Future<void> updateProductForShop(String shopId, String productId,
      Map<String, dynamic> updatedProduct) async {
    await loadProductsForShop(shopId);

    int index = products.indexWhere((product) => product['id'] == productId);
    if (index != -1) {
      products[index] = updatedProduct;
      await saveProductsForShop(shopId);
      //logger.d'Product updated successfully: $productId');
    } else {
      //logger.d'Product not found: $productId');
    }
  }
}
