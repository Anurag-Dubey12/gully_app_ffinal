import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/ui/screens/home_screen.dart';

import 'legal_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
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
            padding: const EdgeInsets.all(18.0),
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
                FittedBox(
                  child: Text(
                    '${AppLocalizations.of(context)!.signup}/ ${AppLocalizations.of(context)!.login}',
                    style: Get.textTheme.titleLarge,
                  ),
                ),
                const Spacer(),
                // create a container sign up with google
                const SizedBox(height: 15),
                Obx(
                  () {
                    if (controller.status.isLoading) {
                      return const CircularProgressIndicator();
                    } else {
                      return SocialButton(
                        image: 'google_icon.png',
                        title: AppLocalizations.of(context)!.signupgoogle,
                        bgColor: Colors.white,
                        color: const Color.fromRGBO(0, 0, 0, 0.54),
                        onClick: () async {
                          final res = await controller.loginViaGoogle();
                          if (res) {
                            Get.offAll(() => const HomeScreen());
                          }
                        },
                      );
                    }
                  },
                ),

                const SizedBox(height: 30),
                Platform.isIOS
                    ? SocialButton(
                        image: 'apple_icon.png',
                        title: AppLocalizations.of(context)!.signupapple,
                        bgColor: Colors.black,
                        color: Colors.white,
                        onClick: () {},
                      )
                    : const SizedBox(),
                const Spacer(),
                const Spacer(),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "${AppLocalizations.of(context)!.by_continuing}\n ",
                      children: [
                        TextSpan(
                            text:
                                AppLocalizations.of(context)!.terms_of_service,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.bottomSheet(BottomSheet(
                                    onClosing: () {},
                                    builder: (builder) => LegalViewScreen(
                                          title: AppLocalizations.of(context)!
                                              .terms_of_service,
                                          slug: 'terms',
                                          hideDeleteButton: true,
                                        )));
                              },
                            style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500)),
                        TextSpan(
                            text: AppLocalizations.of(context)!.and,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.bottomSheet(BottomSheet(
                                    onClosing: () {},
                                    builder: (builder) => LegalViewScreen(
                                          title:
                                              '${AppLocalizations.of(context)!.privacy_policy} ',
                                          slug: 'privacy',
                                          hideDeleteButton: true,
                                        )));
                              },
                            style: const TextStyle()),
                        TextSpan(
                            text:
                                " ${AppLocalizations.of(context)!.privacy_policy}",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.bottomSheet(BottomSheet(
                                    onClosing: () {},
                                    builder: (builder) => LegalViewScreen(
                                          title: AppLocalizations.of(context)!
                                              .privacy_policy,
                                          slug: 'privacy',
                                          hideDeleteButton: true,
                                        )));
                              },
                            style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500))
                      ],
                      style:
                          const TextStyle(color: Colors.black, fontSize: 13)),
                ),
                const SizedBox(height: 14),
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
