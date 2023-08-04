import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/home_screen.dart';
import 'package:gully_app/src/ui/widgets/custom_text_field.dart';
import 'package:gully_app/src/ui/widgets/primary_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  bool isSelected = false;
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
                // Color(0xffEEEFF5),
                Colors.white12,
                Colors.white54,
              ],
              stops: [0.1, 0.9, 1],
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
                    Text(
                      'Create\nProfile'.toUpperCase(),
                      style: Get.textTheme.titleLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          fontFamily: 'Gothams',
                          fontSize: 45,
                          height: 0.8,
                          fontWeight: FontWeight.w900),
                    ),
                    const Spacer(),
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 40,
                    ),
                    const Spacer(),
                    // create a container sign up with google
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const CustomTextField(
                          labelText: 'Name',
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        const CustomTextField(
                          labelText: 'Contact No',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 24,
                              child: Checkbox(
                                splashRadius: 0,
                                value: isSelected,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                side: const BorderSide(
                                    color: Color(0xff676677),
                                    width: 1,
                                    style: BorderStyle.solid),
                                onChanged: (e) {
                                  setState(() {
                                    isSelected = e as bool;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "I've read your Terms and Conditions.",
                              style: Get.textTheme.labelSmall,
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        PrimaryButton(onTap: () {
                          Get.bottomSheet(
                              BottomSheet(
                                  onClosing: () {
                                    log('Wants to close');
                                  },
                                  animationController: animationController,
                                  enableDrag: true,
                                  builder: (context) =>
                                      const _OtpBottomSheet()),
                              enableDrag: true,
                              isScrollControlled: false,
                              isDismissible: true,
                              enterBottomSheetDuration:
                                  const Duration(milliseconds: 300),
                              exitBottomSheetDuration:
                                  const Duration(milliseconds: 300));
                        }),
                      ],
                    ),
                    const Spacer(),
                    const Spacer(),
                  ]),
            ),
          ),
        ));
  }
}

class _OtpBottomSheet extends StatefulWidget {
  const _OtpBottomSheet();

  @override
  State<_OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<_OtpBottomSheet> {
  var textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Get.height / .7,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 7,
                width: 120,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: const Color(0xffE9E7EF),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Column(
                    children: [
                      const Text(
                          'Enter 5 digit code sent to your mobile number'),
                      const SizedBox(height: 20),
                      PinCodeTextField(
                        length: 5,
                        appContext: context,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          activeColor: Colors.white,
                          selectedColor: Colors.white,
                          selectedFillColor: Colors.white,
                          inactiveColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 60,
                          fieldWidth: 50,
                          borderWidth: 0,
                          selectedBorderWidth: 0,
                          activeFillColor: Colors.white,
                        ),
                        animationDuration: const Duration(milliseconds: 300),

                        enableActiveFill: true,
                        // errorAnimationController: errorController,
                        controller: textEditingController,
                        onCompleted: (v) {},
                        onChanged: (value) {
                          // setState(() {
                          //   currentText = value;
                          // });
                        },
                        beforeTextPaste: (text) {
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          'Resend',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Resend code in 00:21',
                        style: Get.textTheme.labelSmall,
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: Get.width / 2,
              child: PrimaryButton(
                onTap: () {
                  Get.to(() => const HomeScreen());
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
