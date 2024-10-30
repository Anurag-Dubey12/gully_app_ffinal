
import 'package:gully_app/utils/utils.dart';

import '../../config/api_client.dart';
import '../../utils/app_logger.dart';

class ServiceApi{
  final GetConnectClient repo;

  ServiceApi({required this.repo});

  Future<ApiResponse> registerService(Map<String,dynamic> service)async{
    var response=await repo.post("/vendors/register", service);
    logger.d(response.body);
    if (!response.isOk) {
      throw response.body['message'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }

}