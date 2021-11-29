import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomTextField extends StatelessWidget {
  var keyboardType;
  var hintText;
  var labelText;
  var controller;
  var onChanged;
  bool autofocus;
  bool obscureText;
  TextCapitalization textCapitalization;
  bool enabled;
  Widget suffixIcon;
  Icon prefixIcon;
  CustomTextField(
      {this.keyboardType,
      this.hintText,
      this.labelText,
      this.controller,
      this.onChanged,
      this.textCapitalization,
      this.autofocus,
      this.obscureText,
      EdgeInsets contentPadding,
      this. enabled, this. suffixIcon, this. prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        labelText== null ? SizedBox():   Container(width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(bottom: 10),color: Colors.transparent,
          child:   Text(
          labelText ?? "",
          style: AppThemeUtils.normalSize(fontSize: 12),
        )),
    Container(color: Colors.white,
    child:  TextField(
            keyboardType: keyboardType,
            controller: controller,
            autofocus: autofocus ?? false,enabled: enabled,
            obscureText: obscureText ?? false,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.3),
              ),
            prefixIcon:prefixIcon,
              hintText: labelText == null ?hintText : null ,suffixIcon:suffixIcon
            ),
            style: GoogleFonts.lato(fontSize: 14.0),
            onChanged: onChanged,))
      ],
    );
  }
}
