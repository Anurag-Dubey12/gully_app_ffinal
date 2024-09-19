import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import '../../../utils/utils.dart';
import '../create_tournament/form_input.dart';

class VendorDetails extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formData;

  const VendorDetails({Key? key, required this.formKey, required this.formData}) : super(key: key);

  @override
  _VendorDetailsState createState() => _VendorDetailsState();
}

class _VendorDetailsState extends State<VendorDetails> {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    _nameController.text = authController.state!.fullName;
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Text("Vendors Details"),
          FormInput(
            controller: _nameController,
            label: "Name",
            textInputType: TextInputType.number,
          ),
          FormInput(
            controller: _nameController,
            label: "Name",
            textInputType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}