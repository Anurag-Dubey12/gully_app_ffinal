import 'package:get/get.dart';
import 'package:gully_app/data/api/ranking_api.dart';
import 'package:gully_app/data/model/player_ranking_model.dart';
import 'package:gully_app/data/model/team_ranking_model.dart';
import 'package:gully_app/utils/utils.dart';

import '../../utils/app_logger.dart';

class RankingController extends GetxController {
  final RankingApi api;
  RankingController(this.api);

  Future<List<TeamRankingModel>> getTeamRankingList(String ballType) async {
    try {
      final response = await api.getTeamRankingList(ballType);

      return response.data!['teamsRanking']
          .map<TeamRankingModel>((e) => TeamRankingModel.fromJson(e))
          .toList();
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }

  Future<List<PlayerRankingModel>> getPlayerRankingList(
      String ballType, String skill) async {
    try {
      final response = await api.getPlayerRankingList(ballType, skill);

      return response.data!['playerRanking']
          .map<PlayerRankingModel>((e) => PlayerRankingModel.fromJson(e))
          .toList();
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }

  //topperformers
  Future<List<PlayerRankingModel>> getTopPerformers(
      String ballType, DateTime startDate) async {
    try {
      final response = await api.getTopPerformers(ballType, startDate);
      logger.d("The response Data is :${response.data}");
      if (response.data == null || !response.data!.containsKey('topPerformers')) {
        throw 'Invalid response format: missing topPerformers data';
      }
      return response.data!['topPerformers']
          .map<PlayerRankingModel>((e) => PlayerRankingModel.fromJson(e))
          .toList();

    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }
}
