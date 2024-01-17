import 'package:gully_app/config/api_client.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';

class AuthApi extends GetConnectClient {
  Future<ApiResponse> loginViaGoogle(Map<String, dynamic> data) async {
    logger.i(data.toString());
    var response = await post('/auth/google/google-login', data);
    if (response.statusCode != 200) {
      throw Exception(response.body['message'] ??
          response.body['error'] ??
          'Unable to Process Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getUser() async {
    var response = await get('/organizer/profile/getProfile');
    if (response.statusCode != 200) {
      throw Exception(response.body['message'] ?? 'Unable to Process Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> createProfile(
      {required String nickName,
      required String phoneNumber,
      required String base64}) async {
    var response = await post('/profile/create', {
      'nickName': nickName,
      'phoneNumber': phoneNumber,
      'profilePhoto': base64,
    });
    if (response.statusCode != 200) {
      throw Exception(response.body['message'] ?? 'Unable to Process Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> verifyOtp({required String otp}) async {
    var response = await post('/profile/verifyOTP', {
      'otp': otp,
    });
    if (response.statusCode != 200) {
      throw Exception(response.body['message'] ?? 'Unable to Process Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> updateProfile(
      {required String nickName, required String base64}) async {
    var response = await put('/profile/editProfile', {
      // 'nickName': nickName,
      'profilePhoto': base64,
    });
    if (response.statusCode != 200) {
      throw Exception(response.body['message'] ?? 'Unable to Process Request');
    }
    return ApiResponse.fromJson(response.body);
  }
}
