import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gully_app/config/preferences.dart';
import 'package:gully_app/data/model/user_model.dart';
import 'package:gully_app/ui/screens/create_profile_screen.dart';
import 'package:gully_app/ui/screens/signup_screen.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/geo_locator_helper.dart';
import 'package:gully_app/utils/utils.dart';

import '../../ui/widgets/custom_snackbar.dart';
import '../api/auth_api.dart';

class AuthController extends GetxController with StateMixin<UserModel?> {
  final AuthApi repo;
  AuthController({required this.repo}) {
    change(GetStatus.empty());
    getUser();
    getCurrentLocation();
    Geolocator.getServiceStatusStream().listen((event) {
      getCurrentLocation();
    });
    // getUser();
  }
  RxString location = ''.obs;

  Future<void> getCurrentLocation() async {
    final coordinates = await determinePosition();

    location.value = await getAddressFromLatLng(coordinates);
    logger.d('Location ${location.value}');
  }

  Future<bool> loginViaGoogle() async {
    try {
      change(GetStatus.loading());

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        change(GetStatus.empty());
        return false;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      logger.t("googleAuth: $googleAuth");
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCred.user == null) {
        errorSnackBar("User not found");
      }
      final response = await repo.loginViaGoogle({
        'fullName': userCred.user!.displayName,
        'email': userCred.user!.email,
        'token': userCred.credential!.accessToken
      });
      final user = UserModel.fromJson(response.data!['user']);
      final accessToken = response.data!['accessToken'];
      final prefs = Get.find<Preferences>();
      prefs.storeToken(accessToken);
      change(GetStatus.success(user));
      await getUser();

      if (user.isNewUser) {
        Get.offAll(() => const CreateProfile());
        return false;
      }

      return true;
    } on FirebaseAuthException catch (e) {
      logger.e(e.toString());
      errorSnackBar(e.message ?? "Something went wrong at Firebase Auth");
      return false;
    } catch (e) {
      log("message ${e.toString()}");
      errorSnackBar("Unable to login, Please try again later");
      change(GetStatus.error(e.toString()));
      return false;
    }
  }

  Future<void> getUser() async {
    // change(GetStatus.loading());
    try {
      final response = await repo.getUser();
      UserModel? fetchedUser = UserModel.fromJson(response.data!['user']);
      // user.value = fetchedUser;
      change(GetStatus.success(fetchedUser));
      if (fetchedUser.isNewUser) {
        Get.offAll(() => const CreateProfile());
      }
      getCurrentLocation();
    } catch (e) {
      logger.e(e.toString());
      Get.offAll(() => const SignUpScreen());
      throw Exception(e.toString());
    }
  }

  Future<bool> createProfile({
    required String nickName,
    required String phoneNumber,
    required String base64,
  }) async {
    try {
      change(GetStatus.loading());
      final response = await repo.createProfile(
          nickName: nickName, phoneNumber: phoneNumber, base64: base64);

      final user = UserModel.fromJson(response.data!['user']);
      change(GetStatus.success(user));
      return true;
    } catch (e) {
      showSnackBar(title: e.toString(), message: e.toString(), isError: true);
      change(GetStatus.error(e.toString()));
      rethrow;
      // return false;
    }
  }

  Future<bool> updateProfile({
    required String nickName,
    required String base64,
  }) async {
    try {
      change(GetStatus.loading());
      final response =
          await repo.updateProfile(nickName: nickName, base64: base64);

      final user = UserModel.fromJson(response.data!['user']);
      change(GetStatus.success(user));
      return true;
    } catch (e) {
      showSnackBar(title: e.toString(), message: e.toString(), isError: true);
      change(GetStatus.error(e.toString()));
      rethrow;
      // return false;
    }
  }

  Future<bool> verifyOtp({
    required String otp,
  }) async {
    try {
      change(GetStatus.loading());
      await Future.delayed(const Duration(seconds: 2));
      final response = await repo.verifyOtp(otp: otp);
      final user = UserModel.fromJson(response.data!['user']);
      change(GetStatus.success(user));
      return true;
    } catch (e) {
      showSnackBar(title: e.toString(), message: e.toString(), isError: true);
      change(GetStatus.error(e.toString()));
      rethrow;
      // return false;
    }
  }
}
