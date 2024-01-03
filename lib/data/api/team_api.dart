import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';

import '../../config/api_client.dart';

class TeamApi {
  final GetConnectClient repo;
  const TeamApi({required this.repo});
  Future<ApiResponse> createTeam({
    required String teamName,
    required String teamLogo,
  }) async {
    final obj = {
      'teamName': teamName,
      'teamLogo': teamLogo,
    };
    logger.i(obj);
    final response = await repo.post('/users/createteam', obj);
    if (response.statusCode! >= 500) {
      errorSnackBar('Server Error');
      throw Exception('Server Error');
    } else if (response.statusCode! >= 400) {
      errorSnackBar('Bad Request');
      return ApiResponse.fromJson(response.body);
    }

    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getPlayers({required String teamId}) async {
    final response = await repo.get('/organizer/profile/team/$teamId');
    if (response.statusCode! >= 500) {
      errorSnackBar('Server Error');
      throw Exception('Server Error');
    } else if (response.statusCode! >= 400) {
      errorSnackBar('Bad Request');
      return ApiResponse.fromJson(response.body);
    }

    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> addPlayerToTeam(
      {required String teamId,
      required String name,
      required String phone,
      required String role}) async {
    final obj = {
      'name': name,
      'phoneNumber': phone,
      'role': role,
    };
    logger.i(obj);
    final response = await repo.post('/users/addplayer/$teamId', obj);
    if (response.statusCode! >= 500) {
      errorSnackBar('Server Error');
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(response.body['message']);
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getTeams() async {
    final response = await repo.get('/users/teams');
    if (response.statusCode! >= 500) {
      errorSnackBar('Server Error');
      throw Exception('Server Error');
    } else if (response.statusCode! >= 400) {
      errorSnackBar('Bad Request');
      return ApiResponse.fromJson(response.body);
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> removePlayerFromTeam(
      {required String teamId, required String playerId}) {
    final obj = {
      'playerId': playerId,
    };
    logger.i(obj);
    return repo
        .delete(
      '/users/deletePlayer/$teamId/$playerId',
    )
        .then((response) {
      if (response.isOk) {
        return ApiResponse.fromJson(response.body);
      } else {
        if (response.statusCode! >= 500) {
          logger.i('error');
          throw Exception('Server Error');
        } else if (response.statusCode! >= 400) {
          logger.i('BD');
          return ApiResponse.fromJson(response.body);
        } else {
          throw Exception('Something went wrong');
        }
      }
    });
  }
}
