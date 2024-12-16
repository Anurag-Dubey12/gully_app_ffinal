import 'package:get/get.dart';
import 'package:gully_app/data/api/team_api.dart';
import 'package:gully_app/data/model/challenge_match.dart';
import 'package:gully_app/data/model/opponent_model.dart';
import 'package:gully_app/data/model/player_model.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';

class TeamController extends GetxController with StateMixin<TeamModel> {
  final TeamApi repo;
  TeamController({required this.repo}) {
    change(GetStatus.empty());
  }
  void setTeam(TeamModel team) {
    logger.i(team.toJson());
    change(GetStatus.success(team));
  }

  Future<bool> createTeam(
      {required String teamName, required String? teamLogo}) async {
    try {
      change(GetStatus.loading());
      final response = await repo.createTeam(
        teamName: teamName,
        teamLogo: teamLogo,
      );
      if (response.status == false) {
        errorSnackBar(response.message!);
        return false;
      }
      change(GetStatus.success(TeamModel.fromJson(response.data!)));
      refresh();

      return true;
    } catch (e) {
      change(GetStatus.error(e.toString()));
      rethrow;
    }
  }

  Future<bool> changeCaptain({
    required String teamId,
    required String newCaptainId,
  }) async {
    try {
      change(GetStatus.loading());
      final response = await repo.changeCaptain(
        teamId: teamId,
        newCaptainId: newCaptainId,
      );
      logger.d("The change captain response is: ${response.data}");
      if (response.status == false) {
        errorSnackBar(response.message ?? 'Failed to change captain');
        change(GetStatus.error('Failed to change captain'));
        return false;
      }
      if (response.data != null) {
        change(GetStatus.success(TeamModel.fromJson(response.data!)));
      }
      successSnackBar('Captain changed successfully');
      return true;
    } catch (e) {
      logger.e("Error changing captain: $e");
      change(GetStatus.error(e.toString()));
      errorSnackBar('An error occurred while changing captain');
      return false;
    }
  }

  Future<bool> updateTeam({
    required String teamName,
    required String? teamLogo,
    required String teamId,
  }) async {
    try {
      change(GetStatus.loading());
      final response = await repo.updateTeam(
        teamName: teamName,
        teamLogo: teamLogo,
        teamId: teamId,
      );
      if (response.status == false) {
        errorSnackBar(response.message!);
        return false;
      }
      change(GetStatus.success(TeamModel.fromJson(response.data!)));

      return true;
    } catch (e) {
      change(GetStatus.error(e.toString()));
      rethrow;
    }
  }

  RxList<PlayerModel> players = <PlayerModel>[].obs;
  Future<List<PlayerModel>> getPlayers() async {
    players.value = [];
    players.refresh();
    final response = await repo.getPlayers(teamId: state.id);
    if (response.status == false) {
      errorSnackBar(response.message!);
    }
    final playersList = (response.data!['teamData']['players'] as List)
        .map((e) => PlayerModel.fromJson(e))
        .toList();

    players.value = playersList;
    return playersList;
  }

  Future<bool> addPlayerToTeam({
    required String teamId,
    required String name,
    required String phone,
    required String role,
  }) async {
    final response = await repo.addPlayerToTeam(
      teamId: teamId,
      name: name,
      phone: phone,
      role: role,
    );
    if (response.status == false) {
      errorSnackBar(response.message!);
      return false;
    }
    getPlayers();
    return true;
  }

  Future<bool> removePlayerFromTeam({
    required String teamId,
    required String playerId,
  }) async {
    try {
      final response = await repo.removePlayerFromTeam(
        teamId: teamId,
        playerId: playerId,
      );
      logger.i("70");

      if (response.status == false) {
        errorSnackBar(response.message!);
        return false;
      }
      players.value.removeWhere((element) => element.id == playerId);
      players.refresh();
      return true;
    } catch (e) {
      logger.i(e);
      return false;
    }
  }

  Future<List<TeamModel>> getTeams() async {
    try {
      final response = await repo.getTeams();

      if (response.status == false) {
        logger.i('error');
        errorSnackBar(response.message!);
        return [];
      }
      final teams = response.data!['teams'] as List;
      final teamList = teams.map((e) => TeamModel.fromJson(e)).toList();

      return teamList;
    } catch (e) {
      logger.i(e.toString());
      rethrow;
    }
  }

  Future<List<OpponentModel>> getOpponents() async {
    try {
      final response = await repo.getOpponents();

      if (response.status == false) {
        logger.i('error');
        errorSnackBar(response.message!);
        return [];
      }

      final opponents = response.data!['data'] as List;
      final opponentList =
          opponents.map((e) => OpponentModel.fromJson(e)).toList();

      return opponentList;
    } catch (e) {
      logger.i(e.toString());
      rethrow;
    }
  }

  Future<List<TeamModel>> getOpponentTeamList(
      String teamId, String tournamentId) async {
    try {
      final response = await repo.getOpponentTeams(teamId, tournamentId);

      if (response.status == false) {
        logger.i('error');
        errorSnackBar(response.message!);
        return [];
      }
      final teams = response.data!['matches'] as List;

      final teamList =
          teams.map((e) => TeamModel.fromJson(e['opponent'])).toList();

      return teamList;
    } catch (e) {
      logger.i(e.toString());
      rethrow;
    }
  }

  // getAllNearByTeam
  Future<List<TeamModel>> getAllNearByTeam() async {
    try {
      final response = await repo.getAllNearByTeam();

      if (response.status == false) {
        logger.i('error');
        errorSnackBar(response.message!);
        return [];
      }
      List<TeamModel> teamList = [];
      final organizers = response.data!['teams'] as List;
      for (var i = 0; i < organizers.length; i++) {
        final teams = organizers[i]['teams'];
        for (var i = 0; i < teams.length; i++) {
          teamList.add(TeamModel.fromJson(teams[i]));
        }
      }

      logger.f(organizers.length);

      return teamList;
    } catch (e) {
      logger.i(e.toString());

      rethrow;
    }
  }

  //getChallengeMatch
  Future<List<ChallengeMatchModel>> getChallengeMatch() async {
    try {
      final response = await repo.getChallengeMatch();

      if (response.status == false) {
        logger.i('error is in getChallengeMatch');
        errorSnackBar(response.message!);
        return [];
      }

      final matches = response.data!['matches'] as List;
      final matchList =
          matches.map((e) => ChallengeMatchModel.fromJson(e)).toList();
      logger.f(matchList.length);

      return matchList;
    } catch (e) {
      logger.i("The Challenge Error is :${e.toString()}");
      rethrow;
    }
  }

  ///match/createChallengeMatch
  Future<bool> createChallengeMatch({
    required String teamId,
    required String opponentId,
    // required DateTime matchDate,
  }) async {
    try {
      final response = await repo.createChallengeMatch(
        teamId: teamId,
        opponentId: opponentId,
        // matchDate: matchDate,
      );
      if (response.status == false) {
        errorSnackBar(response.message!);
        return false;
      }
      return true;
    } catch (e) {
      logger.i(e.toString());
      rethrow;
    }
  }

  Future<bool> updateChallengeMatch({
    required String matchId,
    required String status,
  }) async {
    try {
      final response = await repo.updateChallengeMatch(
        matchId: matchId,
        status: status,
      );
      if (response.status == false) {
        errorSnackBar(response.message!);
        return false;
      }
      return true;
    } catch (e) {
      logger.i(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMyPerformance({
    required String userId,
    required String category,
  }) async {
    try {
      final response = await repo.getMyPerformance(
        userId: userId,
        category: category,
      );
      logger.d("The My Performance Data: ${response.data}");
      if (response.status == false) {
        errorSnackBar(response.message!);
        return {};
      }
      return response.data![category] ?? {};
    } catch (e) {
      logger.e("Error in getMyPerformance: $e");
      return {};
    }
  }

  Future<Map<String, dynamic>> getChallengePerformance({
    required String matchId,
  }) async {
    try {
      final response = await repo.getChallengePerformance(
        matchId: matchId,
      );
      logger.d("The Challenge Performance Data: ${response.data}");
      if (response.status == false) {
        logger.e("Error fetching challenge performance: ${response.message}");
        errorSnackBar(response.message!);
        return {};
      }
      return response.data ?? {};
    } catch (e) {
      logger.e("Error in getChallengePerformance: $e");
      return {};
    }
  }

}
