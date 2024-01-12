import 'package:get/get.dart';
import 'package:gully_app/data/api/ranking_api.dart';
import 'package:gully_app/data/model/player_ranking_model.dart';
import 'package:gully_app/data/model/team_ranking_model.dart';
import 'package:gully_app/utils/utils.dart';

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
}
