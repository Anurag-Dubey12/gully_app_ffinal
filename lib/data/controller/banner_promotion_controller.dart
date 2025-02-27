import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gully_app/utils/utils.dart';

import '../../utils/app_logger.dart';
import '../../utils/geo_locator_helper.dart';
import '../api/banner_promotion_api.dart';
import '../model/PromotionalBannerModel.dart';

class PromotionController extends GetxController
    with StateMixin<PromotionalBanner> {
  final BannerApi bannerApi;
  Rx<LatLng> coordinates = const LatLng(0, 0).obs;
  PromotionController({required this.bannerApi}) {
    // getCurrentLocation();
    // Geolocator.getServiceStatusStream().listen((event) {
    //   getCurrentLocation();
    // });
    change(GetStatus.empty());
  }
  Future<void> getCurrentLocation() async {
    final position = await determinePosition();
    coordinates.value = LatLng(position.latitude, position.longitude);
    coordinates.refresh();
  }

  final RxMap<String, dynamic> banner = <String, dynamic>{}.obs;

  Future<PromotionalBanner> createBanner(Map<String, dynamic> banner) async {
    try {
      final response= await bannerApi.createBanner(banner);
      logger.d("The response for Banner Creation:${response.data}");
      return PromotionalBanner.fromJson(response.data!);
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }

  RxList<PromotionalBanner> bannerList = <PromotionalBanner>[].obs;
  Future<List<PromotionalBanner>> getPromotionalBanner() async {
    try{
      final response = await bannerApi.getbanner();
      logger.d("My Banner Data:${response.data}");
      return bannerList.value = (response.data!['Banners'] as List<dynamic>?)
          ?.map((e) => PromotionalBanner.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [];
    }catch(err){
      errorSnackBar(err.toString());
      throw Exception(err.toString());
    }
  }

  Future<bool> editBanner(String id,Map<String, dynamic> banner) async {
    try {
      return true;
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }
}
