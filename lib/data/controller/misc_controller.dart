import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gully_app/data/api/misc_api.dart';
import 'package:gully_app/data/model/package_model.dart';
import 'package:gully_app/data/model/banner_model.dart';
import 'package:gully_app/data/model/looking_for_model.dart';
import 'package:gully_app/utils/utils.dart';

import '../../utils/app_logger.dart';
import '../../utils/geo_locator_helper.dart';

class MiscController extends GetxController with StateMixin {
  final MiscApi repo;

  MiscController({required this.repo}) {
    change(GetStatus.empty());
    getCurrentLocation();
    Geolocator.getServiceStatusStream().listen((event) {
      getCurrentLocation();
    });
  }
  RxBool isaspectRatioequal = false.obs;
  RxBool isLocationEnable = false.obs;

  Future<void> getCurrentLocation() async {
    final position = await determinePosition();
    //logger.d(// "The Banner Coordinates is:${LatLng(position.latitude, position.longitude)}");
    coordinates.value = LatLng(position.latitude, position.longitude);
    coordinates.refresh();
    isLocationEnable.value = true;
  }

  set setCoordinates(LatLng value) {
    coordinates.value = value;
    //logger.d"The Banner Coordinates is:${coordinates.value}");
    coordinates.refresh();
  }

  Rx<LatLng> coordinates = const LatLng(0, 0).obs;
  RxBool isConnected = true.obs;
  RxInt indexvalue = 0.obs;
  PageController pageController = PageController();
  void updateIndex(int index) {
    indexvalue.value = index;
  }

  Future<String> getContent(String slug) async {
    var response = await repo.getContent(slug);
    //logger.d"The Content Data is:${response.data}");
    return response.data!['content'];
  }

  RxList<BannerModel> banners = <BannerModel>[].obs;
  Future<int> getBanners() async {
    try {
      // Default coordinates if location is disabled
      double lat = coordinates.value.latitude;
      double lng = coordinates.value.longitude;

      // If location is not available (0,0), use default coordinates
      if (lat == 0 && lng == 0) {
        // Use default coordinates (could be your app's default location)
        // or proceed without coordinates
      }

      var response = await repo.getBanners(latitude: lat, longitude: lng);

      banners.value = response.data!['banners']
          .map<BannerModel>((e) => BannerModel.fromJson(e))
          .toList();
      banners.refresh();
      return banners.length;
    } catch (e) {
      // Handle error but ensure banners list is at least initialized
      // so UI can show appropriate feedback
      if (banners.isEmpty) {
        banners.value = [];
        banners.refresh();
      }
      logger.e('Error getting banners: $e');
      return 0;
    }
  }

  Future<bool> addhelpDesk(Map<String, dynamic> data) async {
    change(GetStatus.loading());
    await repo.addhelpDesk(data);
    change(GetStatus.success({}));
    return true;
  }

  Future<UpdateAppModel> getVersion() async {
    try {
      var response = await repo.getVersion();
      return UpdateAppModel(
          version: response.data!['version'],
          forceUpdate: response.data!['forceUpdate']);
    } catch (e) {
      errorSnackBar(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<List<LookingForPlayerModel>> getMyLookings() async {
    try {
      var response = await repo.getMyLookingFor();
      return response.data!['data']
          .map<LookingForPlayerModel>((e) => LookingForPlayerModel.fromJson(e))
          .toList();
    } catch (e) {
      errorSnackBar(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<List<LookingForPlayerModel>> getLookingFor() async {
    try {
      var response = await repo.getLookingFor();
      return response.data!['data']
          .map<LookingForPlayerModel>((e) => LookingForPlayerModel.fromJson(e))
          .toList();
    } catch (e) {
      errorSnackBar(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<bool> addLookingFor(Map<String, dynamic> data) async {
    try {
      await repo.addLookingFor(data);
      return true;
    } catch (e) {
      errorSnackBar(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<bool> removeLookingFor(String id) async {
    try {
      await repo.removeLookingFor(id);
      return true;
    } catch (e) {
      errorSnackBar(e.toString());
      throw Exception(e.toString());
    }
  }

  Rx<Package?> selectedpackage = Rx<Package?>(null);
  RxList<Package> packages = <Package>[].obs;
  Future<List<Package>> getPackage(String packagefor) async {
    try {
      var response = await repo.getPackages(packagefor);
      //logger.d"The Package Response:${packagefor}");
      return packages.value = (response.data!['packages'] as List<dynamic>?)
              ?.map((e) => Package.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
    } catch (e) {
      errorSnackBar(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<List<Package>> getAdditionalPackages() async {
    try {
      var response = await repo.getAdditionalPackages();
      return packages.value = (response.data!['packages'] as List<dynamic>?)
              ?.map((e) => Package.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
    } catch (e) {
      errorSnackBar(e.toString());
      throw Exception(e.toString());
    }
  }

  RxInt packageLimit = 0.obs;
  Future<Package> getPackagebyId(String packageId) async {
    try {
      var response = await repo.getPackagebyId(packageId);
      packageLimit.value = response.data!['MaxEditAllowed'];
      return Package.fromJson(response.data!);
      // return packages.value = (response.data!['packages'] as List<dynamic>?)
      //     ?.map((e) => Package.fromJson(e as Map<String, dynamic>))
      //     .toList() ??
      //     [];
    } catch (e) {
      errorSnackBar(e.toString());
      throw Exception(e.toString());
    }
  }
}

class UpdateAppModel {
  final String version;
  final bool forceUpdate;
  // final String message;
  // final String url;
  UpdateAppModel({
    required this.version,
    required this.forceUpdate,
  });
}
