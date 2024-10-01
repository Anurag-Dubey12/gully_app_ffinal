import 'dart:convert';

import 'package:get/get.dart';
import 'package:gully_app/data/model/vendor_model.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ShopController extends GetxController with StateMixin {

  Rx<vendor_model?> vendor=Rx<vendor_model?>(null);
  Rx<shop_model?> shop=Rx<shop_model?>(null);
  RxList sociallinks=[].obs;
  RxList<shop_model> shops = <shop_model>[].obs;
  Rx<XFile?> vendorDocumentImage = Rx<XFile?>(null);
  RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;


  @override
  void onInit() {
    super.onInit();
    loadShopsData();
  }

  void updateVendorDetails(vendor_model vendorData) {
    vendor.value = vendorData;
  }

  void updateShopDetails(shop_model shopData) {
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
    vendor.value=null;
    vendorDocumentImage.value=null;
  }


  //Shared Preferences
  void addShop(shop_model shopData) {
    shops.add(shopData);
    saveShopData();
  }

  void updateShop(int index, shop_model shopData) {
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
    logger.d('The shops data is saved');
  }

  Future<void> loadShopsData() async {
    final pref = await SharedPreferences.getInstance();
    final jsonData = pref.getString('shops');
    if (jsonData != null) {
      final List<dynamic> shopsJson = json.decode(jsonData);
      shops.value = shopsJson.map((shopJson) => shop_model.fromJson(shopJson)).toList();
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

  Future<void> addProductsToShop(String shopId, List<Map<String, dynamic>> newProducts) async {
    products.addAll(newProducts);
    await saveProductsForShop(shopId);
  }

  Future<void> saveProductsForShop(String shopId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('products_$shopId', json.encode(products.toList()));
  }
}
