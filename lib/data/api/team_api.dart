import 'package:get/get.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';

import '../../config/api_client.dart';
import '../controller/tournament_controller.dart';

class TeamApi {
  final GetConnectClient repo;
  const TeamApi({required this.repo});
  Future<ApiResponse> createTeam({
    required String teamName,
    required String? teamLogo,
  }) async {
    final obj = teamLogo == null
        ? {
            'teamName': teamName,
          }
        : {
            'teamName': teamName,
            'teamLogo': teamLogo,
          };
    logger.i(obj);
    final response = await repo.post('/team/createTeam', obj);
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! >= 400) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }

    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getPlayers({required String teamId}) async {
    final response = await repo.get('/team/getTeam/$teamId');
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
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
      required String role}
      ) async {
    final obj = {
      'name': name,
      'phoneNumber': phone,
      'role': role,
    };
    logger.i(obj);
    final response = await repo.post('/team/addplayer/$teamId', obj);
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getTeams() async {
    final response = await repo.get('/team/getUsersAllTeam');
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! >= 400) {
      errorSnackBar('Bad Request');
      return ApiResponse.fromJson(response.body);
    }

    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getOpponentTeams(
      String teamId, String tournamentId) async {
    final response = await repo.get('/match/getOpponent/$teamId/$tournamentId');
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
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
        .post('/team/deletePlayer/$teamId/$playerId', {}).then((response) {
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

  Future<ApiResponse> getOpponents() async {
    final response = await repo.get('/match/getOpponentTournamentId');
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! >= 400) {
      errorSnackBar('Bad Request');
      return ApiResponse.fromJson(response.body);
    }

    return ApiResponse.fromJson(response.body);
  }

  // getAllNearByTeam
  Future<ApiResponse> getAllNearByTeam() async {
    final authController = Get.find<TournamentController>();

    final response = await repo.post('/team/getAllNearByTeam', {
      'latitude': authController.coordinates.value.latitude,
      'longitude': authController.coordinates.value.longitude,
    });
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! >= 400) {
      errorSnackBar('Bad Request');
      return ApiResponse.fromJson(response.body);
    }

    return ApiResponse.fromJson(response.body);
  }

  //match/getChallengeMatch
  Future<ApiResponse> getChallengeMatch() async {
    final response = await repo.get('/match/getChallengeMatch');
    logger.d('Raw response body: ${response.body}');

    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! >= 400) {
      errorSnackBar('Bad Request');
      return ApiResponse.fromJson(response.body);
    }

    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> updateTeam(
      {required String teamName,
      String? teamLogo,
      required String teamId}) async {
    final obj = teamLogo == null
        ? {
            'teamName': teamName,
          }
        : {
            'teamName': teamName,
            'teamLogo': teamLogo,
          };
    logger.i(obj);
    final response = await repo.post('/team/editTeam/$teamId', obj);
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! >= 400) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> createChallengeMatch({
    required String teamId,
    required String opponentId,
    // required DateTime matchDate
  }) async {
    final obj = {
      'team1ID': teamId,
      'team2ID': opponentId,
      // 'dateTime': matchDate.toIso8601String(),
    };
    logger.i(obj);
    final response = await repo.post('/match/createChallengeMatch', obj);
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! >= 400) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  ///match/updateChallengeMatch
  Future<ApiResponse> updateChallengeMatch({
    required String matchId,
    required String status,
  }) async {
    final response =
        await repo.post('/match/updateChallengeMatch/$matchId/$status', {});
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! >= 400) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }
  Future<ApiResponse> getMyPerformance({
    required String userId,
    required String matchType,
    required String category,
  }) async {
    try {
      final response = await repo.post('/match/myPerformance/$userId',{
       'matchType': matchType,
        'category': category,
      });
      logger.d("Raw API response for myPerformance: ${response.body} and matchtypes is :$matchType and inning types is :$category");

      if (response.statusCode! >= 500) {
        errorSnackBar(generateErrorMessage(response.body));
        throw Exception('Server Error');
      } else if (response.statusCode! >= 400) {
        errorSnackBar(generateErrorMessage(response.body));
        return ApiResponse.fromJson(response.body);
      }

      return ApiResponse.fromJson(response.body);
    } catch (e) {
      logger.e("Error in getMyPerformance API call: $e");
      rethrow;
    }
  }

  Future<ApiResponse> getChallengePerformance({
    required String matchId,
  }) async {
    final response =
        await repo.get('/match/getChallengeMatchPerformance/$matchId');
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! >= 400) {
      errorSnackBar(generateErrorMessage(response.body));
      return ApiResponse.fromJson(response.body);
    }

    return ApiResponse.fromJson(response.body);
  }

}

String generateErrorMessage(dynamic response) {
  return response['message'] ?? "Something went wrong";
}
