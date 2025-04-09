import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:gully_app/data/controller/SelectLocationScreenController.dart';
import 'package:gully_app/data/controller/shop_controller.dart';
import 'package:gully_app/ui/screens/select_location.dart';
import 'package:gully_app/ui/screens/shop_payment_screen.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/shop/image_upload.dart';
import 'package:gully_app/ui/widgets/shop/shop_imagepicker.dart';
import 'package:gully_app/utils/geo_locator_helper.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/controller/auth_controller.dart';
import '../../../../data/model/business_hours_model.dart';
import '../../../../data/model/shop_model.dart';
import '../../../../data/model/vendor_model.dart';
import '../../../theme/theme.dart';
import '../../../widgets/create_tournament/form_input.dart';
import '../../../widgets/shop/business_hours.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class AadhaarVerificationScreen extends StatefulWidget {
  @override
  _AadhaarVerificationScreenState createState() =>
      _AadhaarVerificationScreenState();
}

class _AadhaarVerificationScreenState extends State<AadhaarVerificationScreen> {
  File? _frontImageFile;
  File? _backImageFile;
  bool isProcessingAadhaar = false;
  String aadharnumber = '';
  String dob = '';
  String name = '';
  String aadharnumberBack = '';
  String nameBack = '';
  final TextEditingController _identificationNumberController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  @override
  void dispose() {
    _identificationNumberController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, {bool isFrontSide = true}) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          if (isFrontSide) {
            _frontImageFile = File(image.path);
          } else {
            _backImageFile = File(image.path);
          }
        });
        // Trigger text extraction after selecting the image
        if (isFrontSide) {
          _extractAadhaarInfo(_frontImageFile!, isFrontSide: true);
        } else {
          _extractAadhaarInfo(_backImageFile!, isFrontSide: false);
        }
      }
    } catch (e) {
      errorSnackBar('An error occurred while picking the image.',
          title: "Error");
    }
  }

  Future<void> _extractAadhaarInfo(File imageFile,
      {required bool isFrontSide}) async {
    setState(() {
      isProcessingAadhaar = true;
    });

    try {
      // Create an InputImage from the file
      final inputImage = InputImage.fromFile(imageFile);

      // Initialize the text recognizer
      final textRecognizer = TextRecognizer();

      // Process the image
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      // Release resources
      await textRecognizer.close();

      // Extract Aadhaar number using regex
      final aadhaarRegex = RegExp(r'\d{4}\s\d{4}\s\d{4}|\d{12}');
      final dobRegex = RegExp(r'\d{2}/\d{2}/\d{4}');

      String extractedName = "";
      String extractedDob = "";
      String extractedAadhaar = "";

      // Check each text block for Aadhaar number, name, and DOB
      for (TextBlock block in recognizedText.blocks) {
        final text = block.text;

        // Try to find Aadhaar number
        final aadhaarMatch = aadhaarRegex.firstMatch(text);
        if (aadhaarMatch != null && extractedAadhaar.isEmpty) {
          extractedAadhaar = aadhaarMatch.group(0)!.replaceAll(' ', '');
        }

        // Try to find DOB
        final dobMatch = dobRegex.firstMatch(text);
        if (dobMatch != null && extractedDob.isEmpty) {
          extractedDob = dobMatch.group(0)!;
        }

        // Look for name - typically found near "Name:" or similar text
        if (text.toLowerCase().contains('name') && extractedName.isEmpty) {
          final nameLines = text.split('\n');
          for (int i = 0; i < nameLines.length; i++) {
            if (nameLines[i].toLowerCase().contains('name')) {
              if (i + 1 < nameLines.length) {
                extractedName = nameLines[i + 1].trim();
                break;
              }
            }
          }
        }
      }

      // Update the state with extracted information
      setState(() {
        if (isFrontSide) {
          aadharnumber = extractedAadhaar;
          dob = extractedDob;
          name = extractedName;

          // Update form fields with extracted values
          _identificationNumberController.text = aadharnumber;
          _nameController.text = name;
          _dobController.text = dob;
        } else {
          aadharnumberBack = extractedAadhaar;
          nameBack = extractedName;
        }

        isProcessingAadhaar = false;
      });

      // Show feedback to user
      if (aadharnumber.isNotEmpty ||
          dob.isNotEmpty ||
          name.isNotEmpty ||
          aadharnumberBack.isNotEmpty ||
          nameBack.isNotEmpty) {
        final extractedItems = [
          if (aadharnumber.isNotEmpty) "Front Aadhaar: $aadharnumber",
          if (name.isNotEmpty) "Front Name: $name",
          if (dob.isNotEmpty) "Front DOB: $dob",
          if (aadharnumberBack.isNotEmpty) "Back Aadhaar: $aadharnumberBack",
          if (nameBack.isNotEmpty) "Back Name: $nameBack",
        ];

        Get.snackbar(
          "Information Extracted",
          "Successfully extracted: ${extractedItems.join(', ')}",
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          "Extraction Failed",
          "Could not extract information from the Aadhaar card. Please enter manually.",
          backgroundColor: Colors.orange.withOpacity(0.7),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      setState(() {
        isProcessingAadhaar = false;
      });
      errorSnackBar("Error extracting information from ID: $e",
          title: "Extraction Error");
    }
  }

  void errorSnackBar(String message, {String? title}) {
    Get.snackbar(
      title ?? "Error",
      message,
      backgroundColor: Colors.red.withOpacity(0.7),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Aadhaar Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Front side image section
            _frontImageFile == null
                ? Column(
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            _pickImage(ImageSource.camera, isFrontSide: true),
                        child: Text("Capture Front Side"),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () =>
                            _pickImage(ImageSource.gallery, isFrontSide: true),
                        child: Text("Select Front Side from Gallery"),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Image.file(
                        _frontImageFile!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 20),
                      isProcessingAadhaar
                          ? CircularProgressIndicator()
                          : Column(
                              children: [
                                TextField(
                                  controller: _identificationNumberController,
                                  decoration: InputDecoration(
                                      labelText: 'Aadhaar Number'),
                                ),
                                TextField(
                                  controller: _nameController,
                                  decoration:
                                      InputDecoration(labelText: 'Name'),
                                ),
                                TextField(
                                  controller: _dobController,
                                  decoration: InputDecoration(labelText: 'DOB'),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    // Optionally, submit the data here
                                  },
                                  child: Text("Verify Aadhaar Front Details"),
                                ),
                              ],
                            ),
                    ],
                  ),
            SizedBox(height: 20),

            // Back side image section
            _backImageFile == null
                ? Column(
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            _pickImage(ImageSource.camera, isFrontSide: false),
                        child: Text("Capture Back Side"),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () =>
                            _pickImage(ImageSource.gallery, isFrontSide: false),
                        child: Text("Select Back Side from Gallery"),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Image.file(
                        _backImageFile!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 20),
                      isProcessingAadhaar
                          ? CircularProgressIndicator()
                          : Column(
                              children: [
                                TextField(
                                  controller: TextEditingController(
                                      text: aadharnumberBack),
                                  decoration: InputDecoration(
                                      labelText: 'Back Aadhaar Number'),
                                ),
                                TextField(
                                  controller:
                                      TextEditingController(text: nameBack),
                                  decoration:
                                      InputDecoration(labelText: 'Back Name'),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    // Optionally, submit the data here
                                  },
                                  child: Text("Verify Aadhaar Back Details"),
                                ),
                              ],
                            ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

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
  final TextEditingController _addressController = TextEditingController();
  XFile? _documentImage;
  bool tncAccepted = false;
  final TextEditingController _shopnameController = TextEditingController();
  final TextEditingController shopAddressController = TextEditingController();
  final TextEditingController shoplocationController = TextEditingController();
  final TextEditingController _identificationNumber = TextEditingController();
  final TextEditingController shopNumberController = TextEditingController();
  final TextEditingController shopEmailController = TextEditingController();
  final TextEditingController shopGstController = TextEditingController();
  final TextEditingController shopWebsiteController = TextEditingController();
  final TextEditingController shopDescriptionController =
      TextEditingController();
  XFile? gstCertificate;
  XFile? shopLocation;
  XFile? businessLicense;
  XFile? taxCertificate;
  XFile? rstCertificate;
  XFile? _shopLogo;
  List<String>? shopimages;
  bool isLoading = false;
  int currentStep = 0;
  final ScrollController _controller = ScrollController();
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final List<String> _stepTitles = [
    'Vendor Details',
    'Shop Details',
    'Additional Shop Details'
  ];
  List<String>? images = [
    'assets/images/logo.png',
    'assets/images/logo.png',
    'assets/images/logo.png'
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
  String name = "";
  String dob = "";
  String aadharnumber = "";
  bool isProcessingAadhaar = false;

  late LatLng location;
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

      // if (currentStep == 2 && !_validateImages()) {
      //   // errorSnackBar("Please Upload All The Required Documents");
      //   return;
      // }
      // if (currentStep == 0 && _documentImage == null) {
      //   errorSnackBar("ID proof document required.");
      //   return;
      // }
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
          final controller = Get.find<ShopController>();
          final shopData = shop_model(
            shopName: _shopnameController.text,
            shopAddress: shopAddressController.text,
            shopNumber: shopNumberController.text,
            shopEmail: shopEmailController.text,
            gstNumber: shopGstController.text,
            gstCertificate: gstCertificate?.path,
            registrationCertificate: rstCertificate?.path,
            shopLogo: _shopLogo?.path,
            businessHours: _businessHours.map((key, value) => MapEntry(
                key,
                business_hours_model(
                  isOpen: value.isOpen,
                  openTime: value.openTime?.format(context),
                  closeTime: value.closeTime?.format(context),
                  id: null,
                ))),
            websiteUrl: shopWebsiteController.text,
            description: shopDescriptionController.text,
            locationProof: shopLocation?.path,
            businessLicense: businessLicense?.path,
            taxCertificate: taxCertificate?.path,
            vendor: vendor_model(
              name: _nameController.text,
              email: _emailController.text,
              phoneNumber: _numberController.text,
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
    fetchLocation();
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
              gstCertificate = image;
              break;
            case ImageType.Id_Proof:
              _documentImage = image;
              Get.to(() => AadhaarVerificationScreen());
              break;
            case ImageType.Registration_Certificate:
              rstCertificate = image;
              break;
            case ImageType.shop_logo:
              _shopLogo = image;
              break;
            case ImageType.shop_location:
              shopLocation = image;
              break;
            case ImageType.Business_License:
              businessLicense = image;
              break;
            case ImageType.Tax_Certificate:
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
        case ImageType.GST_Certificate:
          gstCertificate = null;
          break;
        case ImageType.Id_Proof:
          _documentImage = null;
          break;
        case ImageType.Registration_Certificate:
          rstCertificate = null;
          break;
        case ImageType.shop_logo:
          _shopLogo = null;
          break;
        case ImageType.shop_location:
          shopLocation = null;
          break;
        case ImageType.Business_License:
          businessLicense = null;
          break;
        case ImageType.Tax_Certificate:
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

    if (shopGstController.text.isNotEmpty && gstCertificate == null) {
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
                      child: CurrentStepBuild(),
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

  Widget CurrentStepBuild() {
    switch (currentStep) {
      case 0:
        return FirstStep();
      case 1:
        return SecondStep();
      case 2:
        return ThirdStep();
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
          // SizedBox(height: Get.height * 0.00),
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
            controller: _addressController,
            label: "Owner Address",
            textInputType: TextInputType.multiline,
            // validator: (value) {
            //   if (value!.isEmpty) {
            //     return "Address cannot be empty.";
            //   }
            //   RegExp addressRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$');
            //   if (!addressRegExp.hasMatch(value)) {
            //     return "Address must contain at least one letter and one number.";
            //   }

            //   if (value.length < 10) {
            //     return "Address must be at least 10 characters long.";
            //   }

            //   return null;
            // },
          ),
          // FormInput(
          //   controller: _addressController,
          //   label: "Owner Address",
          //   textInputType: TextInputType.multiline,
          //   validator: (value) {
          //     if (value!.isEmpty) {
          //       return "Address cannot be empty.";
          //     }

          //     // Check if the address contains at least one letter (optional to allow spaces, commas, etc.)
          //     RegExp addressRegExp = RegExp(
          //         r'^[A-Za-z0-9\s,.-]+$'); // Letters, numbers, spaces, commas, periods, hyphens
          //     if (!addressRegExp.hasMatch(value)) {
          //       return "Address can only contain letters, numbers, spaces, commas, periods, or hyphens.";
          //     }

          //     // Optional: Add more checks like length
          //     if (value.length < 10) {
          //       return "Address must be at least 10 characters long.";
          //     }

          //     return null;
          //   },
          // ),

          ImageUploadWidget(
            image: _documentImage,
            onTap: () => pickImage(ImageType.Id_Proof),
            title: "ID Proof Document",
            hintText: "Select Documents for Verification\n(JPG, PNG, max 2MB)",
          ),
          FormInput(
            controller: _identificationNumber,
            label: "Owner Identification Number",
            textInputType: TextInputType.multiline,
            // validator: (value) {
            //   if (value!.isEmpty) {
            //     return "Address cannot be empty.";
            //   }
            //   return null;
            // },
          ),
        ],
      ),
    );
  }

  //#TODO need to add Validation
  Widget SecondStep() {
    return Form(
      key: _formKeys[1],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShopImagePicker(
            images: shopimages ?? [],
            onImagesChanged: _handleImageChange,
          ),
          FormInput(
            controller: _shopnameController,
            label: "Shop Name",
            textInputType: TextInputType.name,
            // validator: (value) {
            //   if (value!.isEmpty) {
            //     return "Enter Shop Name";
            //   }
            //   return null;
            // },
          ),
          FormInput(
            controller: shopNumberController,
            label: "Shop Phone Number",
            textInputType: TextInputType.number,
            maxLength: 10,
            // validator: (value) {
            //   if (value!.isEmpty) {
            //     return "Enter Shop Number";
            //   }
            //   return null;
            // },
          ),
          FormInput(
            controller: shopEmailController,
            label: "Shop Email Address",
            textInputType: TextInputType.emailAddress,
          ),
          FormInput(
            controller: shopGstController,
            label: "Shop GST Number",
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
        ],
      ),
    );
  }

  // Widget ThirdStep() {
  //   return Form(
  //       key: _formKeys[2],
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           ImageUploadWidget(
  //             image: gstCertificate,
  //             onTap: () => pickImage(ImageType.GST_Certificate),
  //             hintText: "Select Documents for Verification\n(JPG, PNG max 2MB)",
  //             title: "Upload GST Certificate",
  //           ),
  //           ImageUploadWidget(
  //             image: rstCertificate,
  //             onTap: () => pickImage(ImageType.Registration_Certificate),
  //             hintText: "Select Documents for Verification\n(JPG, PNG max 2MB)",
  //             title: "Upload Shop Registration Certificate",
  //           ),
  //           ImageUploadWidget(
  //             image: _shopLogo,
  //             onTap: () => pickImage(ImageType.shop_logo),
  //             hintText: "Select Documents for Verification\n(JPG, PNG max 2MB)",
  //             title: "Upload Shop Logo/Image",
  //           ),
  //           ImageUploadWidget(
  //             image: shopLocation,
  //             onTap: () => pickImage(ImageType.shop_location),
  //             hintText: "Select Documents for Verification\n(JPG, PNG max 2MB)",
  //             title:
  //                 "Upload Shop Location Proof (e.g., Utility bill, Rent agreement, etc.)",
  //           ),
  //           ImageUploadWidget(
  //             image: businessLicense,
  //             onTap: () => pickImage(ImageType.Business_License),
  //             hintText: "Select Documents for Verification\n(JPG, PNG max 2MB)",
  //             title: "Upload Business License",
  //           ),
  //           ImageUploadWidget(
  //             image: taxCertificate,
  //             onTap: () => pickImage(ImageType.Tax_Certificate),
  //             hintText:
  //                 "Select Documents for Verification\n(JPG, PNG  max 2MB)",
  //             title: "Upload VAT or Sales Tax Certificate (if applicable)",
  //           ),
  //         ],
  //       ));
  // }

  Widget ThirdStep() {
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
              // validator: (value) {
              //   if (value!.isEmpty) {
              //     return "Enter Shop Address";
              //   }
              //   return null;
              // },
            ),
            FormInput(
              controller: _addressController,
              label: "Select Location",
              readOnly: true,
              iswhite: false,
              filled: true,
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
              "Business Hours",
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
                  final result =
                      await showModalBottomSheet<Map<String, BusinessHours>>(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return SizedBox(
                          height: Get.height * 0.8,
                          child: BusinessHoursScreen(
                              initialHours: _businessHours));
                    },
                  );

                  if (result != null) {
                    setState(() {
                      _businessHours = result;
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
