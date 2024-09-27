import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:gully_app/ui/widgets/shop/business_hours.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/controller/shop_controller.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/utils.dart';
import '../create_tournament/form_input.dart';
import 'image_upload.dart';

class ShopDetails extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(bool) onshopDocumentSelected;
  const ShopDetails(
      {Key? key,
      required this.formKey,
      required this.onshopDocumentSelected})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => ShopDetailsState();
}

class ShopDetailsState extends State<ShopDetails> {
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
  // late shop_model _shop_data;

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
  // void initState() {
  //   super.initState();
  //   final ShopController shopController = Get.find<ShopController>();
  //   // _shop_data=shopController.getShopDetails()!;
  //   _shopnameController.text=_shop_data.shopName ?? '';
  //   _shop_address_Controller.text=_shop_data.shopAddress ?? '';
  //   _shop_number_Controller.text=_shop_data.shopNumber ?? '';
  //   _shop_email_Controller.text=_shop_data.shopEmail ?? '';
  //   _shop_Gst_Controller.text=_shop_data.gstNumber ?? '';
  //   _businessHours = _shop_data.businessHours!.map((key, value) =>
  //       MapEntry(key, value as BusinessHours));
  //   _shop_website_Controller.text = _shop_data.websiteUrl ?? '';
  //   _shop_description_Controller.text = _shop_data.description ?? '';
  //   shopController.updateShopDetails(_shop_data);
  // }

  // void updateShopData(){
  //   _shop_data=shop_model(
  //     shopName: _shopnameController.text,
  //     shopAddress: _shop_address_Controller.text,
  //     shopNumber: _shop_number_Controller.text,
  //     shopEmail: _shop_email_Controller.text,
  //     gstNumber: _shop_Gst_Controller.text,
  //     websiteUrl: _shop_website_Controller.text,
  //     description: _shop_description_Controller.text,
  //     businessHours: _businessHours.map((key, value) => MapEntry(key, value)),
  //   );
  // }

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
          updateAllImagesSelected();
        });
      }
    } catch (e) {
      logger.d('Error picking image: $e');
      errorSnackBar('An error occurred while picking the image.',
          title: "Error");
    }
  }

  void updateAllImagesSelected() {
    bool allSelected = _Gstcertificate != null &&
        _shop_Location != null &&
        _Business_license != null &&
        _tax_certificate != null &&
        _Rstcertificate != null &&
        _shopLogo != null;

    setState(() {
      _allImagesSelected = allSelected;
    });

    widget.onshopDocumentSelected(allSelected);
  }

  void _clearImage(ImageType imageType) {
    setState(() {
      switch (imageType) {
        case ImageType.GST_Certificate:
          _Gstcertificate = null;
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
      updateAllImagesSelected();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 180,left: 8,right: 8),
      child: SingleChildScrollView(
        child: Form(
          key: widget.formKey,
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
                // validator: (value) {
                //   if (!RegExp(
                //           r"^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$")
                //       .hasMatch(value!)) {
                //     return "Invalid GST Number";
                //   }
                //   return null;
                // },
              ),
              const Text("Upload GST Certificate"),
              ImageUploadWidget(
                image: _Gstcertificate,
                onTap: () => pickImage(ImageType.GST_Certificate),
                hintText:
                    "Select Documents for Verification\n(JPG, PNG, or PDF, max 2MB)",
              ),
              const SizedBox(height: 10),
              const Text("Upload Shop Registration Certificate"),
              const SizedBox(height: 5),
              ImageUploadWidget(
                image: _Rstcertificate,
                onTap: () => pickImage(ImageType.Registration_Certificate),
                hintText:
                    "Select Documents for Verification\n(JPG, PNG, or PDF, max 2MB)",
              ),
              const SizedBox(height: 10),
              const Text("Upload Shop Logo/Image"),
              const SizedBox(height: 5),
              ImageUploadWidget(
                image: _shopLogo,
                onTap: () => pickImage(ImageType.shop_logo),
                hintText:
                    "Select Documents for Verification\n(JPG, PNG, or PDF, max 2MB)",
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
              const Text(
                  "Upload Shop Location Proof (e.g., Utility bill, Rent agreement, etc.)"),
              const SizedBox(height: 10),
              ImageUploadWidget(
                image: _shop_Location,
                onTap: () => pickImage(ImageType.shop_location),
                hintText:
                    "Select Documents for Verification\n(JPG, PNG, or PDF, max 2MB)",
              ),
              const SizedBox(height: 10),
              const Text("Upload Business License"),
              const SizedBox(height: 10),
              ImageUploadWidget(
                image: _Business_license,
                onTap: () => pickImage(ImageType.Business_License),
                hintText:
                    "Select Documents for Verification\n(JPG, PNG, or PDF, max 2MB)",
              ),
              const SizedBox(height: 10),
              const Text("Upload VAT or Sales Tax Certificate (if applicable)"),
              const SizedBox(height: 10),
              ImageUploadWidget(
                image: _tax_certificate,
                onTap: () => pickImage(ImageType.Tax_Certificate),
                hintText:
                    "Select Documents for Verification\n(JPG, PNG, or PDF, max 2MB)",
              ),
            ],
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
}
