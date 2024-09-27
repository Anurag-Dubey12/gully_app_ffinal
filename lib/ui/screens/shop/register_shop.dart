import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/screens/shop/shop_payment_screen.dart';
import 'package:gully_app/ui/widgets/shop/social_media_link.dart';
import 'package:gully_app/ui/widgets/shop/vendor_details.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/controller/auth_controller.dart';
import '../../../data/controller/shop_controller.dart';
import '../../../data/model/business_hours_model.dart';
import '../../../data/model/shop_model.dart';
import '../../../data/model/vendor_model.dart';
import '../../../utils/app_logger.dart';
import '../../theme/theme.dart';
import '../../widgets/create_tournament/form_input.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/shop/business_hours.dart';
import '../../widgets/shop/image_upload.dart';
import '../../widgets/shop/product_details.dart';
import '../../widgets/shop/shop_details.dart';

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
  bool _allImagesSelected = false;
  bool isLoading = false;

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
  @override
  void initState() {
    super.initState();
    final AuthController authController = Get.find<AuthController>();
    _nameController.text = authController.state!.fullName;
    _emailController.text = authController.state!.email;
    _numberController.text = authController.state!.phoneNumber ?? '';

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
      logger.d('Error picking image: $e');
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

    // Optional images
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
      String errorMessage = "Please upload the following images: ${missingImages.join(', ')}";
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
      child: Scaffold(
        backgroundColor: Colors.black26,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppTheme.primaryColor,
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
          height: 90,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, -1))
          ]),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 19),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : PrimaryButton(
                  onTap: () async {
                    try{
                      if(_key.currentState!.validate()){
                        if(_validateImages()){
                          // setState(() {
                          //   isLoading = true;
                          // });
                          final shopData = shop_model(
                            shopName: _shopnameController.text,
                            shopAddress: _shop_address_Controller.text,
                            shopNumber: _shop_number_Controller.text,
                            shopEmail: _shop_email_Controller.text,
                            gstNumber: _shop_Gst_Controller.text,
                            gstCertificate: _Gstcertificate?.path,
                            registrationCertificate: _Rstcertificate?.path,
                            shopLogo: _shopLogo?.path,
                            businessHours: _businessHours.map((key, value) => MapEntry(key, business_hours_model(
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
                              alternatePhoneNumber: int.tryParse(_alternateNumberController.text),
                              address: _addressController.text,
                              id_proof: _documentImage?.path, id: '',
                            ),
                          );
                          Get.to(()=>ShopPaymentPage(shopData: shopData,));
                        }else{
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    }catch(e){
                      setState(() {
                        isLoading = false;
                      });
                      errorSnackBar("An error occurred while submitting the form.", title: "Error");
                      logger.d("Error submitting form: $e");
                    }
                  },
                  // isDisabled: ,
                  title: 'Submit',
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    height: 2,
                  ),
                  const Center(
                    child: Text(
                      "Vendor Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 2,
                  ),
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
                  const SizedBox(height: 16),
                  const Text("ID Proof Document"),
                  const SizedBox(height: 8),
                  ImageUploadWidget(
                    image: _documentImage,
                    onTap: () => pickImage(ImageType.Id_Proof),
                    hintText:
                        "Select Documents for Verification\n(JPG, PNG, max 2MB)",
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    height: 2,
                  ),
                  const Center(
                    child: Text(
                      "Shop Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 2,
                  ),
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
                            .hasMatch(value!)) {
                          return "Invalid GST Number";
                        }
                        return null;
                      }
                    },
                  ),
                  const Text("Upload GST Certificate"),
                  ImageUploadWidget(
                    image: _Gstcertificate,
                    onTap: () => pickImage(ImageType.GST_Certificate),
                    hintText:
                        "Select Documents for Verification\n(JPG, PNG max 2MB)",
                  ),
                  const SizedBox(height: 10),
                  const Text("Upload Shop Registration Certificate"),
                  const SizedBox(height: 5),
                  ImageUploadWidget(
                    image: _Rstcertificate,
                    onTap: () => pickImage(ImageType.Registration_Certificate),
                    hintText:
                        "Select Documents for Verification\n(JPG, PNG max 2MB)",
                  ),
                  const SizedBox(height: 10),
                  const Text("Upload Shop Logo/Image"),
                  const SizedBox(height: 5),
                  ImageUploadWidget(
                    image: _shopLogo,
                    onTap: () => pickImage(ImageType.shop_logo),
                    hintText:
                        "Select Documents for Verification\n(JPG, PNG max 2MB)",
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
                        final result = await Get.to(() =>
                            BusinessHoursScreen(initialHours: _businessHours));
                        if (result != null &&
                            result is Map<String, BusinessHours>) {
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
                  const Text(
                      "Upload Shop Location Proof (e.g., Utility bill, Rent agreement, etc.)"),
                  const SizedBox(height: 10),
                  ImageUploadWidget(
                    image: _shop_Location,
                    onTap: () => pickImage(ImageType.shop_location),
                    hintText:
                        "Select Documents for Verification\n(JPG, PNG max 2MB)",
                  ),
                  const SizedBox(height: 10),
                  const Text("Upload Business License"),
                  const SizedBox(height: 10),
                  ImageUploadWidget(
                    image: _Business_license,
                    onTap: () => pickImage(ImageType.Business_License),
                    hintText:
                        "Select Documents for Verification\n(JPG, PNG max 2MB)",
                  ),
                  const SizedBox(height: 10),
                  const Text(
                      "Upload VAT or Sales Tax Certificate (if applicable)"),
                  const SizedBox(height: 10),
                  ImageUploadWidget(
                    image: _tax_certificate,
                    onTap: () => pickImage(ImageType.Tax_Certificate),
                    hintText:
                        "Select Documents for Verification\n(JPG, PNG  max 2MB)",
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    height: 2,
                  ),
                  const Center(
                    child: Text(
                      "Social Media Links",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 2,
                  ),
                  const SocialMedia()
                ],
              ),
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
