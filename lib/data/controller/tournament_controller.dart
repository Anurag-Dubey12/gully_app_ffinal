import 'package:get/get.dart';
import 'package:gully_app/data/api/tournament_api.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/utils/utils.dart';

class TournamentController extends GetxController {
  final TournamentApi tournamentApi;
  TournamentController(this.tournamentApi) {
    getTournamentList();
  }
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

  RxList<TournamentModel> tournamentList = <TournamentModel>[].obs;
  Future getTournamentList() async {
    try {
      final response = await tournamentApi.getTournamentList(
        latitude: 19.142677500362463,
        longitude: 72.82628403643015,
        startDate: selectedDate.value,
        endDate: selectedDate.value,
      );

      tournamentList.value = response.data!['tournamentList']
          .map<TournamentModel>((e) => TournamentModel.fromJson(e))
          .toList();
    } catch (e) {
      errorSnackBar(e.toString());
      return false;
    }
  }
}
