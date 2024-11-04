
import 'package:geolocator/geolocator.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gully_app/utils/utils.dart';

import '../../utils/geo_locator_helper.dart';
import '../api/banner_promotion_api.dart';
import '../model/promote_banner_model.dart';

class PromotionController extends GetxController with StateMixin<PromoteBannerModel>{
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

  Future<PromoteBannerModel> createBanner(
    Map<String,dynamic> banner) async{
      try{
        final body=await bannerApi.createBanner(banner);
        return PromoteBannerModel.fromJson(body.data!);
      }catch(e){
        errorSnackBar(e.toString());
        rethrow;
      }
  }
  

}