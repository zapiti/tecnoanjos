import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Widget textFieldEnding({TextEditingController controller,InputDecoration decoration,TextStyle style,bool  enabled,ValueChanged<String> onChanged, TextInputType keyboardType, bool obscureText = false, int qtLines}){
  controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
  return TextField(inputFormatters: [
                                                        LengthLimitingTextInputFormatter(80),],
    controller: controller,
    decoration: decoration,
    obscureText:obscureText,
    enabled: enabled,maxLines: qtLines,
      keyboardType:keyboardType,

    style:style ?? GoogleFonts.ubuntu(fontSize: 14.0),
    onChanged: onChanged,
  );
}