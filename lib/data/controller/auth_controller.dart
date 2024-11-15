import 'package:app_links/app_links.dart';
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

import '../../ui/screens/choose_lang_screen.dart';
import '../../ui/screens/splash_screen.dart';
import '../../ui/widgets/custom_snackbar.dart';
import '../api/auth_api.dart';

class AuthController extends GetxController with StateMixin<UserModel?> {
  final AuthApi repo;
  AuthController({required this.repo}) {
    change(GetStatus.empty());

    getCurrentLocation();
    Geolocator.getServiceStatusStream().listen((event) {
      getCurrentLocation();
    });
  }
  RxString location = ''.obs;

  Future<void> getCurrentLocation() async {
    final coordinates = await determinePosition(
        accuracy: LocationAccuracy.bestForNavigation,
        forceAndroidLocationManager: true);

    location.value =
        await getAddressFromLatLng(coordinates.latitude, coordinates.longitude);
    logger.d('Location ${location.value}');
  }

  set setLocation(String value) => location.value = value;

  Future<bool> loginViaGoogle() async {
    try {
      change(GetStatus.loading());

      final GoogleSignInAccount? googleUser = await GoogleSignIn.standard(
          scopes: [
            "email",
            "https://www.googleapis.com/auth/userinfo.profile"
          ]).signIn();

      if (googleUser == null) {
        errorSnackBar('User not found at Google');
        change(GetStatus.empty());
        return false;
      }
      // successSnackBar('User  found at Google ${googleUser.displayName}');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      logger.t("googleAuth: $googleAuth");
      // successSnackBar('Google Auth: ${googleAuth.accessToken}');
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);
      // successSnackBar('User Cred: ${userCred.user}');
      if (userCred.user == null) {
        errorSnackBar("User not found");
      }
      Position? position;
      String placeName = 'Default Location';
      try {
        position = await determinePosition(
          accuracy: LocationAccuracy.best,
        );
        placeName =
            await getAddressFromLatLng(position.latitude, position.longitude);
      } catch (e) {
        position = null;
        errorSnackBar(e.toString());
      }
      // successSnackBar(
      //     'Got Position: ${position.latitude} ${position.longitude}');
      // successSnackBar(
      //     'Got Position: ${position.latitude} ${position.longitude}');
      var body = {
        'fullName': userCred.user!.displayName,
        'email': userCred.user!.email,
        'coordinates': {
          'latitude': position?.latitude ?? 12.1,
          'longitude': position?.longitude ?? 11.1,
          'placeName': placeName,
          // 'latitude': 12.3,
          // 'longitude': 11.3,
          // 'placeName': 'Demo',
        }
      };
      // successSnackBar('Body: $body');
      final applinks = AppLinks();
      final uri = await applinks.getLatestAppLink();
      if (uri != null) {
        body['phoneNumber'] = uri.queryParameters["refer_id"];
      }
      // successSnackBar('Body + AFTER LINK : $body');
      final response = await repo.loginViaGoogle(body);
      final user = UserModel.fromJson(response.data!['user']);
      final accessToken = response.data!['user']['accessToken'];
      // successSnackBar('User DONE: $user');
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
      errorSnackBar(e.message?? "Something went wrong at Firebase Auth");
      return false;
    } catch (e) {
      errorSnackBar(e.toString());
      logger.e('the error messgae is ${e.toString() }');
      change(GetStatus.error(e.toString()));
      return false;
    }
  }

  Future<void> getUser() async {
    // change(GetStatus.loading());
    try {
      final response = await repo.getUser();
      UserModel? fetchedUser = UserModel.fromJson(response.data!);
      // user.value = fetchedUser;
      change(GetStatus.success(fetchedUser));
      if (fetchedUser.isNewUser) {
        Get.offAll(() => const CreateProfile());
        return;
      }
      final pref = Get.put<Preferences>(Preferences(), permanent: true);
      logger.f("Language: ${pref.getLanguage()}");
      // if (!pref.languageSelected) {
      //   Get.offAll(() => const ChooseLanguageScreen());
      //   // return false;
      // }
      refresh();
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
        nickName: nickName,
        phoneNumber: phoneNumber,
        base64: base64,
        isNewUser: state!.isNewUser,
      );

      final user = UserModel.fromJson(response.data!['user']);
      change(GetStatus.success(user));
      return true;
    } catch (e) {
      errorSnackBar(
        e.toString(),
      );
      change(GetStatus.error(e.toString()));
      rethrow;
      // return false;
    }
  }

  Future<bool> updateProfile({
    String? nickName,
    String? base64,
    String? fcmToken,
  }) async {
    try {
      change(GetStatus.loading());
      final response = await repo.updateProfile(
          nickName: nickName, base64: base64, fcmToken: fcmToken);

      final user = UserModel.fromJson(response.data!['user']);
      change(GetStatus.success(user));
      getUser();
      refresh();
      return true;
    } catch (e) {
      showSnackBar(title: e.toString(), message: e.toString(), isError: true);
      change(GetStatus.error(e.toString()));
      rethrow;
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

  Future<bool> sendOTP() async {
    try {
      change(GetStatus.loading());
      await Future.delayed(const Duration(seconds: 2));
      final response = await repo.resendOTP(state!.phoneNumber!);
      // final user = UserModel.fromJson(response.data!['user']);
      successSnackBar(response.message!);
      change(GetStatus.success(state));
      return true;
    } catch (e) {
      showSnackBar(title: e.toString(), message: e.toString(), isError: true);
      change(GetStatus.error(e.toString()));
      rethrow;
      // return false;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      await repo.deleteAccount();
      logout();

      return true;
    } catch (e) {
      showSnackBar(title: e.toString(), message: e.toString(), isError: true);
      change(GetStatus.error(e.toString()));
      rethrow;
      // return false;
    }
  }

  Future<void> logout() async {
    try {
      change(GetStatus.loading());
      final controller = Get.find<Preferences>();
      controller.clear();
      final googleSignIn = GoogleSignIn();
      try {
        await googleSignIn.disconnect();
        await googleSignIn.signOut();
      } catch (e) {
        logger.e(e);
      }
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
      }

      change(GetStatus.empty());
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.offAll(() => const SplashScreen());
      });
    } catch (e) {
      showSnackBar(title: e.toString(), message: e.toString(), isError: true);
      change(GetStatus.error(e.toString()));
      rethrow;
    }
  }
}
