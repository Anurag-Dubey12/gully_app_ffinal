import 'package:gully_app/config/api_client.dart';
import 'package:gully_app/data/api/team_api.dart';
import 'package:gully_app/utils/utils.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class ShopApi {
  final GetConnectClient repo;
  const ShopApi({required this.repo});

  Future<ApiResponse> registerShop(Map<String, dynamic> shop) async {
    final response = await repo.post("/shop/registerShop", shop);
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> editShop(Map<String, dynamic> shop) async {
    final response = await repo.post("/shop/editShop", shop);
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getMyShops() async {
    final response = await repo.get("/shop/getMyShop");
    // final prettyJson =
    //     const JsonEncoder.withIndent('  ').convert(response.body);
    // debugPrint(prettyJson, wrapWidth: 1024);

    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getNearbyShop(
      {required double latitude, required double longitude}) async {
    final response = await repo.post(
        "/shop/getNearbyShop/", {'longitude': longitude, 'latitude': latitude});
    // final prettyJson =
    //     const JsonEncoder.withIndent('  ').convert(response.body);
    // debugPrint(prettyJson, wrapWidth: 1024);
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getCategory() async {
    final response = await repo.get("/shop/getcategory");
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getsubCategory(String category) async {
    final response = await repo.get("/shop/getsubcategory/$category");
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getbrands() async {
    final response = await repo.get("/shop/getSportsBrand");
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> addShopProduct(Map<String, dynamic> product) async {
    final response = await repo.post("/shop/addProduct", product);
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> editProduct(Map<String, dynamic> product) async {
    final response = await repo.post("/shop/editProduct", product);
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getProduct(String productId) async {
    final response =
        await repo.post("/shop/getProduct", {"productId": productId});
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getFilterProduct(Map<String, dynamic> filteritem) async {
    final response = await repo.post("/shop/getFilterProduct", filteritem);
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getShop(String shopId) async {
    final response = await repo.post("/shop/getShop", {"shopId": shopId});
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getShopProduct(String shopId, int page) async {
    final response = await repo.get("/shop/getShopProduct/$shopId/$page");
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }
  Future<ApiResponse> getShopImageCount(String shopId) async {
    final response = await repo.get("/shop/getShopImageCount/$shopId");
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> setProductStatus(String productId, bool isActive) async {
    final response = await repo.post("/shop/ChangedProductStatus/",
        {'productId': productId, 'isActive': isActive});
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> updateSubscriptionStatus(
      Map<String, dynamic> shopsubscription) async {
    final response = await repo.post(
        "/shop/UpdateshopSubscriptionStatus/", shopsubscription);
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> addAddtionalPackage(
      Map<String, dynamic> shopsubscription) async {
    final response =
        await repo.post("/shop/additionalPackage/", shopsubscription);
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> searchShopsAndProducts(String query) async {
    final response = await repo.get("/shop/search/$query");
    // final prettyJson =
    //     const JsonEncoder.withIndent('  ').convert(response.body);
    // debugPrint(prettyJson, wrapWidth: 1024);

    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getSimilarProduct({
    required String productId,
    required double longitude,
    required double latitude,
    required int page,
    required int limit,
  }) async {
    final response = await repo.post("/shop/getSimilarProduct/", {
      "productId": productId,
      "longitude": longitude,
      "latitude": latitude,
      "page": page,
      "limit": limit,
    });
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getSimilarShopProduct({
    required String productId,
    required String shopId,
    required int page,
    required int limit,
  }) async {
    final response = await repo.post("/shop/getSimilarShopProduct/", {
      "productId": productId,
      "shopId": shopId,
      "page": page,
      "limit": limit,
    });
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getShopAnalytics(String shopId) async {
    final response = await repo.get("/shop/getShopAnalytics/$shopId");
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getProductViewAnalytics(
    String shopId,
    String timeRange,
  ) async {
    final response =
        await repo.get("/shop/getProductViewAnalytics/$shopId/$timeRange");
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getVisitorAnalytics(
    String shopId,
    String timeRange,
  ) async {
    final response =
        await repo.get("/shop/getVisitorAnalytics/$shopId/$timeRange");
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getDailyVisitors(
    String shopId,
    String days,
  ) async {
    final response = await repo.get("/shop/getDailyVisitors/$shopId/$days");
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> recordProductView(String productId, String shopId) async {
    final response = await repo.post(
        "/shop/recordProductView/", {"productId": productId, "shopId": shopId});
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> recordShopVisit(String shopId) async {
    final response =
        await repo.post("/shop/getDailyVisitors/", {"shopId": shopId});
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }
}
