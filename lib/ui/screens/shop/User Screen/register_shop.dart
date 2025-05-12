import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gully_app/config/app_constants.dart';
import 'package:gully_app/data/controller/shop_controller.dart';
import 'package:gully_app/data/model/business_hours_model.dart';
import 'package:gully_app/ui/screens/select_location.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/shop/aadhar_card_upload.dart';
import 'package:gully_app/ui/widgets/shop/shop_imagepicker.dart';
import 'package:gully_app/utils/geo_locator_helper.dart';
import 'package:gully_app/utils/image_picker_helper.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/controller/auth_controller.dart';
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

  XFile? _documentImage;
  bool tncAccepted = false;
  XFile? gstCertificateImage;
  XFile? shopLocation;
  XFile? businessLicense;
  XFile? taxCertificate;
  XFile? rstCertificate;
  XFile? _shopLogo;
  List<String>? shopimages;
  List<XFile>? base64shopimages;
  int currentStep = 0;

  final ScrollController _controller = ScrollController();
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
    'Vendor Details',
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

  late LatLng location;
  
  @override
  void initState() {
    super.initState();
    final AuthController authController = Get.find<AuthController>();
    if (widget.shop != null) {
      ownerAddressController.text = widget.shop!.ownerAddress;
      ownerPanCardController.text = widget.shop!.ownerPanNumber;
      shopNameController.text = widget.shop!.shopName;
      shopPhoneController.text = widget.shop!.shopContact;
      shopEmailController.text = widget.shop!.shopEmail;
      shopAddressController.text = widget.shop!.shopAddress;
      shoplocationController.text =
          widget.shop!.locationHistory.point.selectLocation;
      shopDescriptionController.text = widget.shop!.shopDescription;

      businesshours = widget.shop!.shopTiming;
      shopimages = widget.shop!.shopImage;
    }
    ownerNameController.text = authController.state!.fullName;
    ownerEmailController.text = authController.state!.email;
    ownerPhoneController.text = authController.state!.phoneNumber ?? '';
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _progressAnimation =
        Tween<double>(begin: 0, end: 0).animate(_progressController);

    fetchLocation();
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
        final authController = Get.find<AuthController>();
        final controller = Get.find<ShopController>();
        List<String> shopBase64Images = [];
        
        if (base64shopimages != null) {
          for (XFile image in base64shopimages!) {
            String convertedImage = await convertImageToBase64(image);
            shopBase64Images.add(convertedImage);
          }
        }

        List<OwnerAddharImage>? ownerAadharImages;
        String? frontImagebase64;
        String? backImagebase64;
        if (frontImagePath != null && backImagePath != null) {
          frontImagebase64 = await convertImageToBase64(frontImageXFile!);
          backImagebase64 = await convertImageToBase64(backImageXFile!);
          ownerAadharImages = [
            OwnerAddharImage(
              aadharFrontSide: frontImagebase64,
              aadharBackSide: backImagebase64,
            )
          ];
        }
        final Map<String, dynamic> shopTiming = businesshours.map((day, model) {
          return MapEntry(day, {
            "isOpen": model.isOpen,
            "openTime": model.isOpen ? model.openTime : "Closed on These Day",
            "closeTime": model.isOpen ? model.closeTime : "Closed on These Day",
          });
        });

        final Map<String, dynamic> shopData = {
          "shopImage": shopBase64Images,
          "shopName": shopNameController.text,
          "shopAddress": shopAddressController.text,
          "shopDescription": shopDescriptionController.text,
          "shopContact": shopPhoneController.text,
          "shopEmail": shopEmailController.text,
          "shopLink": shopWebsiteController.text,
          "joinedAt": DateTime.now().toIso8601String(),
          // "gstNumber": gstNumberController.text,
          "selectLocation": shoplocationController.text,
          "latitude": location.latitude,
          "longitude": location.longitude,
          "shopTiming": shopTiming,
          "ownerName": ownerNameController.text,
          "ownerEmail": ownerEmailController.text,
          "ownerPhoneNumber": ownerPhoneController.text,
          "ownerAddress": ownerAddressController.text,
          "ownerPanNumber": ownerPanCardController.text,
          "aadharFrontSide": frontImagebase64,
          "aadharBackSide": backImagebase64,
        };
        try {
          bool isOk = await controller.registerShop(shopData);
          if (isOk) {
            successSnackBar("Shop registration submitted successfully!");
          }
        } catch (e) {
          print(e);
        }
      } catch (e) {
        print(e.toString());
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
            case ImageType.shopLogo:
              _shopLogo = image;
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
        case ImageType.shopLogo:
          _shopLogo = null;
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

  bool _validateImages() {
    bool isValid = true;
    List<String> missingImages = [];

    if (_documentImage == null) {
      missingImages.add("ID Proof");
      isValid = false;
    }
    if (_shopLogo == null) {
      missingImages.add("Shop Logo");
      isValid = false;
    }
    if (shopLocation == null) {
      missingImages.add("Shop Location Proof");
      isValid = false;
    }
    if (businessLicense == null) {
      missingImages.add("Business License");
      isValid = false;
    }

    if (gstNumberController.text.isNotEmpty && gstCertificateImage == null) {
      missingImages.add("GST Certificate");
      isValid = false;
    }
    if (rstCertificate == null) {
      missingImages.add("Shop Registration Certificate");
      isValid = false;
    }
    if (taxCertificate == null) {
      missingImages.add("VAT or Sales Tax Certificate");
      isValid = false;
    }

    if (!isValid) {
      String errorMessage =
          // "Please upload the following images: ${missingImages.join(', ')}";
          "Please Upload All The Required Documents";
      errorSnackBar(errorMessage, title: "Missing Images");
    }

    return isValid;
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
                ? _nextNavigationButton('Next', _nextPage)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (currentStep > 0)
                        _previousNavigationButton(_previousPage)
                      else
                        const SizedBox(width: 80),
                      if (currentStep < _formKeys.length - 1)
                        _nextNavigationButton('Next', _nextPage)
                      else if (currentStep == _formKeys.length - 1)
                        _nextNavigationButton('Submit', _submitForm)
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
            enabled: false,
            textInputType: TextInputType.name,
          ),
          FormInput(
            controller: ownerEmailController,
            enabled: false,
            label: AppConstants.owneremail,
            textInputType: TextInputType.emailAddress,
          ),
          FormInput(
            controller: ownerPhoneController,
            enabled: false,
            label: AppConstants.ownerPhone,
            textInputType: TextInputType.number,
          ),
          FormInput(
            controller: ownerAddressController,
            label: AppConstants.ownerAddress,
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
                if (widget.shop == null) {
                  Get.bottomSheet(
                    BottomSheet(
                      onClosing: () {},
                      builder: (_) => SizedBox(
                        height: Get.height * 0.5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: AadharCardUpload(
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
          ShopImagePicker(
            images: shopimages ?? [],
            onImagesChanged: _handleImageChange,
            onImageSelected: _handleonImageSelected,
            isNetworkFetch: widget.shop != null ? true : false,
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

              if (RegExp(r'^(\d)\1{9}$').hasMatch(value)) {
                return "Phone number cannot be all the same digit";
              }

              if (RegExp(r'(\d)\1{4,}').hasMatch(value)) {
                return "Phone number has too many repeated digits";
              }

              final ascending = '0123456789';
              final descending = '9876543210';
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
            // validator: (value) {
            //   if (value == null || value.trim().isEmpty) {
            //     return "Enter GST Number";
            //   }
            //   if (value.isNotEmpty) {
            //     if (!RegExp(
            //             r"^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$")
            //         .hasMatch(value)) {
            //       return "Invalid GST Number";
            //     }
            //     return null;
            //   }
            //   return null;
            // },
          ),
          FormInput(
            controller: businessLicenseController,
            label: "Business License Number",
            textInputType: TextInputType.text,
            // validator: (value) {
            //   if (value == null || value.trim().isEmpty) {
            //     return "Enter Business License Number";
            //   }
            //   if (value.isNotEmpty) {
            //     if (!RegExp(r"^[a-zA-Z0-9]{5,15}$").hasMatch(value)) {
            //       return "Invalid Business License Number";
            //     }
            //     return null;
            //   }
            //   return null;
            // },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Widget thirdStep() {
  //   return Form(
  //       key: _formKeys[2],
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           ImageUploadWidget(
  //             image: gstCertificateImage,
  //             onTap: () => pickImage(ImageType.gstCertificateImage),
  //             hintText: "Select Documents for Verification\n(JPG, PNG max 2MB)",
  //             title: "Upload GST Certificate",
  //           ),
  //           ImageUploadWidget(
  //             image: rstCertificate,
  //             onTap: () => pickImage(ImageType.registrationCertificate),
  //             hintText: "Select Documents for Verification\n(JPG, PNG max 2MB)",
  //             title: "Upload Shop Registration Certificate",
  //           ),
  //           ImageUploadWidget(
  //             image: _shopLogo,
  //             onTap: () => pickImage(ImageType.shopLogo),
  //             hintText: "Select Documents for Verification\n(JPG, PNG max 2MB)",
  //             title: "Upload Shop Logo/Image",
  //           ),
  //           ImageUploadWidget(
  //             image: shopLocation,
  //             onTap: () => pickImage(ImageType.shopLocation),
  //             hintText: "Select Documents for Verification\n(JPG, PNG max 2MB)",
  //             title:
  //                 "Upload Shop Location Proof (e.g., Utility bill, Rent agreement, etc.)",
  //           ),
  //           ImageUploadWidget(
  //             image: businessLicense,
  //             onTap: () => pickImage(ImageType.businessLicense),
  //             hintText: "Select Documents for Verification\n(JPG, PNG max 2MB)",
  //             title: "Upload Business License",
  //           ),
  //           ImageUploadWidget(
  //             image: taxCertificate,
  //             onTap: () => pickImage(ImageType.taxCertificate),
  //             hintText:
  //                 "Select Documents for Verification\n(JPG, PNG  max 2MB)",
  //             title: "Upload VAT or Sales Tax Certificate (if applicable)",
  //           ),
  //         ],
  //       ));
  // }

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

  void _handleImageChange(List<String> updatedImages) {
    setState(() {
      shopimages = updatedImages;
    });
  }

  void _handleonImageSelected(List<XFile> updatedImages) {
    setState(() {
      base64shopimages = updatedImages;
    });
  }

  Widget _previousNavigationButton(VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(
            color: AppTheme.primaryColor,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
            child:
                Icon(Icons.arrow_back_rounded, color: Colors.black, size: 30)),
      ),
    );
  }

  Widget _nextNavigationButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 250,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppTheme.primaryColor,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
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

      return "Open all days (varied hours)";
    }
    final weekdaysList = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday'
    ];
    final weekendsList = ['Saturday', 'Sunday'];

    bool allWeekdaysOpen =
        weekdaysList.every((day) => businesshours[day]?.isOpen == true);
    bool allWeekendsOpen =
        weekendsList.every((day) => businesshours[day]?.isOpen == true);

    if (allWeekdaysOpen && !allWeekendsOpen) {
      return "Open weekdays only";
    }

    if (!allWeekdaysOpen && allWeekendsOpen) {
      return "Open weekends only";
    }
    return "Open ${openDays.join(', ')}";
  }
}

enum ImageType {
  gstCertificateImage,
  registrationCertificate,
  shopLogo,
  shopLocation,
  businessLicense,
  taxCertificate,
  idProof
}

enum AadhaarSide { front, back }
