import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/controller/auth_controller.dart';
import '../../../data/controller/shop_controller.dart';
import '../../../data/model/vendor_model.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/utils.dart';
import '../create_tournament/form_input.dart';

class VendorDetails extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(bool) onDocumentImageSelected;
  const VendorDetails({
    Key? key,
    required this.formKey,
    required this.onDocumentImageSelected,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VendorDetailsState();
}

class _VendorDetailsState extends State<VendorDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _alternateNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  XFile? _documentImage;
  late vendor_model _vendorData;

  @override
  void initState() {
    super.initState();
    final AuthController authController = Get.find<AuthController>();
    final ShopController shopController = Get.find<ShopController>();
    _vendorData = shopController.getVendorDetails() ?? vendor_model(name: '', email: '', phoneNumber: '', id: '');
    if (_vendorData.name.isEmpty) {
      _vendorData = vendor_model(
        name: authController.state?.fullName ?? '',
        email: authController.state?.email ?? '',
        phoneNumber: authController.state?.phoneNumber?.toString() ?? '',
        id: authController.state?.id.toString() ?? '',
      );
    }
    _nameController.text = _vendorData.name;
    _emailController.text = _vendorData.email;
    _numberController.text = _vendorData.phoneNumber;
    _alternateNumberController.text = _vendorData.alternatePhoneNumber?.toString() ?? '';
    _addressController.text = _vendorData.address ?? '';
    shopController.updateVendorDetails(_vendorData);
  }

  void _updateVendorData() {
    _vendorData = vendor_model(
      name: _nameController.text,
      email: _emailController.text,
      phoneNumber: _numberController.text,
      id: _vendorData.id,
      alternatePhoneNumber: int.tryParse(_alternateNumberController.text),
      address: _addressController.text,
      id_proof: '',
    );
    final ShopController shopController = Get.find<ShopController>();
    shopController.updateVendorDetails(_vendorData);
    logger.d("The vendor Details are:${_vendorData.id_proof}");
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final File file = File(image.path);
        final decodedImage = await decodeImageFromList(file.readAsBytesSync());
        int fileSizeInBytes = await file.length();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        if (fileSizeInMB > 2) {
          errorSnackBar('File size should be less than 2MB.', title: "File too large!");
          return;
        }
        final String extension = image.path.split('.').last.toLowerCase();
        if (decodedImage.width == decodedImage.height) {
          errorSnackBar('Image Width And the Height Cannot be the same.', title: "Invalid file!");
          return;
        }
        if (extension == 'png' || extension == 'jpg' || extension == 'jpeg') {
          setState(() {
            _documentImage = image;
            widget.onDocumentImageSelected(true);
            _updateVendorData();
          });
        } else {
          _documentImage = null;
          widget.onDocumentImageSelected(false);
          errorSnackBar('Please select a PNG or JPG image.', title: "Invalid file format!");
        }
      } else {
        errorSnackBar('Please select an image with valid dimensions.', title: "Invalid image!");
      }
    } catch (e) {
      logger.d('Error picking image: $e');
      errorSnackBar('An error occurred while picking the image.', title: "Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: widget.formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                // validator: (value) {
                //   if (value!.isEmpty) {
                //     return "Address cannot be empty.";
                //   }
                //   return null;
                // },
              ),
              const SizedBox(height: 16),
              const Text("ID Proof Document"),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _documentImage == null
                      ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate, size: 40, color: Colors.black),
                        SizedBox(height: 10),
                        Text(
                          "Select Documents for Verification\n(JPG, PNG, or PDF, max 2MB)",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
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
                            File(_documentImage!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                          onPressed: pickImage,
                          icon: const Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
