import 'package:gully_app/data/api/team_api.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/date_time_helpers.dart';
import 'package:gully_app/utils/utils.dart';

import '../../config/api_client.dart';

class TournamentApi {
  final GetConnectClient repo;
  const TournamentApi({required this.repo});
  Future<ApiResponse> createTournament(Map<String, dynamic> tournament) async {

    var response = await repo.post('/main/createTournament', tournament);
    logger.d(response.body);
    if (!response.isOk) {
      throw response.body['message'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> editTournament(
      Map<String, dynamic> tournament, String tournamentId) async {
    var response =
        await repo.post('/main/editTournament/$tournamentId', tournament);
    if (response.statusCode! == 404) {
      errorSnackBar('Requested Path Not Found');
      throw Exception('Requested Path Not Found');
    }
    if (!response.isOk) {
      throw response.body?['message'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getTournamentList(
      {required double latitude,
      required double longitude,
      required DateTime startDate,
      required DateTime endDate,
      String? filter}) async {
    final obj = {
      'latitude': latitude,
      'longitude': longitude,
      'startDate': formatDateTime('yyyy-MM-dd', startDate),
      'endDate': formatDateTime('yyyy-MM-dd', endDate),
      'filter': filter,
    };
    logger.f(obj);
    var response = await repo.post('/main/getTournament', obj);
    if (!response.isOk) {
      throw response.body['error'] ?? 'Unable to Process Request';
    }

    return ApiResponse.fromJson(response.body);
  }
  Future<ApiResponse> getOrganizerTournamentList() async {
    var response = await repo.get('/main/getCurrentTournament');
    if (!response.isOk) {
      throw response.body['error'] ?? 'Unable to Process Request';
    }

    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> updateTeamRequest(
      String tournamentId, String teamId, String action) async {
    var response = await repo
        .post('/main/updateTeamRequest/$tournamentId/$teamId/$action', {});
    if (!response.isOk) {
      throw response.body['message'] ?? 'Unable to Process Request';
    }

    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getTeamRequests(String tournamentId) async {
    var response = await repo.get('/main/pendingTeamRequest/$tournamentId');
    if (!response.isOk) {
      throw response.body['error'] ?? 'Unable to Process Request';
    }

    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getRegisteredTeams(String tournamentId) async {
    var response = await repo.get('/main/acceptedTeamRequest/$tournamentId/');
    if (!response.isOk) {
      throw response.body['error'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }



  Future<ApiResponse> registerTeam({
    required String teamId,
    required String viceCaptainContact,
    required String address,
    required String tournamentId,
  }) async {
    final obj = {
      'teamId': teamId,
      'viceCaptainContact': viceCaptainContact,
      'address': address,
    };
    logger.i(obj);
    final response =
        await repo.post('/main/entryForm/$teamId/$tournamentId', obj);
    if (response.statusCode! >= 500) {
      errorSnackBar('Server Error');
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(response.body['message']);
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> organizeMatch(
      {required String tourId,
      required String team1,
      required String team2}) async {
    final obj = {
      'team1': team1,
      'team2': team2,
    };
    logger.i(obj);
    final response = await repo.post('/organizer/match/$tourId', obj);
    if (response.statusCode! >= 500) {
      errorSnackBar('Server Error');
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(response.body?['message'] ?? 'Bad Request');
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getMatchup(String tourId) async {
    final response = await repo.get('/match/getMatches/$tourId');
    if (response.statusCode! >= 500) {
      errorSnackBar('Server Error');
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(response.body?['message'] ?? 'Bad Request');
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> createMatchup(
      {required String tourId,
      required String team1,
      required String team2,
      required DateTime date,
      required String round,
      required int matchNo}) async {
    final obj = {
      'dateTime': date.toIso8601String(),
      'tournamentId': tourId,
      'round': round,
      'matchNo': matchNo,
      'team1ID': team1,
      'team2ID': team2,
    };
    logger.i(obj);
    final response = await repo.post('/match/createMatch', obj);
    if (response.statusCode! >= 500) {
      errorSnackBar('Server Error');
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(response.body['message']);
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }
  Future<ApiResponse> editMatch(Map<String,dynamic> match,String matchid)async{
    try{
      var response=await repo.put('match/editMatch/$matchid', match);
      logger.d(response.body);
      if (response.statusCode! >= 500) {
        errorSnackBar(generateErrorMessage(response.body));
        throw Exception('Server Error');
      } else if (response.statusCode!!= 200) {
        errorSnackBar(generateErrorMessage(response.body));
        throw Exception('Bad Request');
      }
      return ApiResponse.fromJson(response.body);
    }catch(e){
      logger.d("Unable to update Match Data:$e");
      rethrow;
    }
  }

  Future<ApiResponse> deleteMatch(String matchId) async {
    try {
      final response = await repo.delete('/match/deleteMatch/$matchId');
      return ApiResponse.fromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> cancelTournament(String tourId) async {
    try {
      final response = await repo.post('/main/deleteTournament/$tourId', {});
      logger.d(response.body);
      if (!response.isOk) {
        throw response.body['message'] ?? 'Unable to Process Request';
      }
      return ApiResponse.fromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> updateTournamentAuthority(
      String tourId, String authority) async {
    final obj = {"tournamentID": tourId, "UserId": authority};
    logger.i(obj);
    final response = await repo.post('/main/updateAuthority', obj);
    if (response.statusCode! >= 500) {
      errorSnackBar('Server Error');
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(response.body['message']);
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  ///search/:query
  Future<ApiResponse> searchTournament(String query) async {
    final response = await repo.get('/main/search?query=$query');
    logger.i(response.body);
    if (response.statusCode! >= 500) {
      errorSnackBar('Server Error');
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(response.body['message']);
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

// payment/tournamentFees
  Future<ApiResponse> getTournamentFees({required String tournamentId}) async {
    final response = await repo.post('/payment/tournamentFees', {
      'tournamentId': tournamentId,
    });
    logger.d("Response Status Code: ${response.statusCode}");
    logger.d("Response Body: ${response.body}");
    if (response.statusCode! >= 500) {
      errorSnackBar('Server Error');
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(response.body['message']);
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> createOrder(
      {required double discountAmount,
      required String tournamentId,
      required double totalAmount,
      required String? coupon}) async {
    final response = await repo.post('/payment/createOrder', {
      'amountWithoutCoupon': discountAmount,
      'tournamentId': tournamentId,
      'amount': totalAmount,
      'coupon': coupon,
    });
    if (response.statusCode! >= 500) {
      errorSnackBar('Server Error');
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(response.body['message']);
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getCoupons() async {
    final response = await repo.get('/payment/getCoupon');
    if (response.statusCode! >= 500) {
      errorSnackBar('Server Error');
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(response.body['message']);
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> applyCoupon(
      String tournamentId, String couponId, double amount) async {
    final response = await repo.post('/payment/applyCoupon', {
      'tournamentId': tournamentId,
      'couponId': couponId,
      'amount': amount,
    });
    if (response.statusCode! >= 500) {
      errorSnackBar('Server Error');
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(response.body['message']);
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  // getTransactions
  Future<ApiResponse> getTransactions() async {
    try{
    final response = await repo.get('/payment/transactionHistory');
    if (response.statusCode! >= 500) {
      errorSnackBar('Server Error');
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(response.body['message']);
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
    }catch(e){
      logger.d("Error in API call: $e");
      rethrow;
    }
  }
}
