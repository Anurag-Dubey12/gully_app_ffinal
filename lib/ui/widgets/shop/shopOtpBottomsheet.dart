import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gully_app/config/app_constants.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpBottomSheet extends StatefulWidget {
  const OtpBottomSheet({super.key});

  @override
  State<OtpBottomSheet> createState() => OtpBottomSheetState();
}

class OtpBottomSheetState extends State<OtpBottomSheet> {
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
    // reset controller
    textEditingController.clear();

    countDown = 60;
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
                      Text(AppConstants.please_enter_5_digit_code,
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
                        // allow user to edit the specific field

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
                                controller.sendOTP();
                                startTimer();
                              },
                              child: const Text(
                                AppConstants.resend,
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : Text(
                              'Resend code in 00:$countDown',
                              style: Get.textTheme.labelSmall,
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Text('Change Number',
                            style: Get.textTheme.labelSmall?.copyWith(
                              color: Colors.blue,
                            )),
                      ),
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
                    title: AppConstants.verify,
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

    }
  }
}
