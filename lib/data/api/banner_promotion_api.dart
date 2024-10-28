import 'package:gully_app/utils/utils.dart';

import '../../config/api_client.dart';
import '../../utils/app_logger.dart';

class BannerApi {
  final GetConnectClient repo;
  BannerApi({required this.repo});

  Future<ApiResponse> createBanner(Map<String,dynamic> banner) async{
    final response= await repo.post("/api/banner", banner);
    logger.d(response.body);

    if(!response.isOk){
      throw response.body['message'] ?? 'Unable to Process Request';
    }

    return ApiResponse.fromJson(response.body);
  }
}
