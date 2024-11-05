
import 'package:gully_app/data/api/team_api.dart';
import 'package:gully_app/utils/utils.dart';

import '../../config/api_client.dart';
import '../../utils/app_logger.dart';

class ServiceApi{
  final GetConnectClient repo;

  ServiceApi({required this.repo});

  Future<ApiResponse> addService(Map<String,dynamic> service) async {
    var response=await repo.post("/vendors/register", service);
    logger.d(response.body);
    // if (!response.isOk) {
    //   throw response.body['message'] ?? 'Unable to Process Request';
    // }
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getService()async{
    var response=await repo.get("/vendors");
    logger.d(response.body);
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode!!= 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }



}