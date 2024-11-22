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


class TournamentController extends GetxController
    with StateMixin<TournamentModel?> {
  final TournamentApi tournamentApi;
  TournamentController(this.tournamentApi) {
    getTournamentList(filterD: 'current');
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
    getTournamentList(filterD: 'current');
  }

  Rx<LatLng> coordinates = const LatLng(0, 0).obs;
  Future<TournamentModel> createTournament(
      Map<String, dynamic> tournament) async {
    try {
      final body = await tournamentApi.createTournament(tournament);
      return TournamentModel.fromJson(body.data!);
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



  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxString filter = ''.obs;
  void setSelectedDate(DateTime dateTime) {
    selectedDate.value = dateTime;
  }

  RxList<TournamentModel> tournamentList = <TournamentModel>[].obs;
  RxList<MatchupModel> matches = <MatchupModel>[].obs;
  RxBool isLoading = false.obs;


  Future<void> getTournamentList({String? filterD}) async {
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
        filter: filterD,
        endDate: selectedDate.value.add(const Duration(days: 7)),
      );
      logger.d("The entire Response: ${response.data}");
      if (response.data != null) {
        tournamentList.value = (response.data!['tournamentList'] as List<dynamic>?)
            ?.map((e) => TournamentModel.fromJson(e as Map<String, dynamic>))
            .toList() ?? [];
        matches.value = (response.data!['matches'] as List<dynamic>?)
            ?.map((e) => MatchupModel.fromJson(e as Map<String, dynamic>))
            .toList() ?? [];
      } else {
        tournamentList.value = [];
        matches.value = [];
      }
    } catch (e) {
      logger.d('Error in getTournamentList: $e');
      errorSnackBar(e.toString());
    } finally {
      isLoading.value = false;
      matches.refresh();
      tournamentList.refresh();
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

      organizerTournamentList.refresh();
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
      DateTime date, int matchNo, String round) async {
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
      print("Raw API response: ${response.data}");
      return response.data!['matches']
          .map<MatchupModel>((e) => MatchupModel.fromJson(e))
          .toList();
    } catch (e) {
      errorSnackBar(e.toString());
      rethrow;
    }
  }

  Rx<TeamModel?> battingTeam=Rx<TeamModel?>(null);
  Rx<TeamModel?> bowlingTeam=Rx<TeamModel?>(null);
  Rx<MatchupModel?> currentMatch=Rx<MatchupModel?>(null);
  RxString tossWonBy=''.obs;
  RxString electedTo=''.obs;
  RxInt overs=0.obs;
  RxBool isTournament=false.obs;

  void updateState({
    required TeamModel battingTeam,
    required TeamModel bowlingTeam,
    required MatchupModel match,
    required String tossWonBy,
    required String electedTo,
    required int overs,
    required bool isTournament,
  }){
    this.battingTeam.value=battingTeam;
    this.bowlingTeam.value=bowlingTeam;
    this.currentMatch.value=match;
    this.tossWonBy.value=tossWonBy;
    this.electedTo.value=electedTo;
    this.overs.value=overs;
    this.isTournament.value=isTournament;
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
      errorSnackBar(e.toString());
      rethrow;
    }
  }

  Future<double> getTournamentFee(String tournamentId) async {
    final res =
        await tournamentApi.getTournamentFees(tournamentId: tournamentId);
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

  Future<List<Coupon>>? getCoupons() async {
    try {
      final response = await tournamentApi.getCoupons();
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

  // Future<List<Transaction>> getTransactions() async {
  //   try {
  //     final response = await tournamentApi.getTransactions();
  //     logger.d("API Response: ${response.data}");
  //
  //     if (response.data == null) {
  //       logger.d("Response data is null");
  //       throw Exception("Response data is null");
  //     }
  //     if (response.data!['transactions'] == null) {
  //       logger.d("Transactions object is null");
  //       throw Exception("Transactions object is null");
  //     }
  //
  //     if (response.data!['transactions']['history'] == null) {
  //       logger.d("Transaction history is null");
  //       throw Exception("Transaction history is null");
  //     }
  //
  //     List<Transaction> transactions = [];
  //     for (var transactionJson in response.data!['transactions']['history']) {
  //       try {
  //         transactions.add(Transaction.fromJson(transactionJson));
  //       } catch (e) {
  //         logger.d("Error parsing transaction: $e");
  //         logger.d("Problematic transaction data: $transactionJson");
  //       }
  //     }
  //     logger.d("Parsed ${transactions.length} transactions");
  //     return transactions;
  //   } catch (e) {
  //     logger.d("Error in getTransactions: $e");
  //     errorSnackBar(e.toString());
  //     rethrow;
  //   }
  // }

  final authController=Get.find<AuthController>();
  RxList<Transaction>transactions=<Transaction>[].obs;
  Future<List<Transaction>> getTransactions() async {
    try {
      final userid = authController.state!.id;
      transactions.clear();

      final response = await tournamentApi.getTransactions();
      logger.d("API Response: ${response.data}");

      if (response.data == null) {
        logger.d("Response data is null");
        return [];
      }

      final transactionData = response.data!['transactions'];
      if (transactionData == null || transactionData['history'] == null) {
        logger.d("Transaction history is null");
        return [];
      }

      final transactionsList = transactionData['history'] as List;

      for (var transactionJson in transactionsList) {
        try {
          final tournamentData = transactionJson['tournament'];
          if (tournamentData != null &&
              (tournamentData['user'] == userid ||
                  tournamentData['authority'] == userid)) {
            final transaction = Transaction.fromJson(transactionJson);
            transactions.add(transaction);
          }
        } catch (e) {
          logger.d("Error parsing transaction: $e");
          logger.d("Problematic transaction data: $transactionJson");
        }
      }

      logger.d("Parsed ${transactions.length} transactions for user $userid");
      transactions.refresh();
      return transactions;
    } catch (e) {
      logger.d("Error in getTransactions: $e");
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
