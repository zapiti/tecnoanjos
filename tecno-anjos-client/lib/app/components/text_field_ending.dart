import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Widget textFieldEnding(
    {TextEditingController controller,
    InputDecoration decoration,
    TextStyle style,
    bool enabled,
    ValueChanged<String> onChanged,
    TextInputType keyboardType,
    bool obscure}) {
  controller.selection =
      TextSelection.fromPosition(TextPosition(offset: controller.text.length));
  return TextField(
    inputFormatters: [
      LengthLimitingTextInputFormatter(80),
    ],
    controller: controller,
    decoration: decoration,
    keyboardType: keyboardType,
    obscureText: obscure ?? false,
    enabled: enabled,
    style: style ?? GoogleFonts.ubuntu(fontSize: 14.0),
    onChanged: onChanged,
  );
}
