import 'package:gully_app/config/api_client.dart';
import 'package:gully_app/utils/utils.dart';

class ScoreboardApi {
  final GetConnectClient repo;

  ScoreboardApi({required this.repo});
  Future<ApiResponse> updateScoreBoard(Map<String, dynamic> scoreboard) async {
    var response = await repo.post(
        '/match/updateScoreBoard/${scoreboard['matchId']}',
        {'scoreBoard': scoreboard});
    if (!response.isOk) {
      throw response.body['message'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getSingleMatchup(String matchId) async {
    final response = await repo.get('/match/getMatch/$matchId');
    if (response.statusCode! >= 500) {
      errorSnackBar('Server Error');
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(response.body['message']);
      throw Exception('Bad Request');
    }

    return ApiResponse.fromJson(response.body);
  }
}
