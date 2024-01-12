import 'package:gully_app/utils/utils.dart';

import '../../config/api_client.dart';

class RankingApi extends GetConnectClient {
  // final GetConnectClient repo;
  // const RankingApi({required this.repo});

  Future<ApiResponse> getTeamRankingList(String ballType) async {
    var response = await get('/playerdata/team_ranking/$ballType');
    if (!response.isOk) {
      throw response.body['message'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getPlayerRankingList(
      String ballType, String skill) async {
    var response = await get('/playerdata/player_ranking/$ballType/$skill');
    if (!response.isOk) {
      throw response.body['message'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }
}
