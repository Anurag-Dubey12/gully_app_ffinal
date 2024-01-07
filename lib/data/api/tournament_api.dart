import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/date_time_helpers.dart';
import 'package:gully_app/utils/utils.dart';

import '../../config/api_client.dart';

class TournamentApi {
  final GetConnectClient repo;
  const TournamentApi({required this.repo});
  Future<ApiResponse> createTournament(Map<String, dynamic> tournament) async {
    var response = await repo.post('/organizer', tournament);
    if (!response.isOk) {
      throw response.body['error'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getTournamentList(
      {required double latitude,
      required double longitude,
      required DateTime startDate,
      required DateTime endDate}) async {
    final obj = {
      'latitude': latitude,
      'longitude': longitude,
      'startDate': formatDateTime('yyyy-MM-dd', startDate),
      'endDate': formatDateTime('yyyy-MM-dd', endDate),
    };
    logger.d(obj);
    var response = await repo.post('/organizer/tournament', obj);
    if (!response.isOk) {
      throw response.body['error'] ?? 'Unable to Process Request';
    }

    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getOrganizerTournamentList() async {
    var response = await repo.get('/organizer/profile/currentTournament/');
    if (!response.isOk) {
      throw response.body['error'] ?? 'Unable to Process Request';
    }

    return ApiResponse.fromJson(response.body);
  }
}
