import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gully_app/data/api/tournament_api.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/model/coupon_model.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/data/model/txn_model.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/geo_locator_helper.dart';
import 'package:gully_app/utils/utils.dart';

import '../model/points_table_model.dart';
import '../model/sponsor_model.dart';

class TournamentController extends GetxController
    with StateMixin<TournamentModel?> {
  TournamentController(this.tournamentApi) {
    getTournamentList(filterD: 'current');
    getCurrentLocation();
    Geolocator.getServiceStatusStream().listen((event) {
      getCurrentLocation();
    });
  }

  RxList<TeamModel> AllTeam = <TeamModel>[].obs;
  RxList<MatchupModel> Current_matches = <MatchupModel>[].obs;
  RxList<TournamentModel> Current_tournamentList = <TournamentModel>[].obs;
  RxList<TournamentSponsor> MyTournamentSponsor = <TournamentSponsor>[].obs;
  // Future<List<Transaction>> getTransactions() async {
  //   try {
  //     final response = await tournamentApi.getTransactions();
  //     //logger.d"API Response: ${response.data}");
  //
  //     if (response.data == null) {
  //       //logger.d"Response data is null");
  //       throw Exception("Response data is null");
  //     }
  //     if (response.data!['transactions'] == null) {
  //       //logger.d"Transactions object is null");
  //       throw Exception("Transactions object is null");
  //     }
  //
  //     if (response.data!['transactions']['history'] == null) {
  //       //logger.d"Transaction history is null");
  //       throw Exception("Transaction history is null");
  //     }
  //
  //     List<Transaction> transactions = [];
  //     for (var transactionJson in response.data!['transactions']['history']) {
  //       try {
  //         transactions.add(Transaction.fromJson(transactionJson));
  //       } catch (e) {
  //         //logger.d"Error parsing transaction: $e");
  //         //logger.d"Problematic transaction data: $transactionJson");
  //       }
  //     }
  //     //logger.d"Parsed ${transactions.length} transactions");
  //     return transactions;
  //   } catch (e) {
  //     //logger.d"Error in getTransactions: $e");
  //     errorSnackBar(e.toString());
  //     rethrow;
  //   }
  // }

  final authController = Get.find<AuthController>();

  Rx<TeamModel?> battingTeam = Rx<TeamModel?>(null);
  Rx<TeamModel?> bowlingTeam = Rx<TeamModel?>(null);
  Rx<LatLng> coordinates = const LatLng(0, 0).obs;
  RxInt couponsDisount = 0.obs;
  Rx<MatchupModel?> currentMatch = Rx<MatchupModel?>(null);
  RxString electedTo = ''.obs;
  RxList<TeamModel> eliminatedTeam = <TeamModel>[].obs;
  final RxString filter = ''.obs;
  RxString filterData = ''.obs;
  RxInt indexvalue = 0.obs;
  RxBool isEditable = true.obs;
  RxBool isLoading = false.obs;
  RxBool isSchedule = false.obs;
  RxBool isSearch = false.obs;
  RxBool isTourOver = false.obs;
  RxBool isTournament = false.obs;
  RxBool iscompleted = false.obs;
  RxString location = ''.obs;
  RxList<MatchupModel> matches = <MatchupModel>[].obs;
  RxList<MatchupModel> matchups = <MatchupModel>[].obs;
  RxList<TournamentModel> organizerTournamentList = <TournamentModel>[].obs;
  RxInt overs = 0.obs;
  final RxList<PointTableModel> points_table = <PointTableModel>[].obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  // Rx<TournamentSponsor?> sponsor = Rx<TournamentSponsor?>(null);
  final RxMap<String, dynamic> sponsormap = <String, dynamic>{}.obs;

  RxString tossWonBy = ''.obs;
  final TournamentApi tournamentApi;
  RxString tournamentEndDate = ''.obs;
  RxString tournamentId = ''.obs;
  RxList<TournamentModel> tournamentList = <TournamentModel>[].obs;
  // Rx<TournamentModel?> tournamentModel = Rx<TournamentModel?>(null);
  // final tournamentModel = RxMap<String, dynamic>();
  final RxMap<String, dynamic> tournamentModel = <String, dynamic>{}.obs;

  RxList<TournamentSponsor> tournamentSponsor = <TournamentSponsor>[].obs;
  RxString tournamentStartDate = ''.obs;
  RxString tournamentauthority = ''.obs;
  RxString tournamentname = ''.obs;
  RxList<Transaction> transactions = <Transaction>[].obs;

  void setScheduleStatus(bool status) {
    isSchedule.value = status;
  }

  Future<void> getCurrentLocation() async {
    final position = await determinePosition();

    coordinates.value = LatLng(position.latitude, position.longitude);
    coordinates.refresh();
  }

  set setCoordinates(LatLng value) {
    coordinates.value = value;
    coordinates.refresh();
    getTournamentList(filterD: 'current');
  }

  void setEditable(bool isedit) {
    isEditable.value = isedit;
  }

  Future<TournamentModel> createTournament(
      Map<String, dynamic> tournament) async {
    try {
      final response = await tournamentApi.createTournament(tournament);
      //logger.d"The response for tournament Creation:${response.data}");
      return TournamentModel.fromJson(response.data!);
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }

  Future<bool> setSponsor(Map<String, dynamic> tournament) async {
    try {
      final response = await tournamentApi.setSponsor(tournament);
      //logger.d"The response for tournament Sponsor:${response.data}");
      return true;
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }

  Future<bool> addSponsor(Map<String, dynamic> sponsor) async {
    try {
      final response = await tournamentApi.addSponsor(sponsor);
      if (response.status == false) {
        //logger.d"Unable to Upload Media");
      }
      return true;
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }

  Future<bool> editSponsor(
      String sponsorId, Map<String, dynamic> sponsor) async {
    try {
      final response = await tournamentApi.editSponsor(sponsorId, sponsor);
      //logger.d"The response for tournament Sponsor:${response.data}");
      if (response.status == false) {
        //logger.d"Failed to update Sponsor Data");
      }
      return true;
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }

  Future<List<TournamentSponsor>> getMyTournamentSponsor(
      String tournamentId) async {
    try {
      final response = await tournamentApi.getmyTournamentSponsor(tournamentId);
      //logger.d"The response for tournament Sponsor:${response.data}");
      if (response.status == false) {
        //logger.d"Failed to update Sponsor Data");
      }
      return MyTournamentSponsor.value = (response.data!['mySponsor']
                  as List<dynamic>?)
              ?.map(
                  (e) => TournamentSponsor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }

  void updateIndex(int index) {
    indexvalue.value = index;
  }

  Future<List<TournamentSponsor>> getTournamentSponsor(
      String tournamentId) async {
    try {
      final response = await tournamentApi.getTournamentSponsor(tournamentId);
      //logger.d"The response for tournament Sponsor:${response.data}");
      if (response.status == false) {
        //logger.d"Failed to update Sponsor Data");
      }
      return tournamentSponsor.value = (response.data!['Sponsor']
                  as List<dynamic>?)
              ?.map(
                  (e) => TournamentSponsor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }

  Future<bool> deleteSponsor(String sponsorId) async {
    try {
      final response = await tournamentApi.deleteSponsor(sponsorId);
      //logger.d"The response for tournament Sponsor:${response.data}");
      if (response.status == false) {
        //logger.d"Failed to Delete Sponsor Data");
      }
      return true;
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }

  Future<bool> updateTournament(
      Map<String, dynamic> tournament, String tournamentId) async {
    try {
      await tournamentApi.editTournament(tournament, tournamentId);
      await getOrganizerTournamentList();
      return true;
    } catch (e) {
      errorSnackBar(e.toString());
      return false;
    }
  }

  void saveDates(
      DateTime? startDate, DateTime? endDate, String tournamentauth) {
    if (startDate != null) {
      tournamentStartDate.value = startDate.toIso8601String();
    }
    if (endDate != null) {
      tournamentEndDate.value = endDate.toIso8601String();
    }
    tournamentauthority.value = tournamentauth;
  }

  DateTime? get startDateForPicker {
    return tournamentStartDate.value.isNotEmpty
        ? DateTime.parse(tournamentStartDate.value)
        : null;
  }

  DateTime? get endDateForPicker {
    return tournamentEndDate.value.isNotEmpty
        ? DateTime.parse(tournamentEndDate.value)
        : null;
  }

  void setSelectedFilter(String filter) {
    filterData.value = filter;
    //logger.d"Selected Filter:$filter");
    if (filter == 'past' || filter == 'current' || filter == 'upcoming') {
      //logger.d"Found Selected Filter with popup ");
      setSelectedDate(DateTime.now());
    }
  }

  void setSelectedDate(DateTime dateTime) {
    selectedDate.value = dateTime;
  }

  Future<void> getTournamentList({String? filterD, bool isLive = false}) async {
    try {
      filter.value = filterD ?? '';
      isLoading.value = true;

      if (coordinates.value.latitude == 0) {
        await getCurrentLocation();
      }

      await Future.delayed(const Duration(seconds: 1));

      final response = await tournamentApi.getTournamentList(
        latitude: coordinates.value.latitude,
        longitude: coordinates.value.longitude,
        startDate: selectedDate.value,
        filter: isLive ? 'current' : filterD,
        endDate: selectedDate.value.add(const Duration(days: 7)),
      );

      if (response.data != null) {
        if (isLive) {
          Current_tournamentList.value =
              (response.data!['tournamentList'] as List<dynamic>?)
                      ?.map((e) =>
                          TournamentModel.fromJson(e as Map<String, dynamic>))
                      .toList() ??
                  [];
          Current_matches.value = (response.data!['matches'] as List<dynamic>?)
                  ?.map((e) => MatchupModel.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [];
        } else {
          tournamentList.value =
              (response.data!['tournamentList'] as List<dynamic>?)
                      ?.map((e) =>
                          TournamentModel.fromJson(e as Map<String, dynamic>))
                      .toList() ??
                  [];
          matches.value = (response.data!['matches'] as List<dynamic>?)
                  ?.map((e) => MatchupModel.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [];
        }
      } else {
        if (isLive) {
          Current_tournamentList.value = [];
          Current_matches.value = [];
        } else {
          tournamentList.value = [];
          matches.value = [];
        }
      }
    } catch (e) {
      //logger.d'Error in getTournamentList: $e');
      // errorSnackBar(e.toString());
    } finally {
      isLoading.value = false;
      matches.refresh();
      tournamentList.refresh();
    }
  }

  Future<void> getCurrentTournamentList({
    String? filterD,
  }) async {
    try {
      filter.value = filterD ?? '';
      isLoading.value = true;

      if (coordinates.value.latitude == 0) {
        await getCurrentLocation();
      }

      await Future.delayed(const Duration(seconds: 1));

      final response = await tournamentApi.getTournamentList(
        latitude: coordinates.value.latitude,
        longitude: coordinates.value.longitude,
        startDate: selectedDate.value,
        filter: 'current',
        endDate: selectedDate.value.add(const Duration(days: 7)),
      );
      if (response.data != null) {
        Current_tournamentList.value = (response.data!['tournamentList']
                    as List<dynamic>?)
                ?.map(
                    (e) => TournamentModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
        Current_matches.value = (response.data!['matches'] as List<dynamic>?)
                ?.map((e) => MatchupModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
      } else {
        Current_tournamentList.value = [];
        Current_matches.value = [];
      }
    } catch (e) {
      //logger.d'Error in getTournamentList: $e');
      // errorSnackBar(e.toString());
    } finally {
      isLoading.value = false;
      matches.refresh();
      tournamentList.refresh();
    }
  }

  void setSelectedTournament(TournamentModel tournament) {
    change(GetStatus.success(tournament));
  }

  Future<void> getOrganizerTournamentList() async {
    try {
      final response = await tournamentApi.getOrganizerTournamentList();

      organizerTournamentList.value = response.data!['tournamentList']
          .map<TournamentModel>((e) => TournamentModel.fromJson(e))
          .toList();

      organizerTournamentList.refresh();
      // change(GetStatus.success(null));
    } catch (e) {
      // errorSnackBar(e.toString());
      //logger.e(e.toString());
      rethrow;
    }
  }

  Future<void> getAllTournament() async {
    try {
      final response = await tournamentApi.getUserAllTournament();

      organizerTournamentList.value = response.data!['tournamentList']
          .map<TournamentModel>((e) => TournamentModel.fromJson(e))
          .toList();

      organizerTournamentList.refresh();
      // change(GetStatus.success(null));
    } catch (e) {
      // errorSnackBar(e.toString());
      //logger.e(e.toString());
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
      // errorSnackBar(e.toString());
      //logger.e("Request Team Error:${e.toString()}");
      return [];
    }
  }

  Future<List<TeamModel>> getRegisteredTeams(String tournamentId) async {
    try {
      final response = await tournamentApi.getRegisteredTeams(tournamentId);
      var teams = (response.data!['registeredTeams'] as List)
          .where((team) => team['isEliminated'] == false)
          .map<TeamModel>((e) => TeamModel.fromJson(e['team']))
          .toList();
      AllTeam.value = (response.data!['registeredTeams'] as List)
          .map<TeamModel>((e) => TeamModel.fromJson(e['team']))
          .toList();
      eliminatedTeam.value = (response.data!['registeredTeams'] as List)
          .where((team) => team['isEliminated'] == true)
          .map<TeamModel>((e) => TeamModel.fromJson(e['team']))
          .toList();

      //logger.d"Filtered Teams:${AllTeam.value},${eliminatedTeam.value}");
      return teams;
    } catch (e) {
      //logger.e("Get Register Team Error: ${e.toString()}");
      rethrow;
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
      DateTime date, int matchNo, String round, String matchAuthority) async {
    try {
      final response = await tournamentApi.createMatchup(
          tourId: tourId,
          team1: team1,
          team2: team2,
          round: round,
          matchNo: matchNo,
          date: date,
          matchAuthority: matchAuthority);
      return response.status!;
    } catch (e) {
      errorSnackBar(e.toString());
      //logger.e(e.toString());
      return false;
    }
  }

  Future<List<MatchupModel>> getMatchup(String tourId) async {
    try {
      final response = await tournamentApi.getMatchup(tourId);
      //logger.d"Raw Matchup API response: ${response.data}");
      // await Clipboard.setData(ClipboardData(text: response.data.toString()));
      matchups.value = response.data!['matches']
          .map<MatchupModel>((e) => MatchupModel.fromJson(e))
          .toList();
      return matchups;
    } catch (e) {
      // errorSnackBar(e.toString());
      //logger.e("getMatchup error: ${e.toString()}");
      rethrow;
    }
  }

  Future<bool> editMatch(Map<String, dynamic> match, String matchId) async {
    try {
      var response = await tournamentApi.editMatch(match, matchId);
      if (response.status == false) {
        logger.i('Error: ${response.message}');
        errorSnackBar(response.message ?? 'Unable to update service');
        return false;
      }
      return true;
    } catch (e) {
      //logger.e('Error updating service: $e');
      rethrow;
    }
  }

  Future<bool> teamElimination(String tourId, List<String> teamId) async {
    try {
      final response = await tournamentApi.teamElimination(
          tournamentId: tourId, teamId: teamId);
      if (response.status == false) {
        logger.i('Error: ${response.message}');
        errorSnackBar(response.message ?? 'Unable to Eliminate Team');
        return false;
      }
      // await Future.wait([
      //   getMatchup(tournamentId.toString())
      // ]);
      return true;
    } catch (e) {
      errorSnackBar(e.toString());
      return false;
    }
  }

  Future<bool> deleteMatch(String matchid) async {
    try {
      final response = await tournamentApi.deleteMatch(matchid);
      if (response.status == false) {
        logger.i('Error: ${response.message}');
        errorSnackBar(response.message ?? 'Unable to update service');
        return false;
      }
      matchups.remove((element) => element.id == matchid);
      await Future.wait([getMatchup(tournamentId.toString())]);
      return true;
    } catch (e) {
      errorSnackBar(e.toString());
      return false;
    }
  }

  void updateState({
    required TeamModel battingTeam,
    required TeamModel bowlingTeam,
    required MatchupModel match,
    required String tossWonBy,
    required String electedTo,
    required int overs,
    required bool isTournament,
  }) {
    this.battingTeam.value = battingTeam;
    this.bowlingTeam.value = bowlingTeam;
    currentMatch.value = match;
    this.tossWonBy.value = tossWonBy;
    this.electedTo.value = electedTo;
    this.overs.value = overs;
    this.isTournament.value = isTournament;
  }

  Future<bool> cancelTournament(String tourId) async {
    try {
      final response = await tournamentApi.cancelTournament(tourId);
      getAllTournament();
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
      if (response.status!) {
        return response.status!;
      } else {
        errorSnackBar(response.message!);
        return false;
      }
    } catch (e) {
      errorSnackBar(e.toString());
      return false;
    }
  }

  //searchTournament
  Future<List<TournamentModel>> searchTournament(String query) async {
    try {
      final response = await tournamentApi.searchTournament(query);
      return response.data!['tournamentList']
          .map<TournamentModel>((e) => TournamentModel.fromJson(e))
          .toList();
    } catch (e) {
      errorSnackBar("Tournament Not Found");
      //logger.e(e.toString());
      rethrow;
    }
  }

  Future<List<PointTableModel>> tournamentPointsTable(String tourId) async {
    try {
      final response =
          await tournamentApi.tournamentPointsTable(tourId: tourId);
      //logger.d"Raw Points Table API response: ${response.data}");
      // getRegisteredTeams(tourId);
      points_table.value = (response.data!['TeamPoints'] as List)
          .map<PointTableModel>((e) => PointTableModel.fromJson(e))
          .toList();
      return points_table;
    } catch (e) {
      errorSnackBar("Points Table Not Found");
      //logger.e(e.toString());
      rethrow;
    }
  }

  Future<double> getTournamentFee(String tournamentLimit) async {
    final res =
        await tournamentApi.getTournamentFees(tournamentLimit: tournamentLimit);
    return double.parse(res.data!['fee'].toString());
  }

  Future<String> createOrder(
      {required double discountAmount,
      required String tournamentId,
      required double totalAmount,
      required String? coupon}) async {
    try {
      final response = await tournamentApi.createOrder(
          discountAmount: discountAmount,
          tournamentId: tournamentId,
          totalAmount: totalAmount,
          coupon: coupon);
      return response.data!['id'];
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }

  Future<String> createbannerOrder({
    required double discountAmount,
    required String bannerId,
    required double totalAmount,
    required String? coupon,
    required String status,
  }) async {
    try {
      final response = await tournamentApi.createBannerOrder(
          discountAmount: discountAmount,
          bannerId: bannerId,
          totalAmount: totalAmount,
          coupon: coupon,
          status: status);
      return response.data!['order']['id'];
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }

  Future<String> createSponsorOrder({
    required double discountAmount,
    required String sponsorPackageId,
    required double totalAmount,
    required String? coupon,
    required String status,
    required String tournamentId,
  }) async {
    try {
      final response = await tournamentApi.createSponsorOrder(
          discountAmount: discountAmount,
          sponsorPackageId: sponsorPackageId,
          totalAmount: totalAmount,
          coupon: coupon,
          status: status,
          tournamentId: tournamentId);
      return response.data!['order']['id'];
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }

  Future<List<Coupon>>? getCoupons() async {
    try {
      final response = await tournamentApi.getCoupons();
      //logger.d"API Response: ${response.data}");
      return response.data!['coupons']
          .map<Coupon>((e) => Coupon.fromJson(e))
          .toList();
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }

  Future applyCoupon(
      String tournamentId, String couponId, double amount) async {
    try {
      final response =
          await tournamentApi.applyCoupon(tournamentId, couponId, amount);
      return response.data;
    } catch (e) {
      errorSnackBar(e.toString());

      rethrow;
    }
  }

  Future<List<Transaction>> getTransactions() async {
    try {
      final userid = authController.state!.id;
      transactions.clear();

      final response = await tournamentApi.getTransactions();
      //logger.d"API Response: ${response.data}");

      if (response.data == null) {
        //logger.d"Response data is null");
        return [];
      }

      transactions.value = (response.data!['transactions'] as List<dynamic>?)
              ?.map((e) => Transaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      //logger.d"transactions data after fetch: ${transactions.value}");
      // final transactionsList = transactionData['history'] as List;
      //
      // for (var transactionJson in transactionsList) {
      //   try {
      //     final tournamentData = transactionJson['tournament'];
      //     if (tournamentData != null &&
      //         (tournamentData['user'] == userid ||
      //             tournamentData['authority'] == userid)) {
      //       final transaction = Transaction.fromJson(transactionJson);
      //       transactions.add(transaction);
      //     }
      //   } catch (e) {
      //     //logger.d"Error parsing transaction: $e");
      //     //logger.d"Problematic transaction data: $transactionJson");
      //   }
      // }
      //
      // //logger.d"Parsed ${transactions.length} transactions for user $userid");
      // transactions.refresh();
      return transactions;
    } catch (e) {
      //logger.d"Error in getTransactions: $e");
      errorSnackBar(e.toString());
      return [];
    }
  }

  Future<List<MatchupModel>> getTournamentMatches(String tournamentId) async {
    try {
      final response = await tournamentApi.getMatchup(tournamentId);
      return response.data!['matches']
          .map<MatchupModel>((e) => MatchupModel.fromJson(e))
          .toList();
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }
}
