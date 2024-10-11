import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../custom_text_field.dart';

class FormInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final TextInputType? textInputType;
  final bool filled;
  final bool? readOnly;
  final bool? enabled;
  final String? Function(String?)? validator;
  final bool? autofocus;
  final int? maxLength;
  final bool iswhite;
//ontap
  final Function()? onTap;
  final int? maxLines;
  const FormInput(
      {super.key,
      this.controller,
      this.label,
      this.autofocus,
      this.textInputType,
      this.filled=true,
      this.readOnly,
      this.enabled,
      this.validator,
      this.onTap,
      this.maxLines,
       this.iswhite=false,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label ?? '',
              style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: iswhite ? Colors.white:Colors.black,
                  fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
          CustomTextField(
            filled: filled ?true : false,
            onTap: onTap,
            autoFocus: autofocus,
            readOnly: readOnly,
            maxLen: maxLength,
            enabled: enabled,
            validator: validator,
            maxLines: maxLines,
            controller: controller,
            textInputType: textInputType,
          ),
        ],
      ),
    );
  }
}
