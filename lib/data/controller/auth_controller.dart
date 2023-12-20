import 'package:get/get.dart';
import 'package:gully_app/data/model/user_model.dart';

import '../../ui/widgets/custom_snackbar.dart';
import '../api/auth_api.dart';

class AuthController extends GetxController with StateMixin<UserModel> {
  final AuthApi repo;
  AuthController({required this.repo}) {
    change(GetStatus.empty());
    // getUser();
  }
  Future<bool> loginViaGoogle(
      String fullName, String email, String token) async {
    change(GetStatus.loading());

    try {
      final response = await repo.loginViaGoogle({
        'fullName': email,
        'email': email,
        'token': token,
      });

      change(GetStatus.success(response));
      return true;
    } catch (e) {
      showSnackBar(title: e.toString(), message: e.toString(), isError: true);
      change(GetStatus.error(e.toString()));
      return false;
    }
  }
}
