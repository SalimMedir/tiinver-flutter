import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/constants/colors.dart';

class InputField extends StatelessWidget {
  final TextEditingController inputController;
  final TextInputType? type;
  final TextInputAction? textInputAction;
  final String? hintText;
  final Color? fillColor;
  final int? maxLines, maxLength;
  var prefixIcon;
  var suffixIcon;
  double bdRadius;
  bool autofocus;
  bool? obscureText;

  InputField({
    super.key,
    required this.inputController,
    this.type,
    this.maxLines = 1,
    this.textInputAction,
    this.hintText,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.bdRadius = 18,
    this.autofocus = false,
    this.obscureText,

  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if(value!.isEmpty){
          return "Enter the Field";
        }else{
          return null;
        }
      },
      maxLines: maxLines,
      textInputAction: textInputAction,
      keyboardType: type,
      autofocus: autofocus,
      style: TextStyle(
        fontSize: 12.dp,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: themeColor,
      controller: inputController,
      obscureText: obscureText ?? false,
      maxLength: maxLength,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        suffixIconColor: darkGreyColor,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        fillColor: fillColor ?? tileColor,
        filled: true,
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderSide:  BorderSide(
            color: tileColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(bdRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:  BorderSide(
            color: tileColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(bdRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:  BorderSide(
            color: tileColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(bdRadius),
        ),
      ),
    );
  }
}