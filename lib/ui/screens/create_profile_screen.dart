import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/ui/screens/choose_lang_screen.dart';
import 'package:gully_app/ui/widgets/custom_text_field.dart';
import 'package:gully_app/ui/widgets/location_permission_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/utils/geo_locator_helper.dart';
import 'package:gully_app/utils/image_picker_helper.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      determinePosition();
    });
  }

  XFile? _image;

  pickImage() async {
    _image = await imagePickerHelper();
    setState(() {});
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return LocationStreamHandler(
      child: DecoratedBox(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                child: SizedBox(
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: Get.height * 0.13,
                          ),
                          Text(
                            AppLocalizations.of(context)!
                                .create_profile
                                .toUpperCase(),
                            style: Get.textTheme.titleLarge?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                                fontFamily: 'Gothams',
                                fontSize: Get.textScaleFactor * 45,
                                height: 0.8,
                                fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          GestureDetector(
                            onTap: () {
                              pickImage();
                            },
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.white,
                                  foregroundImage: _image == null
                                      ? const AssetImage(
                                          'assets/images/profile.jpeg',
                                        )
                                      : null,
                                  backgroundImage: _image != null
                                      ? FileImage(File(_image!.path))
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade600,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.edit,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: Get.height * 0.03,
                                ),
                                CustomTextField(
                                  labelText: AppLocalizations.of(context)!.name,
                                  controller: _nameController,
                                  validator: (e) {
                                    if (e!.contains(
                                        RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                                      return AppLocalizations.of(context)!
                                          .name_cannot_contain_special_characters;
                                    }
                                    if (e.contains(RegExp(r'[^\x00-\x7F]+'))) {
                                      return AppLocalizations.of(context)!
                                          .name_cannot_contain_emojis;
                                    }

                                    if (e.contains(RegExp(
                                        r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]'))) {
                                      return AppLocalizations.of(context)!
                                          .name_cannot_contain_special_characters_numbers;
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: Get.height * 0.03,
                                ),
                                CustomTextField(
                                  labelText: 'Contact No',
                                  controller: _contactController,
                                  textInputType: TextInputType.phone,
                                  maxLen: 10,
                                  validator: (e) {
                                    if (e!.length != 10) {
                                      return AppLocalizations.of(context)!
                                          .please_enter_valid_phone_number;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 30),
                                Obx(
                                  () => PrimaryButton(
                                      isLoading: controller.status.isLoading,
                                      onTap: () async {
                                        if (_image == null) {
                                          errorSnackBar(
                                              AppLocalizations.of(context)!
                                                  .please_select_an_image);
                                          return;
                                        }
                                        if (_formKey.currentState!.validate()) {
                                          final base64Image =
                                              await convertImageToBase64(
                                                  _image!);
                                          if (!base64Image.contains(RegExp(
                                              r'data:image\/(png|jpeg);base64,'))) {
                                            if (mounted) {
                                              errorSnackBar(AppLocalizations.of(
                                                      // ignore: use_build_context_synchronously
                                                      context)!
                                                  .please_select_a_valid_image);
                                            }
                                            return;
                                          }
                                          final res =
                                              await controller.createProfile(
                                                  nickName:
                                                      _nameController.text,
                                                  phoneNumber:
                                                      _contactController.text,
                                                  base64: base64Image);
                                          if (res) {
                                            Get.bottomSheet(
                                                BottomSheet(
                                                    onClosing: () {
                                                      log('Wants to close');
                                                    },
                                                    animationController:
                                                        animationController,
                                                    enableDrag: true,
                                                    builder: (context) =>
                                                        const _OtpBottomSheet()),
                                                enableDrag: true,
                                                isScrollControlled: false,
                                                isDismissible: true,
                                                enterBottomSheetDuration:
                                                    const Duration(
                                                        milliseconds: 300),
                                                exitBottomSheetDuration:
                                                    const Duration(
                                                        milliseconds: 300));
                                          }
                                        }
                                      }),
                                )
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

class _OtpBottomSheet extends StatefulWidget {
  const _OtpBottomSheet();

  @override
  State<_OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<_OtpBottomSheet> {
  var textEditingController = TextEditingController();
  Timer? timer;
  int countDown = 20;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    countDown = 20;
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (countDown == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            countDown--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
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
                      Text(
                          AppLocalizations.of(context)!
                              .please_enter_5_digit_code,
                          style: Get.textTheme.labelSmall),
                      const SizedBox(height: 20),
                      PinCodeTextField(
                        length: 5,
                        appContext: context,
                        obscureText: false,
                        textInputAction: TextInputAction.go,
                        animationType: AnimationType.fade,
                        autoFocus: true,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          activeFillColor: Colors.white,
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
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        keyboardType: TextInputType.number,
                        enableActiveFill: true,
                        controller: textEditingController,
                        onCompleted: (v) {
                          login(controller);
                        },
                        onChanged: (value) {},
                        beforeTextPaste: (text) {
                          return true;
                        },
                      ),
                      countDown == 0
                          ? ElevatedButton(
                              onPressed: () {
                                startTimer();
                              },
                              child: Text(
                                AppLocalizations.of(context)!.resend,
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                          : Text(
                              'Resend code in 00:$countDown',
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
                child: Obx(
                  () => PrimaryButton(
                    title: AppLocalizations.of(context)!.verify,
                    isLoading: controller.status.isLoading,
                    onTap: () async {
                      await login(controller);
                    },
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Future<void> login(AuthController controller) async {
    final res = await controller.verifyOtp(otp: textEditingController.text);
    if (res) {
      Get.offAll(() => const ChooseLanguageScreen());
    }
  }
}
