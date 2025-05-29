import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';

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
  final bool isinfo;
  final String? infotext;
  final String? infotitle;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
//ontap
  final Function()? onTap;
  final bool isUpperCase;
  final int? maxLines;
  const FormInput(
      {super.key,
      this.controller,
      this.label,
      this.autofocus,
      this.textInputType,
      this.filled = true,
      this.readOnly,
      this.enabled,
      this.suffixIcon,
      this.validator,
      this.onTap,
      this.infotext,
      this.infotitle,
      this.maxLines,
      this.iswhite = false,
      this.isinfo = false,
      this.isUpperCase = false,
      this.focusNode,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isinfo
              ? Row(
                  children: [
                    Text(label ?? '',
                        style: Get.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: iswhite ? Colors.white : Colors.black,
                            fontSize: 16)),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Center(
                                child: Text(
                                  infotitle ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15),
                                  maxLines: 2,
                                ),
                              ),
                              content: Text(
                                infotext ?? '',
                                style: Get.textTheme.bodyMedium?.copyWith(),
                              ),
                              actions: [
                                PrimaryButton(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  title: "OK",
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.info_outline_rounded, size: 18),
                    )
                  ],
                )
              : Text(label ?? '',
                  style: Get.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: iswhite ? Colors.white : Colors.black,
                      fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
          CustomTextField(
            filled: filled ? true : false,
            onTap: onTap,
            autoFocus: autofocus,
            readOnly: readOnly,
            maxLen: maxLength,
            enabled: enabled,
            validator: validator,
            maxLines: maxLines,
            controller: controller,
            suffixIcon: suffixIcon,
            textInputType: textInputType,
            isUpperCase: isUpperCase,
            focusNode: focusNode,
          ),
        ],
      ),
    );
  }
}
