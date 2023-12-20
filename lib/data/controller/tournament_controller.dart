import 'package:get/get.dart';
import 'package:gully_app/data/api/tournament_api.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/utils/utils.dart';

class TournamentController extends GetxController {
  final TournamentApi tournamentApi;
  TournamentController(this.tournamentApi);
  Future<bool> createTournament(Map<String, dynamic> tournament) async {
    try {
      await tournamentApi.createTournament(tournament);
      return true;
    } catch (e) {
      errorSnackBar(e.toString());
      return false;
    }
  }

  final Rx<DateTime> selectedDate = DateTime.now().obs;
  void setSelectedDate(DateTime dateTime) {
    selectedDate.value = dateTime;
  }

  RxList<TournamenModel> tournamentList = <TournamenModel>[].obs;
  Future getTournamentList() async {
    try {
      final response = await tournamentApi.getTournamentList();
      tournamentList.value = response.data['tournamentList']
          .map<TournamenModel>((e) => TournamenModel.fromJson(e))
          .toList();
    } catch (e) {
      errorSnackBar(e.toString());
      return false;
    }
  }
}
