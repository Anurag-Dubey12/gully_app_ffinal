import 'package:get/get.dart';
import 'package:gully_app/data/api/misc_api.dart';

class MiscController extends GetxController with StateMixin {
  final MiscApi repo;

  MiscController({required this.repo}) {
    change(GetStatus.empty());
  }

  Future<String> getContent(String slug) async {
    var response = await repo.getContent(slug);

    return response.data!['content'];
  }

  Future<bool> addhelpDesk(Map<String, dynamic> data) async {
    change(GetStatus.loading());
    await repo.addhelpDesk(data);
    change(GetStatus.success({}));
    return true;
  }
}
