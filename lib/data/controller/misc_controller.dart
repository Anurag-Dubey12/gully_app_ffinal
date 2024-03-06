import 'package:get/get.dart';
import 'package:gully_app/data/api/misc_api.dart';
import 'package:gully_app/data/model/banner_model.dart';

class MiscController extends GetxController with StateMixin {
  final MiscApi repo;

  MiscController({required this.repo}) {
    change(GetStatus.empty());
    getBanners();
  }
  RxList<BannerModel> banners = <BannerModel>[].obs;
  Future<String> getContent(String slug) async {
    var response = await repo.getContent(slug);

    return response.data!['content'];
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
}
