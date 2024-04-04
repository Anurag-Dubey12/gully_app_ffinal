import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/utils/utils.dart';

import '../../config/api_client.dart';

class MiscApi {
  final GetConnectClient repo;

  MiscApi({required this.repo});

  Future<ApiResponse> getContent(String slug) async {
    var response = await repo.get('/other/getContent/$slug');
    if (!response.isOk) {
      throw response.body['message'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> addhelpDesk(Map<String, dynamic> data) async {
    var response = await repo.post('/other/addhelpDesk', data);
    if (!response.isOk) {
      throw response.body['message'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getBanners() {
    return repo.get('/other/getBanner').then((response) {
      if (!response.isOk) {
        throw response.body['message'] ?? 'Unable to Process Request';
      }
      return ApiResponse.fromJson(response.body);
    });
  }

  Future<ApiResponse> getVersion() {
    return repo.get('/other/update').then((response) {
      if (!response.isOk) {
        if (response.statusCode == 401) {
          throw 'Unauthorized';
        }
        if (response.statusCode == 403) {
          throw 'Forbidden';
        }
        if (response.statusCode == 404) {
          throw 'Not Found';
        }
        throw response.body['message'] ?? 'Unable to Process Request';
      }
      return ApiResponse.fromJson(response.body);
    });
  }

  Future<ApiResponse> getLookingFor() async {
    final authController = Get.find<TournamentController>();
    return repo.post('/team/getAllLooking', {
      'latitude': authController.coordinates.value.latitude,
      'longitude': authController.coordinates.value.longitude,
    }).then((response) {
      if (!response.isOk) {
        throw response.body['message'] ?? 'Unable to Process Request';
      }
      return ApiResponse.fromJson(response.body);
    });
  }

  Future<ApiResponse> getMyLookingFor() async {
    return repo.get('/team/getLookingByID').then((response) {
      if (!response.isOk) {
        throw response.body['message'] ?? 'Unable to Process Request';
      }
      return ApiResponse.fromJson(response.body);
    });
  }

  Future<ApiResponse> addLookingFor(Map<String, dynamic> data) async {
    return repo.post('/team/addLookingFor', data).then((response) {
      if (!response.isOk) {
        throw response.body['message'] ?? 'Unable to Process Request';
      }
      return ApiResponse.fromJson(response.body);
    });
  }

  Future<ApiResponse> removeLookingFor(String id) async {
    return repo.post('/team/deleteLookingFor/$id', {}).then((response) {
      if (!response.isOk) {
        throw response.body['message'] ?? 'Unable to Process Request';
      }
      return ApiResponse.fromJson(response.body);
    });
  }
}
