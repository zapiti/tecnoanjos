

import 'package:tecnoanjos_franquia/app/components/tectfields/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget CustomTextFieldEnding({TextEditingController controller,InputDecoration decoration,TextStyle style,bool  enabled,ValueChanged<String> onChanged}){
  controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
  return CustomTextField(
    controller: controller,
    enabled: enabled,

    onChanged: onChanged,
  );
}