
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gully_app/ui/widgets/shop/business_hours.dart';
import 'package:gully_app/utils/image_picker_helper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/app_logger.dart';
import '../../../utils/utils.dart';
import '../create_tournament/form_input.dart';

class ShopDetails extends StatefulWidget{
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formData;

  const ShopDetails({Key? key, required this.formKey, required this.formData}) : super(key: key);
  @override
  State<StatefulWidget> createState()=>ShopDetailsState();
}
class ShopDetailsState extends State<ShopDetails>{
  final TextEditingController _shopnameController = TextEditingController();
  final TextEditingController _shop_address_Controller = TextEditingController();
  final TextEditingController _shop_number_Controller = TextEditingController();
  final TextEditingController _shop_email_Controller = TextEditingController();
  final TextEditingController _shop_Gst_Controller = TextEditingController();
  final TextEditingController _shop_website_Controller = TextEditingController();
  final TextEditingController _shop_description_Controller = TextEditingController();
  XFile? _Gstcertificate;
  XFile? _shop_Location;
  XFile? _Business_license;
  XFile? _tax_certificate;
  XFile? _Rstcertificate;
  XFile? _shopLogo;
  List<String> summaries = [];
  Map<String,BusinessHours> _businessHours={
    'Sunday': BusinessHours(isOpen: false),
    'Monday': BusinessHours(),
    'Tuesday': BusinessHours(),
    'Wednesday': BusinessHours(),
    'Thursday': BusinessHours(),
    'Friday': BusinessHours(),
    'Saturday': BusinessHours(isOpen: false),
  };

  void pickImage(ImageType imageType) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final File file = File(image.path);
        final decodedImage = await decodeImageFromList(file.readAsBytesSync());
        int fileSizeInBytes = await file.length();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        if (fileSizeInMB > 2) {
          errorSnackBar('File size should be less than 2MB.',
              title: "File too large!");
          return;
        }
        final String extension = image.path.split('.').last.toLowerCase();
        if (extension == 'jpg' || extension == 'png' || extension == 'jpeg') {
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
                _shop_Location= image;
                break;
              case ImageType.Business_License:
                _Business_license = image;
                break;
              case ImageType.Tax_Certificate:
                _tax_certificate= image;
                break;
            }
          });
        } else {
          _clearImage(imageType);
          errorSnackBar('Please select a PNG or JPG image.',
              title: "Invalid file format!");
        }
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
        case ImageType.Registration_Certificate:
          _Rstcertificate = null;
          break;
        case ImageType.shop_logo:
          _shopLogo = null;
          break;
        case ImageType.shop_location:
          _shop_Location= null;
          break;
        case ImageType.Business_License:
          _Business_license = null;
          break;
        case ImageType.Tax_Certificate:
          _tax_certificate= null;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormInput(
              controller: _shopnameController,
              label: "Shop Name",
              textInputType: TextInputType.name,
            ),
            FormInput(
              controller: _shop_address_Controller,
              label: "Shop Address",
              textInputType: TextInputType.multiline,
            ),
            FormInput(
              controller: _shop_number_Controller,
              label: "Shop Number",
              textInputType: TextInputType.number,
              maxLength: 10,
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
            ),
            const Text("Upload GST Certificate"),
            GestureDetector(
              onTap: () => pickImage(ImageType.GST_Certificate),
              child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _Gstcertificate == null
                      ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 40,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Select Documents for Verification\n(JPG, PNG, or PDF, max 2MB)",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                      : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: Get.width,
                          height: 200,
                          child: GestureDetector(
                            onLongPress: (){
                              imageViewer(context, _Gstcertificate!.path, false);
                            },
                            child: Image.file(
                              File(
                                _Gstcertificate!.path,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                            onPressed: () {
                              pickImage(ImageType.GST_Certificate);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            )),
                      )
                    ],
                  )
              ),
            ),
            const SizedBox(height: 10),
            const Text("Upload Shop Registration Certificate"),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () => pickImage(ImageType.Registration_Certificate),
              child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _Rstcertificate == null
                      ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 40,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Select Documents for Verification\n(JPG, PNG, or PDF, max 2MB)",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                      : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: Get.width,
                          height: 200,
                          child: GestureDetector(
                            onLongPress: (){
                              imageViewer(context, _Rstcertificate!.path, false);
                            },
                            child: Image.file(
                              File(
                                _Rstcertificate!.path,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                            onPressed: () {
                              pickImage(ImageType.Registration_Certificate);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            )),
                      )
                    ],
                  )
              ),
            ),
            const SizedBox(height: 10),
            const Text("Upload Shop Logo/Image"),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () => pickImage(ImageType.shop_logo),
              child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _shopLogo == null
                      ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 40,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Select Documents for Verification\n(JPG, PNG, or PDF, max 2MB)",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                      : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: Get.width,
                          height: 200,
                          child: GestureDetector(
                            onLongPress: (){
                              imageViewer(context, _shopLogo!.path, false);
                            },
                            child: Image.file(
                              File(
                                _shopLogo!.path,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                            onPressed: () {
                              pickImage(ImageType.shop_logo);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            )),
                      )
                    ],
                  )
              ),
            ),
            const SizedBox(height: 10),
            const Text("Business Hours"),
            ListTile(
              title: Text(_getBusinessHoursSummary()),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final result = await Get.to(() => BusinessHoursScreen(initialHours: _businessHours));
                if (result != null && result is Map<String, BusinessHours>) {
                  setState(() {
                    _businessHours = result;
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            FormInput(
              controller: _shop_website_Controller,
              label: "Website URL (Optional)",
              textInputType: TextInputType.url,
            ),
            FormInput(
              controller: _shop_description_Controller,
              label: "Shop Description (Short summary about the shop and services)",
              textInputType: TextInputType.multiline,
            ),
            const Text("Upload Shop Location Proof (e.g., Utility bill, Rent agreement, etc.)"),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () => pickImage(ImageType.shop_location),
              child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _shop_Location == null
                      ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 40,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Select Documents for Verification\n(JPG, PNG, or PDF, max 2MB)",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                      : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: Get.width,
                          height: 200,
                          child: GestureDetector(
                            onLongPress: (){
                              imageViewer(context, _shop_Location!.path, false);
                            },
                            child: Image.file(
                              File(
                                _shop_Location!.path,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                            onPressed: () {
                              pickImage(ImageType.shop_location);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            )),
                      )
                    ],
                  )
              ),
            ),
            const Text("Upload Business License"),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () => pickImage(ImageType.Business_License),
              child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _Business_license == null
                      ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 40,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Select Documents for Verification\n(JPG, PNG, or PDF, max 2MB)",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                      : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: Get.width,
                          height: 200,
                          child: GestureDetector(
                            onLongPress: (){
                              imageViewer(context, _Business_license!.path, false);
                            },
                            child: Image.file(
                              File(
                                _Business_license!.path,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                            onPressed: () {
                              pickImage(ImageType.Business_License);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            )),
                      )
                    ],
                  )
              ),
            ),
            const Text("Upload VAT or Sales Tax Certificate (if applicable)"),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () => pickImage(ImageType.Tax_Certificate),
              child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _tax_certificate == null
                      ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 40,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Select Documents for Verification\n(JPG, PNG, or PDF, max 2MB)",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                      : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: Get.width,
                          height: 200,
                          child: GestureDetector(
                            onLongPress: (){
                              imageViewer(context, _tax_certificate!.path, false);
                            },
                            child: Image.file(
                              File(
                                _tax_certificate!.path,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                            onPressed: () {
                              pickImage(ImageType.Tax_Certificate);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            )),
                      )
                    ],
                  )
              ),
            ),
          ],
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