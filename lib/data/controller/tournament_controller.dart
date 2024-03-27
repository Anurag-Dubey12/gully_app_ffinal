import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gully_app/data/api/tournament_api.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/utils/geo_locator_helper.dart';
import 'package:gully_app/utils/utils.dart';

class TournamentController extends GetxController
    with StateMixin<TournamentModel?> {
  final TournamentApi tournamentApi;
  TournamentController(this.tournamentApi) {
    getTournamentList();
    getCurrentLocation();
    Geolocator.getServiceStatusStream().listen((event) {
      getCurrentLocation();
    });
  }
  RxString location = ''.obs;

  Future<void> getCurrentLocation() async {
    final position = await determinePosition();

    coordinates.value = LatLng(position.latitude, position.longitude);
    coordinates.refresh();
  }

  set setCoordinates(LatLng value) {
    coordinates.value = value;
    coordinates.refresh();
    getTournamentList();
  }

  Rx<LatLng> coordinates = const LatLng(0, 0).obs;
  Future<bool> createTournament(Map<String, dynamic> tournament) async {
    try {
      await tournamentApi.createTournament(tournament);
      return true;
    } catch (e) {
      errorSnackBar(e.toString());
      return false;
    }
  }

  Future<bool> updateTournament(
      Map<String, dynamic> tournament, String tournamentId) async {
    try {
      await tournamentApi.editTournament(tournament, tournamentId);
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
  RxList<MatchupModel> matches = <MatchupModel>[].obs;
  RxBool isLoading = false.obs;
  Future getTournamentList({String? filter}) async {
    isLoading.value = true;
    if (coordinates.value.latitude == 0) {
      await getCurrentLocation();
    }
    try {
      final response = await tournamentApi.getTournamentList(
        latitude: coordinates.value.latitude,
        longitude: coordinates.value.longitude,
        startDate: selectedDate.value,
        filter: filter,
        endDate: selectedDate.value.add(const Duration(days: 7)),
      );

      tournamentList.value = response.data!['tournamentList']
          .map<TournamentModel>((e) => TournamentModel.fromJson(e))
          .toList();

      matches.value = response.data!['matches']
          .map<MatchupModel>((e) => MatchupModel.fromJson(e))
          .toList();
      isLoading.value = false;
      matches.refresh();
      tournamentList.refresh();
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }

  void setSelectedTournament(TournamentModel tournament) {
    change(GetStatus.success(tournament));
  }

  RxList<TournamentModel> organizerTournamentList = <TournamentModel>[].obs;
  Future<void> getOrganizerTournamentList() async {
    try {
      final response = await tournamentApi.getOrganizerTournamentList();

      organizerTournamentList.value = response.data!['tournamentList']
          .map<TournamentModel>((e) => TournamentModel.fromJson(e))
          .toList();
      // change(GetStatus.success(null));
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }

  Future<bool> updateTeamRequest(
    String tournamentId,
    String teamId,
    String action,
  ) async {
    try {
      await tournamentApi.updateTeamRequest(tournamentId, teamId, action);
      getOrganizerTournamentList();
      return Future.value(true);
    } catch (e) {
      errorSnackBar(e.toString());
      return Future.value(false);
    }
  }

  Future<List<TeamModel>> getTeamRequests(String tournamentId) async {
    try {
      final response = await tournamentApi.getTeamRequests(tournamentId);
      return response.data!['teamRequests']
          .map<TeamModel>((e) => TeamModel.fromJson(e['team']))
          .toList();
    } catch (e) {
      errorSnackBar(e.toString());
      return [];
    }
  }

  Future<List<TeamModel>> getRegisteredTeams(String tournamentId) async {
    try {
      final response = await tournamentApi.getRegisteredTeams(tournamentId);
      return response.data!['registeredTeams']
          .map<TeamModel>((e) => TeamModel.fromJson(e['team']))
          .toList();
    } catch (e) {
      errorSnackBar(e.toString());
      return [];
    }
  }

  Future<bool> registerTeam(
      {required String teamId,
      required String viceCaptainContact,
      required String address,
      required String tournamentId}) async {
    try {
      final response = await tournamentApi.registerTeam(
          teamId: teamId,
          viceCaptainContact: viceCaptainContact,
          address: address,
          tournamentId: tournamentId);
      return response.status!;
    } catch (e) {
      errorSnackBar(e.toString());
      return false;
    }
  }

  Future<bool> organizeMatch(String tourId, String team1, String team2) async {
    try {
      final response = await tournamentApi.organizeMatch(
          tourId: tourId, team1: team1, team2: team2);
      return response.status!;
    } catch (e) {
      errorSnackBar(e.toString());
      return false;
    }
  }

  Future<bool> createMatchup(String tourId, String team1, String team2,
      DateTime date, int matchNo, int round) async {
    try {
      final response = await tournamentApi.createMatchup(
          tourId: tourId,
          team1: team1,
          team2: team2,
          round: round,
          matchNo: matchNo,
          date: date);
      return response.status!;
    } catch (e) {
      errorSnackBar(e.toString());
      return false;
    }
  }

  Future<List<MatchupModel>> getMatchup(String tourId) async {
    try {
      final response = await tournamentApi.getMatchup(tourId);
      return response.data!['matches']
          .map<MatchupModel>((e) => MatchupModel.fromJson(e))
          .toList();
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }

  Future<bool> cancelTournament(String tourId) async {
    try {
      final response = await tournamentApi.cancelTournament(tourId);
      getOrganizerTournamentList();
      return response.status!;
    } catch (e) {
      errorSnackBar(e.toString());
      return false;
    }
  }

  Future<bool> updateTournamentAuthority(
      String tourId, String authority) async {
    try {
      final response =
          await tournamentApi.updateTournamentAuthority(tourId, authority);
      return response.status!;
    } catch (e) {
      errorSnackBar(e.toString());
      return false;
    }
  }
}
