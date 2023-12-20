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

  Future<ApiResponse> getTournamentList() async {
    var response = await repo.get('/organizer/tournament');
    if (!response.isOk) {
      throw response.body['error'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }
}
