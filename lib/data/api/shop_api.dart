import 'package:gully_app/config/api_client.dart';
import 'package:gully_app/data/api/team_api.dart';
import 'package:gully_app/utils/utils.dart';

class ShopApi {
  final GetConnectClient repo;
  const ShopApi({required this.repo});

  Future<ApiResponse> registerShop(Map<String, dynamic> shop) async {
    final response = await repo.post("/shop/registerShop", shop);
    if (response.statusCode! >= 500) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Server Error');
    } else if (response.statusCode! != 200) {
      errorSnackBar(generateErrorMessage(response.body));
      throw Exception('Bad Request');
    }
    return ApiResponse.fromJson(response.body);
  }
}
