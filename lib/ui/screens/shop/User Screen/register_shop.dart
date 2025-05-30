import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gully_app/config/app_constants.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/controller/shop_controller.dart';
import 'package:gully_app/data/model/business_hours_model.dart';
import 'package:gully_app/ui/screens/create_profile_screen.dart';
import 'package:gully_app/ui/screens/select_location.dart';
import 'package:gully_app/ui/screens/shop/Shop%20owner%20Screen/product_adding_screen.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/ui/widgets/shop/aadhar_card_upload.dart';
import 'package:gully_app/ui/widgets/shop/shopOtpBottomsheet.dart';
import 'package:gully_app/utils/geo_locator_helper.dart';
import 'package:gully_app/utils/image_picker_helper.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../data/model/shop_model.dart';
import '../../../theme/theme.dart';
import '../../../widgets/create_tournament/form_input.dart';
import '../../../widgets/shop/business_hours.dart';

class RegisterShop extends StatefulWidget {
  final ShopModel? shop;
  const RegisterShop({Key? key, this.shop}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShopState();
}

class _ShopState extends State<RegisterShop>
    with SingleTickerProviderStateMixin {
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController ownerEmailController = TextEditingController();
  final TextEditingController ownerPhoneController = TextEditingController();
  final TextEditingController ownerAddressController = TextEditingController();
  final TextEditingController ownerPanCardController = TextEditingController();

  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController shopAddressController = TextEditingController();
  final TextEditingController shoplocationController = TextEditingController();
  final TextEditingController shopPhoneController = TextEditingController();
  final TextEditingController shopEmailController = TextEditingController();
  final TextEditingController gstNumberController = TextEditingController();
  final TextEditingController businessLicenseController =
      TextEditingController();
  final TextEditingController shopWebsiteController = TextEditingController();
  final TextEditingController shopDescriptionController =
      TextEditingController();
  TextEditingController otpController = TextEditingController();

  //Focus Node
  final FocusNode ownerNameFocus = FocusNode();
  final FocusNode ownerEmailFocus = FocusNode();
  final FocusNode ownerPhoneFocus = FocusNode();
  final FocusNode ownerAddressFocus = FocusNode();
  final FocusNode ownerPanCardFocus = FocusNode();

  final FocusNode shopNameFocus = FocusNode();
  final FocusNode shopAddressFocus = FocusNode();
  final FocusNode shopLocationFocus = FocusNode();
  final FocusNode shopPhoneFocus = FocusNode();
  final FocusNode shopEmailFocus = FocusNode();
  final FocusNode gstNumberFocus = FocusNode();
  final FocusNode businessLicenseFocus = FocusNode();
  final FocusNode shopWebsiteFocus = FocusNode();
  final FocusNode shopDescriptionFocus = FocusNode();

  XFile? _documentImage;

  Timer? timer;
  int countDown = 20;
  String originalPhoneNumber = '';
  bool tncAccepted = false;
  XFile? gstCertificateImage;
  XFile? shopLocation;
  XFile? businessLicense;
  XFile? taxCertificate;
  XFile? rstCertificate;
  List<dynamic> shopimages = [];
  List<dynamic> editShopImage = [];
  List<XFile>? base64shopimages;
  int currentStep = 0;
  final ScrollController _controller = ScrollController();
  final controller = Get.find<ShopController>();
  Map<String, String> aadhaarData = {};

  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  String? frontImagePath;
  String? backImagePath;
  XFile? frontImageXFile;
  XFile? backImageXFile;

  final List<String> _stepTitles = [
    'Owner Details',
    'Shop Details',
    'Additional Shop Details'
  ];
  List<String> documentImage = [];
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  void _updateAadharImages(Map<String, String> data) {
    setState(() {
      documentImage.clear();
      frontImagePath = data["frontImage"];
      backImagePath = data["backImage"];

      if (frontImagePath != null) {
        frontImageXFile = XFile(frontImagePath!);
        _documentImage = frontImageXFile;
      }

      if (backImagePath != null) {
        backImageXFile = XFile(backImagePath!);
      }
      aadhaarData = data;
    });
  }

  Map<String, BusinessHoursModel> businesshours = {};
  Map<String, String> existingImage = {};

  late LatLng location;
  @override
  void initState() {
    super.initState();
    if (widget.shop != null) {
      ownerNameController.text = widget.shop!.ownerName;
      ownerEmailController.text = widget.shop!.ownerEmail;
      ownerPhoneController.text = widget.shop!.ownerPhoneNumber;
      ownerAddressController.text = widget.shop!.ownerAddress;
      ownerPanCardController.text = widget.shop!.ownerPanNumber;
      shopNameController.text = widget.shop!.shopName;
      shopPhoneController.text = widget.shop!.shopContact;
      shopEmailController.text = widget.shop!.shopEmail;
      shopAddressController.text = widget.shop!.shopAddress;
      shoplocationController.text =
          widget.shop!.locationHistory.point.selectLocation;
      shopDescriptionController.text = widget.shop!.shopDescription;
      shopWebsiteController.text = widget.shop!.shoplink ?? '';
      businesshours = widget.shop!.shopTiming;
      gstNumberController.text = widget.shop?.gstNumber ?? '';
      businessLicenseController.text = widget.shop?.businesslicenseNumber ?? '';
      // shopimages = widget.shop!.shopImage;
      if (widget.shop!.shopImage != null) {
        shopimages = List.from(widget.shop!.shopImage);
      }
    }
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _progressAnimation =
        Tween<double>(begin: 0, end: 0).animate(_progressController);
    fetchLocation();
    startTimer();
  }

  fetchLocation() async {
    final postion = await determinePosition();
    location = LatLng(postion.latitude, postion.longitude);
    setState(() {});
  }

  void _updateProgress() {
    setState(() {
      double endValue = currentStep / (_formKeys.length - 1);
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: endValue,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ));
      _progressController.forward(from: 0);
    });
  }

  void _nextPage() {
    if (_formKeys[currentStep].currentState!.validate()) {
      _formKeys[currentStep].currentState!.save();

      if (currentStep == 0 && aadhaarData.isEmpty && widget.shop == null) {
        errorSnackBar("Aadhar Card document required.");
        return;
      }
      // if (currentStep == 0 &&
      //     !controller.isOtpVerified.value &&
      //     widget.shop == null) {
      //   errorSnackBar(
      //       "Please verify the owner's phone number before proceeding.");

      //   return;
      // }

      if (currentStep == 1 && shopimages == null && widget.shop == null) {
        errorSnackBar("Please Add An Shop Images");
        return;
      }

      if (currentStep < _formKeys.length - 1) {
        setState(() {
          currentStep++;
        });
        _updateProgress();
      }
    }
  }

  void _previousPage() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
    _updateProgress();
  }

  void _submitForm() async {
    if (_formKeys[currentStep].currentState!.validate()) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const UploadingDialog(
              title: "Uploading Shop Data",
              description: "Please wait while we upload your shop details."),
        );
        List<String> shopBase64Images = [];

        for (dynamic image in shopimages) {
          if (image is XFile) {
            String base64Image = await convertImageToBase64(image);
            shopBase64Images.add(base64Image);
          } else if (image is String) {
            shopBase64Images.add(image);
          }
        }
        // if (base64shopimages != null && base64shopimages!.isNotEmpty) {
        //   for (XFile image in base64shopimages!) {
        //     String convertedImage = await convertImageToBase64(image);
        //     shopBase64Images.add(convertedImage);
        //   }
        // }

        String? frontImagebase64;
        String? backImagebase64;
        if (frontImagePath != null &&
            backImagePath != null &&
            widget.shop == null) {
          frontImagebase64 = await convertImageToBase64(frontImageXFile!);
          backImagebase64 = await convertImageToBase64(backImageXFile!);
        }
        final Map<String, dynamic> shopTiming = businesshours.map((day, model) {
          return MapEntry(day, {
            "isOpen": model.isOpen,
            "openTime": model.isOpen ? model.openTime : "Closed on These Day",
            "closeTime": model.isOpen ? model.closeTime : "Closed on These Day",
          });
        });

        final Map<String, dynamic> shopData = {
          if (widget.shop != null) "shopId": widget.shop?.id,
          "shopImage": shopBase64Images,
          "shopName": shopNameController.text,
          "shopAddress": shopAddressController.text,
          "shopDescription": shopDescriptionController.text,
          "shopContact": shopPhoneController.text,
          "shopEmail": shopEmailController.text,
          "shoplink": shopWebsiteController.text,
          if (widget.shop == null) "joinedAt": DateTime.now().toIso8601String(),
          "GstNumber": gstNumberController.text,
          "LicenseNumber": businessLicenseController.text,
          "selectLocation": shoplocationController.text,
          "latitude": location.latitude,
          "longitude": location.longitude,
          "shopTiming": shopTiming,
          "ownerName": ownerNameController.text,
          "ownerEmail": ownerEmailController.text,
          "ownerPhoneNumber": ownerPhoneController.text,
          "ownerAddress": ownerAddressController.text,
          if (widget.shop == null)
            "ownerPanNumber": ownerPanCardController.text,
          if (widget.shop == null) "aadharFrontSide": frontImagebase64,
          if (widget.shop == null) "aadharBackSide": backImagebase64,
        };
        try {
          if (widget.shop != null) {
            bool isOk = await controller.editShop(shopData);
            if (isOk) {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
              successSnackBar(
                      "Your shop details have been successfully updated.")
                  .then((value) => Get.back());

              controller.getMyShop();
            }
          } else {
            bool isOk = await controller.registerShop(shopData);
            if (isOk) {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
              successSnackBar(
                      "Thank you! Your shop registration is now complete.")
                  .then((value) => Get.back());
              controller.getMyShop();
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
        errorSnackBar("An error occurred while submitting the form.",
            title: "Error");
        //logger.d("Error submitting form: $e");
      }
    }
  }

  void pickImage(ImageType imageType) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final File file = File(image.path);
        int fileSizeInBytes = await file.length();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB > 2) {
          errorSnackBar('File size should be less than 2MB.',
              title: "File too large!");
          return;
        }

        final String extension = image.path.split('.').last.toLowerCase();
        if (extension != 'jpg' && extension != 'png' && extension != 'jpeg') {
          _clearImage(imageType);
          errorSnackBar('Please select a PNG or JPG image.',
              title: "Invalid file format!");
          return;
        }

        setState(() {
          switch (imageType) {
            case ImageType.gstCertificateImage:
              gstCertificateImage = image;
              break;
            case ImageType.idProof:
              _documentImage = image;
              break;
            case ImageType.registrationCertificate:
              rstCertificate = image;
              break;
            case ImageType.shopLocation:
              shopLocation = image;
              break;
            case ImageType.businessLicense:
              businessLicense = image;
              break;
            case ImageType.taxCertificate:
              taxCertificate = image;
              break;
          }
        });
      }
    } catch (e) {
      //logger.d'Error picking image: $e');
      errorSnackBar('An error occurred while picking the image.',
          title: "Error");
    }
  }

  void _clearImage(ImageType imageType) {
    setState(() {
      switch (imageType) {
        case ImageType.gstCertificateImage:
          gstCertificateImage = null;
          break;
        case ImageType.idProof:
          _documentImage = null;
          break;
        case ImageType.registrationCertificate:
          rstCertificate = null;
          break;
        case ImageType.shopLocation:
          shopLocation = null;
          break;
        case ImageType.businessLicense:
          businessLicense = null;
          break;
        case ImageType.taxCertificate:
          taxCertificate = null;
          break;
      }
    });
  }

  void startTimer() {
    countDown = 60;
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (countDown == 0) {
          timer.cancel();
          // setState(() {
          //   isOtpSent = false;
          // });
        } else {
          setState(() {
            countDown--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    ownerNameFocus.dispose();
    ownerEmailFocus.dispose();
    ownerPhoneFocus.dispose();
    ownerAddressFocus.dispose();
    ownerPanCardFocus.dispose();

    shopNameFocus.dispose();
    shopAddressFocus.dispose();
    shopLocationFocus.dispose();
    shopPhoneFocus.dispose();
    shopEmailFocus.dispose();
    gstNumberFocus.dispose();
    businessLicenseFocus.dispose();
    shopWebsiteFocus.dispose();
    shopDescriptionFocus.dispose();
    timer?.cancel();
    controller.isOtpSent.value = false;
    controller.isOtpVerified.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/sports_icon.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: GradientBuilder(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Register Shop',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
            width: Get.width,
            child: currentStep == 0
                ? nextNavigationButton('Next', _nextPage)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (currentStep > 0)
                        previousNavigationButton(_previousPage)
                      else
                        const SizedBox(width: 80),
                      if (currentStep < _formKeys.length - 1)
                        nextNavigationButton('Next', _nextPage)
                      else if (currentStep == _formKeys.length - 1)
                        nextNavigationButton('Submit', _submitForm)
                      else
                        const SizedBox(width: 80),
                    ],
                  ),
          ),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      _stepTitles[currentStep],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, top: 10, right: 20),
                    child: AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return Text(
                          "${currentStep + 1}/${_stepTitles.length}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _progressAnimation.value,
                      borderRadius: BorderRadius.circular(20),
                      backgroundColor: Colors.white,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryColor),
                      minHeight: 12,
                    );
                  },
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Text(
              //     _stepTitles[currentStep],
              //     style: const TextStyle(color: Colors.white, fontSize: 20),
              //   ),
              // ),
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _controller,
                  thickness: 4,
                  child: SingleChildScrollView(
                    controller: _controller,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: currentStepBuild(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget currentStepBuild() {
    switch (currentStep) {
      case 0:
        return firstStep();
      case 1:
        return secondStep();
      case 2:
        return thirdStep();
      default:
        return firstStep();
    }
  }

  Widget firstStep() {
    final bool hasAadhaarImages =
        frontImagePath != null && backImagePath != null;
    return Form(
      key: _formKeys[0],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormInput(
            controller: ownerNameController,
            label: AppConstants.ownerName,
            focusNode: ownerNameFocus,
            enabled: true,
            textInputType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return "Enter Owner Name";
              }
              return null;
            },
          ),
          FormInput(
            controller: ownerEmailController,
            enabled: true,
            focusNode: ownerEmailFocus,
            label: AppConstants.owneremail,
            textInputType: TextInputType.emailAddress,
            validator: (value) {
              return validateEmail(value ?? '');
            },
          ),
          FormInput(
            controller: ownerPhoneController,
            enabled: !controller.isOtpVerified.value,
            focusNode: ownerPhoneFocus,
            label: AppConstants.ownerPhone,
            textInputType: TextInputType.number,
            maxLength: 10,
            validator: (value) {
              if (value!.isEmpty) {
                return "Enter Owner Phone Number";
              }
              if (value.length < 10) {
                return "Please Enter a Valid Shop Phone Number";
              }

              if (RegExp(r'^(\d)\1{9}$').hasMatch(value)) {
                return "Phone number cannot be all the same digit";
              }

              if (RegExp(r'(\d)\1{4,}').hasMatch(value)) {
                return "Phone number has too many repeated digits";
              }

              const ascending = '0123456789';
              const descending = '9876543210';
              if (ascending.contains(value) || descending.contains(value)) {
                return "Phone number cannot be a simple sequence";
              }

              return null;
            },
          ),
          // if (widget.shop == null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Obx(
                      () => FormInput(
                        controller: otpController,
                        enabled: controller.isOtpSent.value &&
                            !controller.isOtpVerified.value,
                        label: "Verify OTP",
                        textInputType: TextInputType.number,
                        maxLength: 5,
                        suffixIcon: controller.isOtpVerified.value
                            ? const Icon(Icons.verified_rounded,
                                color: Colors.green)
                            : null,
                        // validator: (value) {
                        //   if (value!.isEmpty) return "Enter OTP";
                        //   if (value.length < 4) return "OTP too short";
                        //   return null;
                        // },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (!controller.isOtpVerified.value)
                    Obx(() {
                      if (controller.isOtpVerified.value) {
                        return const SizedBox();
                      }
                      return Container(
                        width: 130,
                        padding: const EdgeInsets.only(bottom: 10),
                        child: PrimaryButton(
                          title: controller.isOtpSent.value
                              ? "Verify OTP"
                              : "Send OTP",
                          isLoading: controller.isOtpInProgress.value,
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            final phone = ownerPhoneController.text.trim();
                            if (!controller.isOtpSent.value) {
                              if (phone.length == 10) {
                                bool isSent = await controller.sendOTP(phone);
                                if (isSent) {
                                  controller.isOtpSent.value = true;
                                  originalPhoneNumber = phone;
                                  startTimer();
                                }
                              } else {
                                errorSnackBar(
                                    "Please enter a valid phone number");
                              }
                            } else {
                              final otp = otpController.text.trim();
                              if (otp.length == 5) {
                                bool isVerified =
                                    await controller.verifyOtp(otp: otp);
                                if (isVerified) {
                                  successSnackBar("OTP verified successfully");
                                  controller.isOtpVerified.value = true;
                                }
                              } else {
                                errorSnackBar("Please enter a 5-digit OTP");
                              }
                            }
                          },
                        ),
                      );
                    }),
                ],
              ),
              Obx(
                () => controller.isOtpVerified.value
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.info_outline,
                                          size: 48, color: Colors.blueAccent),
                                      const SizedBox(height: 12),
                                      Text(
                                        "Change Phone Number?",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "Changing the number will require re-verification via OTP. Do you want to proceed?",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          height: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.grey[700],
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("Cancel"),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton.icon(
                                            icon: const Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.white,
                                            ),
                                            label: const Text("Yes, Change"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.blueAccent,
                                              foregroundColor: Colors.white,
                                              elevation: 2,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              controller.isOtpVerified.value =
                                                  false;
                                              controller.isOtpSent.value =
                                                  false;
                                              otpController.clear();
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Change Number",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
              Obx(
                () => controller.isOtpSent.value &&
                        !controller.isOtpVerified.value
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: GestureDetector(
                          onTap: countDown == 0
                              ? () async {
                                  final phone =
                                      ownerPhoneController.text.trim();
                                  if (phone.length == 10) {
                                    bool isSent =
                                        await controller.sendOTP(phone);
                                    if (isSent) {
                                      startTimer();
                                      controller.isOtpSent.value = true;
                                      originalPhoneNumber = phone;
                                    }
                                  } else {
                                    errorSnackBar(
                                        "Please enter a valid phone number");
                                  }
                                }
                              : null,
                          child: Text(
                            countDown == 0
                                ? "Resend Code"
                                : "Resend code in 00:${countDown.toString().padLeft(2, '0')}",
                            style: TextStyle(
                              color: countDown == 0 ? Colors.blue : Colors.grey,
                              fontWeight: FontWeight.bold,
                              decoration: countDown == 0
                                  ? TextDecoration.underline
                                  : null,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
          FormInput(
            controller: ownerAddressController,
            label: AppConstants.ownerAddress,
            focusNode: ownerAddressFocus,
            textInputType: TextInputType.multiline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Address cannot be empty.";
              }
              if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$').hasMatch(value)) {
                return "Address must contain at least one letter and one number.";
              }
              if (value.length < 10) {
                return "Address must be at least 10 characters long.";
              }
              return null;
            },
          ),
          Text(
            AppConstants.ownerAddharCard,
            style: Get.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                if (widget.shop == null) {
                  Get.bottomSheet(
                    BottomSheet(
                      onClosing: () {},
                      builder: (_) => SizedBox(
                        height: Get.height * 0.5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: AadharCardUpload(
                            initialFrontImagePath: frontImagePath,
                            initialBackImagePath: backImagePath,
                            onSubmit: (data) {
                              setState(() => _updateAadharImages(data));
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                    isDismissible: true,
                    enableDrag: true,
                  );
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.verified_user,
                            color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          "Aadhaar Details",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        if (widget.shop == null)
                          Icon(
                            aadhaarData.isNotEmpty
                                ? Icons.check_circle
                                : Icons.arrow_forward_ios,
                            color: aadhaarData.isNotEmpty
                                ? Colors.green
                                : Colors.black,
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    if (widget.shop == null)
                      Text(
                        aadhaarData.isNotEmpty
                            ? AppConstants.aadharCardAdded
                            : AppConstants.tapToEdit,
                        style: TextStyle(
                          color: aadhaarData.isNotEmpty
                              ? Colors.green
                              : Colors.grey[600],
                        ),
                      ),
                    if (widget.shop != null)
                      Text(
                        AppConstants.tapToView,
                        style: TextStyle(
                          color: aadhaarData.isNotEmpty
                              ? Colors.green
                              : Colors.grey[600],
                        ),
                      ),
                    const SizedBox(height: 16),
                    if (widget.shop == null && hasAadhaarImages)
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Front Side",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12)),
                                const SizedBox(height: 4),
                                Container(
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[200],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(frontImagePath!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Back Side",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12)),
                                const SizedBox(height: 4),
                                Container(
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[200],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(backImagePath!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (widget.shop != null)
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Front Side",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12)),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () => imageViewer(
                                      context,
                                      widget.shop!.ownerAddharImages.single
                                          .aadharFrontSide,
                                      true),
                                  child: Container(
                                    height: 180,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey[200],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        toImageUrl(widget
                                            .shop!
                                            .ownerAddharImages
                                            .single
                                            .aadharFrontSide),
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }

                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              width: double.infinity,
                                              height: 200,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Back Side",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12)),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () => imageViewer(
                                      context,
                                      widget.shop!.ownerAddharImages.single
                                          .aadharBackSide,
                                      true),
                                  child: Container(
                                    height: 180,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey[200],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        toImageUrl(widget
                                            .shop!
                                            .ownerAddharImages
                                            .first
                                            .aadharBackSide),
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }

                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              width: double.infinity,
                                              height: 200,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FormInput(
            controller: ownerPanCardController,
            label: AppConstants.ownerPanCard,
            textInputType: TextInputType.text,
            isUpperCase: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "PAN card number cannot be empty.";
              }
              if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(value)) {
                return "Please enter a valid PAN card number.";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  //#TODO need to add Validation
  Widget secondStep() {
    return Form(
      key: _formKeys[1],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Shop Images (max 3)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          shopimages.isEmpty
              ? SizedBox(
                  height: 200,
                  child: GestureDetector(
                    onTap: pickImages,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                        color: Colors.grey[100],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            child: Icon(
                              Icons.add_photo_alternate,
                              color: Colors.black,
                              size: 40,
                            ),
                          ),
                          Text(
                            'Add Shop Images (${shopimages.length}/3)',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 200,
                  padding: const EdgeInsets.all(8.0),
                  child: shopimages.isEmpty
                      ? _buildAddImageButton()
                      : Stack(
                          children: [
                            PageView.builder(
                              controller:
                                  PageController(viewportFraction: 0.85),
                              itemCount: shopimages.length +
                                  (shopimages.length < 3 ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == shopimages.length) {
                                  return GestureDetector(
                                    onTap: pickImages,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.grey[300]!),
                                        color: Colors.grey[100],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Center(
                                            child: Icon(
                                              Icons.add_photo_alternate,
                                              color: Colors.black,
                                              size: 40,
                                            ),
                                          ),
                                          Text(
                                            'Add Shop Images (${shopimages.length}/3)',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                final image = shopimages[index];
                                final isNetworkImage = image is String;
                                return Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (isNetworkImage) {
                                          imageViewer(context, image, true);
                                        } else {
                                          imageViewer(context,
                                              (image as XFile).path, false);
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          image: DecorationImage(
                                            image: isNetworkImage
                                                ? NetworkImage(
                                                        toImageUrl(image))
                                                    as ImageProvider
                                                : FileImage(File(
                                                    (image as XFile).path)),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 15,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            shopimages.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                ),
          FormInput(
            controller: shopNameController,
            label: "Shop Name",
            textInputType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return "Enter Shop Name";
              }
              return null;
            },
          ),
          FormInput(
            controller: shopPhoneController,
            label: "Shop Phone Number",
            textInputType: TextInputType.number,
            maxLength: 10,
            validator: (value) {
              if (value!.isEmpty) {
                return "Enter Shop Number";
              }
              if (value.length < 10) {
                return "Please Enter a Valid Shop Phone Number";
              }
              if (!RegExp(r'^\d+$').hasMatch(value)) {
                return "Phone number must contain digits only";
              }
              if (RegExp(r'^(\d)\1{9}$').hasMatch(value)) {
                return "Phone number cannot be all the same digit";
              }

              if (RegExp(r'(\d)\1{4,}').hasMatch(value)) {
                return "Phone number has too many repeated digits";
              }

              const ascending = '0123456789';
              const descending = '9876543210';
              if (ascending.contains(value) || descending.contains(value)) {
                return "Phone number cannot be a simple sequence";
              }

              return null;
            },
          ),
          FormInput(
            controller: shopEmailController,
            label: "Shop Email Address",
            textInputType: TextInputType.emailAddress,
            validator: (value) {
              return validateEmail(value ?? '');
            },
          ),
          FormInput(
            controller: gstNumberController,
            label: "Shop GST Number",
            textInputType: TextInputType.text,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Enter GST Number";
              }
              if (value.isNotEmpty) {
                if (!RegExp(
                        r"^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$")
                    .hasMatch(value)) {
                  return "Invalid GST Number";
                }
                return null;
              }
              return null;
            },
          ),
          FormInput(
            controller: businessLicenseController,
            label: "Business License Number",
            textInputType: TextInputType.text,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Enter Business License Number";
              }
              if (value.isNotEmpty) {
                if (!RegExp(r"^[a-zA-Z0-9]{5,15}$").hasMatch(value)) {
                  return "Invalid Business License Number";
                }
                return null;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  pickImages() async {
    final imgs = await multipleimagePickerHelper();

    if (imgs != null && imgs.isNotEmpty) {
      final remainingSlots = 3 - shopimages.length;

      if (remainingSlots <= 0) {
        errorSnackBar("You can upload a maximum of 3 images.");
        return;
      }

      final limitedImgs = imgs.take(remainingSlots).toList();

      // if (imgs.length > remainingSlots) {
      //   errorSnackBar(
      //       "Only ${remainingSlots} more image(s) can be uploaded. Extra images were ignored.");
      // }

      setState(() {
        shopimages.addAll(limitedImgs);
      });
    }
  }

  Widget thirdStep() {
    return Form(
        key: _formKeys[2],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            FormInput(
              controller: shopAddressController,
              label: "Shop Address",
              textInputType: TextInputType.multiline,
              autofocus: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Address cannot be empty.";
                }
                RegExp addressRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$');
                if (!addressRegExp.hasMatch(value)) {
                  return "Address must contain at least one letter \nand one number.";
                }

                if (value.length < 10) {
                  return "Address must be at least 10 characters long.";
                }

                return null;
              },
            ),
            FormInput(
              controller: shoplocationController,
              label: 'Select Nearby Location',
              readOnly: true,
              isinfo: true,
              infotitle: AppConstants.shoplocInfo,
              infotext: AppConstants.shopinfotext,
              onTap: () async {
                Get.to(
                  () => SelectLocationScreen(
                    onSelected: (e, l) {
                      setState(() {
                        shoplocationController.text = e;
                      });
                      if (l != null) {
                        setState(() {
                          location = l;
                        });
                      }
                      FocusScope.of(context).unfocus();
                    },
                    initialLocation:
                        LatLng(location.latitude, location.longitude),
                  ),
                );
              },
            ),
            FormInput(
              controller: shopDescriptionController,
              label: "Shop Description",
              textInputType: TextInputType.multiline,
            ),
            Text(
              "Shop Working Hours",
              style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(_getBusinessHoursSummary()),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  final result = await showModalBottomSheet<
                      Map<String, BusinessHoursModel>>(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return SizedBox(
                          height: Get.height * 0.8,
                          child:
                              BusinessHoursScreen(initialHours: businesshours));
                    },
                  );

                  if (result != null) {
                    setState(() {
                      businesshours = result;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            FormInput(
              controller: shopWebsiteController,
              label: "Shop Website Url (Optional)",
              textInputType: TextInputType.url,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (kDebugMode) {
                    print('');
                  }
                  if (!RegExp(
                          r"^(http|https):\/\/[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z]{2,6}(:[0-9]{1,5})?(\/.*)?$")
                      .hasMatch(value)) {
                    return "Invalid Website URL";
                  }
                }
                return null;
              },
            ),
          ],
        ));
  }

  Widget _buildAddImageButton() {
    return InkWell(
      onTap: pickImages,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_a_photo,
              color: Colors.black,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              'Add Shop Images (${shopimages.length}/3)',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getBusinessHoursSummary() {
    if (businesshours.isEmpty) {
      return "Set shop hours";
    }

    final openDays = businesshours.entries
        .where((entry) => entry.value.isOpen)
        .map((entry) => entry.key)
        .toList();

    if (openDays.isEmpty) {
      return "Closed all days";
    }

    if (openDays.length == 7) {
      final firstDay = businesshours[openDays.first]!;
      bool allSameHours = true;

      for (var day in openDays.skip(1)) {
        final currentDay = businesshours[day]!;
        if (currentDay.openTime != firstDay.openTime ||
            currentDay.closeTime != firstDay.closeTime) {
          allSameHours = false;
          break;
        }
      }

      if (allSameHours) {
        return "Open daily ${firstDay.openTime} - ${firstDay.closeTime}";
      }

      return "Open every day with different Working hours";
    }
    // final weekdaysList = [
    //   'Monday',
    //   'Tuesday',
    //   'Wednesday',
    //   'Thursday',
    //   'Friday'
    // ];
    // final weekendsList = ['Saturday', 'Sunday'];

    // bool allWeekdaysOpen =
    //     weekdaysList.every((day) => businesshours[day]?.isOpen == true);
    // bool allWeekendsOpen =
    //     weekendsList.every((day) => businesshours[day]?.isOpen == true);

    // if (allWeekdaysOpen && !allWeekendsOpen) {
    //   return "Open weekdays only";
    // }

    // if (!allWeekdaysOpen && allWeekendsOpen) {
    //   return "Open weekends only";
    // }
    return "Open ${openDays.join(', ')}";
  }
}

enum ImageType {
  gstCertificateImage,
  registrationCertificate,
  shopLocation,
  businessLicense,
  taxCertificate,
  idProof
}

enum AadhaarSide { front, back }
