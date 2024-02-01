import 'package:gully_app/utils/utils.dart';

import '../../config/api_client.dart';

class RankingApi {
  final GetConnectClient client;

  RankingApi({required this.client});

  Future<ApiResponse> getTeamRankingList(String ballType) async {
    var response = await client.get('/match/teamRanking/$ballType');
    if (!response.isOk) {
      throw response.body['message'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getPlayerRankingList(
      String ballType, String skill) async {
    var response = await client.get('/match/playerRanking/$ballType/$skill');
    if (!response.isOk) {
      throw response.body['message'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }
}
