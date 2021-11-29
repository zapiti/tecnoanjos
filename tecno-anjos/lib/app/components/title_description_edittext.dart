
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tecnoanjostec/app/components/text_field_ending.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

titleDescriptionEditText(
    {final String title,
      final String hint,
      final ValueChanged<String> onChanged,
      final double fixedSize,
      final TextInputType keyboard: TextInputType.text,
      final bool isExpanded = false,
      final TextEditingController controller,
      final  bool enable,
      final bool obscure =false}) {
  return isExpanded
      ? Expanded(
      child: Row(
        children: [
          Container(
            width: fixedSize,
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Text(
              title,
              textAlign: TextAlign.end,
              style: AppThemeUtils.normalSize(),
            ),
          ),
          Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                child: TextField(inputFormatters: [
                  LengthLimitingTextInputFormatter(80),],
                  keyboardType: keyboard,
                  enableInteractiveSelection: enable,
                  enabled: enable,
                  controller: controller,obscureText: obscure,
                  decoration: InputDecoration(
                      hintText: hint,
                      enabled: enable,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      )),
                  onChanged: onChanged,
                ),
              ))
        ],
      ))
      : Row(children: [
    Container(
      width: fixedSize,
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Text(
        title,
        textAlign: TextAlign.end,
        style: AppThemeUtils.normalSize(),
      ),
    ),
    Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 12),
          child: TextField(inputFormatters: [
                                                        LengthLimitingTextInputFormatter(80),],
            keyboardType: TextInputType.text,
            enabled: enable,obscureText: obscure,
            controller: controller,
            decoration: InputDecoration(
                hintText: hint,
                enabled: enable,
                border: const OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                  borderSide: BorderSide(color: Colors.grey, width: 0.3),
                )),
            onChanged: onChanged,
          ),
        ))
  ]);
}
Widget titleDescriptionTextField(
    BuildContext context,
    String title,
    TextEditingController controller, {
      bool obscure = false,
      Function onTap,
      ValueChanged<String> onChange,
      TextInputType keyboard, int qtLines, int height, int vertical,
    }) {
  controller.selection =
      TextSelection.fromPosition(TextPosition(offset: controller.text.length));
  return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 5,
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.only(top: 15, bottom: 0),
            child: Text(
              title,
              maxLines: 1,
              style: AppThemeUtils.normalSize(),
            )),
        GestureDetector(
            onTap: onTap,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical:vertical?? 10),
              height: height ?? 45,
              child: textFieldEnding(
                controller: controller,
                obscureText: obscure,
                qtLines:qtLines,
                enabled: onTap == null,
                onChanged: onChange,
                keyboardType: keyboard,
                decoration: InputDecoration(
                    hintText: "",
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    border: OutlineInputBorder()),
              ),
            ))
      ]);
}
