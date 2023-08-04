import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final bool? autoFocus;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final bool? obscureText;
  final TextInputType? textInputType;
  final Function? onTap;
  final bool? enabled;
  final bool? readOnly;
  const CustomTextField(
      {super.key,
      this.hintText,
      this.labelText,
      this.helperText,
      this.errorText,
      this.controller,
      this.autoFocus,
      this.validator,
      this.obscureText,
      this.textInputType,
      this.onTap,
      this.enabled,
      this.readOnly});

  @override
  Widget build(BuildContext context) {
    // return  a text field with border and rounded corners
    return TextFormField(
      validator: validator,
      autofocus: autoFocus ?? false,
      controller: controller,
      enabled: enabled,
      readOnly: readOnly ?? false,
      onTap: onTap == null ? () {} : () => onTap!(),
      obscureText: obscureText ?? false,
      keyboardType: textInputType ?? TextInputType.text,
      decoration: InputDecoration(
        labelStyle: const TextStyle(
            fontWeight: FontWeight.w500, color: Color(0xff676677)),
        hintText: hintText,
        labelText: labelText,
        isDense: true,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xff737382)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xff737382)),
        ),
      ),
    );
  }
}
