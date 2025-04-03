import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/shop_controller.dart';
import 'package:gully_app/ui/screens/shop_payment_screen.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/shop/social_media_link.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/controller/auth_controller.dart';
import '../../../data/model/business_hours_model.dart';
import '../../../data/model/shop_model.dart';
import '../../../data/model/vendor_model.dart';
import '../../../utils/app_logger.dart';
import '../../theme/theme.dart';
import '../../widgets/create_tournament/form_input.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/shop/business_hours.dart';
import '../../widgets/shop/image_upload.dart';

class RegisterShop extends StatefulWidget {
  const RegisterShop({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShopState();
}

class _ShopState extends State<RegisterShop>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _alternateNumberController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  XFile? _documentImage;
  final _key = GlobalKey<FormState>();
  bool tncAccepted = false;
  final TextEditingController _shopnameController = TextEditingController();
  final TextEditingController _shop_address_Controller =
      TextEditingController();
  final TextEditingController _shop_number_Controller = TextEditingController();
  final TextEditingController _shop_email_Controller = TextEditingController();
  final TextEditingController _shop_Gst_Controller = TextEditingController();
  final TextEditingController _shop_website_Controller =
      TextEditingController();
  final TextEditingController _shop_description_Controller =
      TextEditingController();
  XFile? _Gstcertificate;
  XFile? _shop_Location;
  XFile? _Business_license;
  XFile? _tax_certificate;
  XFile? _Rstcertificate;
  XFile? _shopLogo;
  final bool _allImagesSelected = false;
  bool isLoading = false;

  int currentStep = 0;
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  final List<String> _stepTitles = [
    'Vendor Details',
    'Shop Details',
    'Additional Shop Details',
    'Social Media Links'
  ];

  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  List<String> summaries = [];
  Map<String, BusinessHours> _businessHours = {
    'Sunday': BusinessHours(isOpen: false),
    'Monday': BusinessHours(),
    'Tuesday': BusinessHours(),
    'Wednesday': BusinessHours(),
    'Thursday': BusinessHours(),
    'Friday': BusinessHours(),
    'Saturday': BusinessHours(isOpen: false),
  };

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

      if (currentStep == 2 && !_validateImages()) {
        // errorSnackBar("Please Upload All The Required Documents");
        return;
      }
      if (currentStep == 0 && _documentImage == null) {
        errorSnackBar("ID proof document required.");
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
    // if (tncAccepted == false) {
    //   errorSnackBar('Please accept the Terms and Conditions');
    //   return;
    // }
    if (_formKeys[currentStep].currentState!.validate()) {
      try {
        final AuthController authController = Get.find<AuthController>();
        if (_validateImages()) {
          // setState(() {
          //   isLoading = true;
          // });
          final ShopController controller = Get.put(ShopController());
          final shopData = shop_model(
            shopName: _shopnameController.text,
            shopAddress: _shop_address_Controller.text,
            shopNumber: _shop_number_Controller.text,
            shopEmail: _shop_email_Controller.text,
            gstNumber: _shop_Gst_Controller.text,
            gstCertificate: _Gstcertificate?.path,
            registrationCertificate: _Rstcertificate?.path,
            shopLogo: _shopLogo?.path,
            businessHours: _businessHours.map((key, value) => MapEntry(
                key,
                business_hours_model(
                  isOpen: value.isOpen,
                  openTime: value.openTime?.format(context),
                  closeTime: value.closeTime?.format(context),
                  id: null,
                ))),
            websiteUrl: _shop_website_Controller.text,
            description: _shop_description_Controller.text,
            locationProof: _shop_Location?.path,
            businessLicense: _Business_license?.path,
            taxCertificate: _tax_certificate?.path,
            vendor: vendor_model(
              name: _nameController.text,
              email: _emailController.text,
              phoneNumber: _numberController.text,
              alternatePhoneNumber:
                  int.tryParse(_alternateNumberController.text),
              address: _addressController.text,
              id_proof: _documentImage?.path,
              id: '',
            ),
          );
          controller.addShop(shopData);
          //logger.d'The shop data is saved');
          Get.to(() => ShopPaymentPage(
                shopData: shopData,
              ));
        } else {
          setState(() {
            isLoading = false;
          });
        }
        // String? base64;
        // if (_image != null) {
        //   base64 =
        //   await convertImageToBase64(_image!);
        // }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        errorSnackBar("An error occurred while submitting the form.",
            title: "Error");
        //logger.d"Error submitting form: $e");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final AuthController authController = Get.find<AuthController>();
    _nameController.text = authController.state!.fullName;
    _emailController.text = authController.state!.email;
    _numberController.text = authController.state!.phoneNumber ?? '';
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _progressAnimation =
        Tween<double>(begin: 0, end: 0).animate(_progressController);
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
            case ImageType.GST_Certificate:
              _Gstcertificate = image;
              break;
            case ImageType.Id_Proof:
              _documentImage = image;
              break;
            case ImageType.Registration_Certificate:
              _Rstcertificate = image;
              break;
            case ImageType.shop_logo:
              _shopLogo = image;
              break;
            case ImageType.shop_location:
              _shop_Location = image;
              break;
            case ImageType.Business_License:
              _Business_license = image;
              break;
            case ImageType.Tax_Certificate:
              _tax_certificate = image;
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
        case ImageType.GST_Certificate:
          _Gstcertificate = null;
          break;
        case ImageType.Id_Proof:
          _documentImage = null;
          break;
        case ImageType.Registration_Certificate:
          _Rstcertificate = null;
          break;
        case ImageType.shop_logo:
          _shopLogo = null;
          break;
        case ImageType.shop_location:
          _shop_Location = null;
          break;
        case ImageType.Business_License:
          _Business_license = null;
          break;
        case ImageType.Tax_Certificate:
          _tax_certificate = null;
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
    if (_shop_Location == null) {
      missingImages.add("Shop Location Proof");
      isValid = false;
    }
    if (_Business_license == null) {
      missingImages.add("Business License");
      isValid = false;
    }

    if (_shop_Gst_Controller.text.isNotEmpty && _Gstcertificate == null) {
      missingImages.add("GST Certificate");
      isValid = false;
    }
    if (_Rstcertificate == null) {
      missingImages.add("Shop Registration Certificate");
      isValid = false;
    }
    if (_tax_certificate == null) {
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CurrentStepBuild(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget CurrentStepBuild() {
    switch (currentStep) {
      case 0:
        return FirstStep();
      case 1:
        return SecondStep();
      case 2:
        return ThirdStep();
      case 3:
        return FourthStep();
      default:
        return FirstStep();
    }
  }

  Widget FirstStep() {
    return Form(
      key: _formKeys[0],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Get.height * 0.04),
          FormInput(
            controller: _nameController,
            label: "Name",
            enabled: false,
            textInputType: TextInputType.name,
          ),
          FormInput(
            controller: _emailController,
            enabled: false,
            label: "Email Address",
            textInputType: TextInputType.emailAddress,
          ),
          FormInput(
            controller: _numberController,
            enabled: false,
            label: "Phone Number",
            textInputType: TextInputType.number,
          ),
          FormInput(
            controller: _alternateNumberController,
            label: "Alternate Phone Number (Optional)",
            textInputType: TextInputType.number,
            maxLength: 10,
          ),
          FormInput(
            controller: _addressController,
            label: "Address",
            textInputType: TextInputType.multiline,
            validator: (value) {
              if (value!.isEmpty) {
                return "Address cannot be empty.";
              }
              return null;
            },
          ),
          ImageUploadWidget(
            image: _documentImage,
            onTap: () => pickImage(ImageType.Id_Proof),
            title: "ID Proof Document",
            hintText: "Select Documents for Verification\n(JPG, PNG, max 2MB)",
          ),
        ],
      ),
    );
  }

  Widget SecondStep() {
    return Form(
      key: _formKeys[1],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormInput(
            controller: _shopnameController,
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
            controller: _shop_address_Controller,
            label: "Shop Address",
            textInputType: TextInputType.multiline,
            autofocus: false,
            validator: (value) {
              if (value!.isEmpty) {
                return "Enter Shop Address";
              }
              return null;
            },
          ),
          FormInput(
            controller: _shop_number_Controller,
            label: "Shop Number",
            textInputType: TextInputType.number,
            maxLength: 10,
            validator: (value) {
              if (value!.isEmpty) {
                return "Enter Shop Number";
              }
              return null;
            },
          ),
          FormInput(
            controller: _shop_email_Controller,
            label: "Shop Email Address",
            textInputType: TextInputType.emailAddress,
          ),
          FormInput(
            controller: _shop_Gst_Controller,
            label: "Shop GST Number(if Applicable)",
            textInputType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isNotEmpty) {
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
          const SizedBox(height: 10),
          const Text("Business Hours"),
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
                final result = await Get.to(
                    () => BusinessHoursScreen(initialHours: _businessHours));
                if (result != null && result is Map<String, BusinessHours>) {
                  setState(() {
                    _businessHours = result;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          FormInput(
            controller: _shop_website_Controller,
            label: "Website URL (Optional)",
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
          FormInput(
            controller: _shop_description_Controller,
            label:
                "Shop Description (Short summary about the shop and services)",
            textInputType: TextInputType.multiline,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget ThirdStep() {
    return Form(
        key: _formKeys[2],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageUploadWidget(
              image: _Gstcertificate,
              onTap: () => pickImage(ImageType.GST_Certificate),
              hintText: "Select Documents for Verification\n(JPG, PNG max 2MB)",
              title: "Upload GST Certificate",
            ),
            ImageUploadWidget(
              image: _Rstcertificate,
              onTap: () => pickImage(ImageType.Registration_Certificate),
              hintText: "Select Documents for Verification\n(JPG, PNG max 2MB)",
              title: "Upload Shop Registration Certificate",
            ),
            ImageUploadWidget(
              image: _shopLogo,
              onTap: () => pickImage(ImageType.shop_logo),
              hintText: "Select Documents for Verification\n(JPG, PNG max 2MB)",
              title: "Upload Shop Logo/Image",
            ),
            ImageUploadWidget(
              image: _shop_Location,
              onTap: () => pickImage(ImageType.shop_location),
              hintText: "Select Documents for Verification\n(JPG, PNG max 2MB)",
              title:
                  "Upload Shop Location Proof (e.g., Utility bill, Rent agreement, etc.)",
            ),
            ImageUploadWidget(
              image: _Business_license,
              onTap: () => pickImage(ImageType.Business_License),
              hintText: "Select Documents for Verification\n(JPG, PNG max 2MB)",
              title: "Upload Business License",
            ),
            ImageUploadWidget(
              image: _tax_certificate,
              onTap: () => pickImage(ImageType.Tax_Certificate),
              hintText:
                  "Select Documents for Verification\n(JPG, PNG  max 2MB)",
              title: "Upload VAT or Sales Tax Certificate (if applicable)",
            ),
          ],
        ));
  }

  Widget FourthStep() {
    return Form(key: _formKeys[3], child: const SocialMedia());
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
    final openDays = _businessHours.entries
        .where((entry) => entry.value.isOpen)
        .map((entry) => entry.key)
        .toList();
    if (openDays.isEmpty) return "Closed all week";
    if (openDays.length == 7) return "Open all week";

    return "Open ${openDays.join(', ')}";
  }
}

enum ImageType {
  GST_Certificate,
  Registration_Certificate,
  shop_logo,
  shop_location,
  Business_License,
  Tax_Certificate,
  Id_Proof
}
