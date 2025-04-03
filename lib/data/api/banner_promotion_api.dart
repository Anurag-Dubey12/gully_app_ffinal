import '../../utils/utils.dart';

import '../../config/api_client.dart';
import '../../utils/app_logger.dart';

class BannerApi {
  final GetConnectClient repo;
  BannerApi({required this.repo});

  Future<ApiResponse> createBanner(Map<String, dynamic> banner) async {
    var response = await repo.post('/banner/createbanner', banner);
    //logger.dresponse.body);

    if (!response.isOk) {
      throw response.body['message'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> editBanner(String id, Map<String, dynamic> banner) async {
    final response = await repo.post("/banner/updatebanner/$id", banner);
    //logger.dresponse.body);

    if (!response.isOk) {
      throw response.body['message'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getbanner() async {
    final response = await repo.get("/banner/getbanner");
    //logger.dresponse.body);
    if (!response.isOk) {
      throw response.body['message'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }
}
