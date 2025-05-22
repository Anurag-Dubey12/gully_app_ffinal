import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final Widget? suffixIcon;
  final bool? filled;
  final int? maxLines;
  final int? minLines;
  final bool isUpperCase;
  final FocusNode? focusNode;
  final int? maxLen;
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
      this.readOnly,
      this.suffixIcon,
      this.filled,
      this.maxLines,
      this.minLines,
      this.isUpperCase = false,
      this.focusNode,
      this.maxLen});

  @override
  Widget build(BuildContext context) {
    // return  a text field with border and rounded corners
    return TextFormField(
      validator: validator,
      autofocus: autoFocus ?? false,
      controller: controller,
      enabled: enabled,
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      maxLines: minLines,
      maxLength: maxLen,
      focusNode: focusNode,
      minLines: maxLines,
      // smartDashesType: SmartDashe
      // sType.enabled,
      inputFormatters: isUpperCase ? [UpperCaseTextFormatter()] : [],

      readOnly: readOnly ?? false,
      onTap: onTap == null ? () {} : () => onTap!(),
      obscureText: obscureText ?? false,
      keyboardType: textInputType ?? TextInputType.text,
      decoration: InputDecoration(
        labelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 106, 106, 106)),
        hintText: hintText,
        labelText: labelText,
        suffixIcon: suffixIcon,
        filled: filled,
        isDense: true,
        counter: const SizedBox(),
        fillColor: Colors.white,
        hintStyle: const TextStyle(
            color: Color.fromARGB(255, 144, 144, 144), fontSize: 12),
        border: filled ?? false
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 255, 255, 255), width: 0))
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xff737382)),
              ),
        enabledBorder: filled ?? false
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 255, 255, 255), width: 0))
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xff737382)),
              ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
