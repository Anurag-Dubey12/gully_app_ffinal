import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/choose_lang_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
                      onClick: () {},
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
  final Function onClick;

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
      onTap: () => Get.to(() => const ChooseLanguageScreen()),
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
              style: Get.textTheme.headlineMedium
                  ?.copyWith(fontStyle: FontStyle.italic, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
