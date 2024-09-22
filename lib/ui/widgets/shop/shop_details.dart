
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
  XFile? _Gstcertificate;
  pickImage()async{
    final ImagePicker picker=ImagePicker();
    try{
      final XFile? image=await picker.pickImage(source: ImageSource.gallery);
      if(image!=null){
        final File file=File(image.path);
        final decodedImage = await decodeImageFromList(file.readAsBytesSync());
        int fileSizeInBytes = await file.length();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        if (fileSizeInMB >2) {
          errorSnackBar('File size should be less than 2MB.',
              title: "File too large!");
          return;
        }
        final String extension = image.path.split('.').last.toLowerCase();
        if(extension=='jpg'||extension=='png'||extension=='jpeg'){
          setState(() {
            _Gstcertificate=image;
          });
        } else {
          _Gstcertificate = null;
          errorSnackBar('Please select a PNG or JPG image.',
              title: "Invalid file format!");
        }
      }
    }catch(e){
      logger.d('Error picking image: $e');
      errorSnackBar('An error occurred while picking the image.',
          title: "Error");
    }
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
              onTap: pickImage,
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