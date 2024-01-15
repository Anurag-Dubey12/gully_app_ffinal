import 'dart:developer';

import 'package:gully_app/config/api_client.dart';
import 'package:gully_app/utils/utils.dart';

class ScoreboardApi {
  final GetConnectClient repo;

  ScoreboardApi({required this.repo});
  Future<ApiResponse> updateScoreBoard(Map<String, dynamic> scoreboard) async {
    log(scoreboard['secondInningHistory'].toString());
    var response = await repo.put(
        '/tournament-match/update-scoreboard/${scoreboard['matchId']}',
        {'scoreBoard': scoreboard});
    if (!response.isOk) {
      throw response.body['error'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }
}
