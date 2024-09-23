import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/image_picker_helper.dart';
import '../../../utils/utils.dart';
import '../create_tournament/form_input.dart';
import '../custom_drop_down_field.dart';

class VendorDetails extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formData;

  const VendorDetails({Key? key, required this.formKey, required this.formData})
      : super(key: key);

  @override
  _VendorDetailsState createState() => _VendorDetailsState();
}

class _VendorDetailsState extends State<VendorDetails> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _alternate_numberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _id_proofController = TextEditingController();
  XFile? _Documentimage;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final File file = File(image.path);
        final decodedImage = await decodeImageFromList(file.readAsBytesSync());
        int fileSizeInBytes = await file.length();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        if (fileSizeInMB >2) {
          errorSnackBar('File size should be less than 2MB.',
              title: "File too large!");
          return;
        }
          final String extension = image.path.split('.').last.toLowerCase();
          if (decodedImage.width == decodedImage.height) {
            errorSnackBar('Image Width And the Height Cannot be the same.',
                title: "Invalid file!");
            return;
          }
          if (extension == 'png' || extension == 'jpg' || extension == 'jpeg') {
            setState(() {
              _Documentimage = image;
            });
          } else {
            _Documentimage = null;
            errorSnackBar('Please select a PNG or JPG image.',
                title: "Invalid file format!");
          }
        } else {
          errorSnackBar(
              'Please select an image with dimensions where \nWidth=1000 \nHeight=560.',
              title: "Invalid image dimensions!");
        }
    } catch (e) {
      logger.d('Error picking image: $e');
      errorSnackBar('An error occurred while picking the image.',
          title: "Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    _nameController.text = authController.state!.fullName;
    _emailController.text = authController.state!.email;
    _numberController.text = authController.state!.phoneNumber.toString();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text("Vendors Details"),
            Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                        color:
                        const Color.fromARGB(255, 142, 133, 133),
                        width: 2)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() => CircleAvatar(
                      radius: 50,
                      backgroundImage: CachedNetworkImageProvider(
                          toImageUrl(authController.state?.profilePhoto ??
                              "")))),
                ),
              ),
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
              controller: _alternate_numberController,
              label: "Alternate Phone Number(Optional)",
              textInputType: TextInputType.number,
              maxLength: 10,
            ),
            FormInput(
              controller: _addressController,
              label: "Shop Address",
              textInputType: TextInputType.multiline,
            ),
            const SizedBox(height: 16),
            Text(
              "ID Proof Document",
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: pickImage,
              child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _Documentimage == null
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
                          child: Image.file(
                            File(
                              _Documentimage!.path,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                            onPressed: () {
                              pickImage();
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
}
