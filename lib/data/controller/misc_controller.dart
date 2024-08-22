import 'dart:ffi';

import 'package:get/get.dart';
import 'package:gully_app/data/api/misc_api.dart';
import 'package:gully_app/data/model/AdvertisementModel.dart';
import 'package:gully_app/data/model/banner_model.dart';
import 'package:gully_app/data/model/looking_for_model.dart';
import 'package:gully_app/utils/utils.dart';

class MiscController extends GetxController with StateMixin {
  final MiscApi repo;

  MiscController({required this.repo}) {
    change(GetStatus.empty());
  }
  RxList<BannerModel> banners = <BannerModel>[].obs;
  Future<String> getContent(String slug) async {
    var response = await repo.getContent(slug);

    return response.data!['content'];
  }

  Rx<AdvertisementModel?> ads=Rx<AdvertisementModel?>(null);

  void updateBanner({required AdvertisementModel Ads }){

    this.ads.value=Ads;
  }
  Future<void> getBanners() async {
    var response = await repo.getBanners();

    banners.value = response.data!['banners']
        .map<BannerModel>((e) => BannerModel.fromJson(e))
        .toList();
    banners.refresh();
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
