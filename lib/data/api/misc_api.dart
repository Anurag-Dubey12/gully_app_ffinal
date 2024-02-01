import 'package:gully_app/utils/utils.dart';

import '../../config/api_client.dart';

class MiscApi {
  final GetConnectClient repo;

  MiscApi({required this.repo});

  Future<ApiResponse> getContent(String slug) async {
    var response = await repo.get('/other/getContent/$slug');
    if (!response.isOk) {
      throw response.body['error'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> addhelpDesk(Map<String, dynamic> data) async {
    var response = await repo.post('/other/addhelpDesk', data);
    if (!response.isOk) {
      throw response.body['error'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }
}
