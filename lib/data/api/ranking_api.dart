import 'package:get/get.dart';
import 'package:gully_app/utils/utils.dart';

import '../../config/api_client.dart';
import '../controller/tournament_controller.dart';

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

  Future<ApiResponse> getTopPerformers(String ballType) async {
    final position = Get.find<TournamentController>().coordinates.value;
    var response = await client.post('/match/topPerformers', {
      'filter': ballType,
      'latitude': position.latitude,
      'longitude': position.longitude
    });
    if (!response.isOk) {
      throw response.body['message'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }
}
