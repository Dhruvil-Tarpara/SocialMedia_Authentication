import 'package:flutter/material.dart';

class CommonTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType textInputType;
  final String hintText;
  final Widget? labelText;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final Widget? suffix;
  final Widget? prefix;
  final int? maxLine;
  final TextStyle? textStyle;
  final void Function(String)? onChanged;
  final bool? readOnly;

  const CommonTextFormField({
    super.key,
    this.controller,
    required this.textInputType,
    required this.hintText,
    this.validator,
    this.labelText,
    this.obscureText,
    this.suffix,
    this.maxLine,
    this.textStyle,
    this.onChanged,
    this.readOnly,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly ?? false,
      onChanged: onChanged,
      style: textStyle,
      maxLines: maxLine,
      obscureText: obscureText ?? false,
      controller: controller,
      keyboardType: textInputType,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        prefixIcon: prefix,
        fillColor: Colors.green.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        label: labelText,
        suffixIcon: suffix,
      ),
    );
  }
}
