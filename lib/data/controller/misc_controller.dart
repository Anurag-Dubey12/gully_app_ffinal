import 'package:get/get.dart';
import 'package:gully_app/data/api/misc_api.dart';

class MiscController extends GetxController {
  final MiscApi repo;

  MiscController({required this.repo});

  Future<String> getContent(String slug) async {
    var response = await repo.getContent(slug);

    return response.data!['contenttext'];
  }
}
