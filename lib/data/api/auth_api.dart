import 'package:gully_app/config/api_client.dart';
import 'package:gully_app/utils/utils.dart';

import '../../utils/app_logger.dart';

class AuthApi {
  final GetConnectClient client;

  AuthApi({required this.client});
  Future<ApiResponse> loginViaGoogle(Map<String, dynamic> data) async {
    var response = await client.post('/auth/google_login', data);
    if (response.statusCode != 200) {
      throw response.body?['message'] ??
          response.body?['error'] ??
          'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> getUser() async {
    var response = await client.get('/user/getProfile');
    if (response.statusCode != 200) {
      throw Exception(response.body['message'] ?? 'Unable to Process Request');
    }
    var responseBody = response.body as Map<String, dynamic>;
    var accessToken = responseBody['data']['accessToken'];
    logger.d('AccessToken: $accessToken');
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> createProfile(
      {required String nickName,
      required String phoneNumber,
      required String base64,
      required bool isNewUser}) async {
    var response = await client.post('/user/createProfile', {
      'nickName': nickName,
      'phoneNumber': phoneNumber,
      'base64Image': base64,
      'isNewUser': isNewUser
    });

    if (response.statusCode != 200) {
      throw response.body?['message'] ?? 'Unable to Process Request';
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> verifyOtp({required String otp}) async {
    var response = await client.post('/user/verifyOTP', {
      'OTP': otp,
    });
    if (response.statusCode != 200) {
      throw Exception(response.body?['message'] ?? 'Unable to Process Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> updateProfile(
      {String? nickName, String? base64, String? fcmToken}) async {
    var response = await client.post('/user/editProfile', {
      'fcmToken': fcmToken,
      'base64Image': base64,
    });
    if (response.statusCode != 200) {
      throw Exception(response.body['message'] ?? 'Unable to Process Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> deleteAccount() async {
    var response = await client.get('/user/deleteProfile');
    if (response.statusCode != 200) {
      throw Exception(response.body['message'] ?? 'Unable to Process Request');
    }
    return ApiResponse.fromJson(response.body);
  }

  Future<ApiResponse> resendOTP(String phoneNumber) async {
    var response = await client.post('/user/sendOTP', {
      'phoneNumber': phoneNumber,
    });
    if (response.statusCode != 200) {
      throw Exception(response.body['message'] ?? 'Unable to Process Request');
    }
    return ApiResponse.fromJson(response.body);
  }
}
