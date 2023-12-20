import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/utils/app_logger.dart';

class SignUpScreen extends GetView<AuthController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage(
              'assets/images/sports_icon.png',
            ),
            fit: BoxFit.cover),
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff3F5BBF),
              Color(0xff3F5BBF),
              Color(0xffEEEFF5),
              Color(0xffEEEFF5),
              Colors.transparent
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Spacer(),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      scale: 3.2,
                    ),
                    Image.asset(
                      'assets/images/logo_shadow.png',
                      scale: 3,
                    ),
                  ],
                ),

                const Spacer(), const Spacer(),
                Text(
                  'Sign Up',
                  style: Get.textTheme.titleLarge,
                ),
                const Spacer(),
                // create a container sign up with google
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SocialButton(
                      image: 'google_icon.png',
                      title: 'Sign up with Google',
                      bgColor: Colors.white,
                      color: const Color.fromRGBO(0, 0, 0, 0.54),
                      onClick: () async {
                        try {
                          logger.i("97");
                          final GoogleSignInAccount? googleUser =
                              await GoogleSignIn().signIn();

                          logger.i("81");
                          // Obtain the auth details from the request
                          logger.i("message");
                          final GoogleSignInAuthentication? googleAuth =
                              await googleUser?.authentication;
                          logger.i("message");
                          // Create a new credential
                          final credential = GoogleAuthProvider.credential(
                            accessToken: googleAuth?.accessToken,
                            idToken: googleAuth?.idToken,
                          );

                          try {
                            logger.i("Signing in");
                            // Once signed in, return the UserCredential
                            final r = await FirebaseAuth.instance
                                .signInWithCredential(credential);
                            logger.f("${r.user}");
                            logger.f("${r.credential?.accessToken}");

                            controller.loginViaGoogle(r.user!.displayName!,
                                r.user!.email!, r.credential!.accessToken!);
                          } on FirebaseAuthException catch (e) {
                            logger.e(e.message);
                            rethrow;
                          } catch (e) {
                            logger.e(e.toString());
                            rethrow;
                          }
                        } catch (e) {
                          logger.e(e);
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    SocialButton(
                      image: 'apple_icon.png',
                      title: 'Sign up with Apple',
                      bgColor: Colors.black,
                      color: Colors.white,
                      onClick: () {},
                    ),
                  ],
                ),
                const Spacer(), const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String image;
  final String title;
  final Color bgColor;
  final Color color;
  final VoidCallback onClick;

  const SocialButton({
    super.key,
    required this.image,
    required this.title,
    required this.bgColor,
    required this.color,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick.call(),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: bgColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/$image',
              scale: 3,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: Get.textTheme.headlineMedium?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
