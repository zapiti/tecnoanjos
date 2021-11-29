import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';


class TitleDescriptionTextFormFieldWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool obscure;
  final Function onTap;
  final ValueChanged<String> onChange;
  final ValueChanged<String> onSubmited;
  final TextInputType keyboard;
  final InputDecoration decoration;
  final Widget suffixIcon;
  final Icon prefixIcon;
  final List<TextInputFormatter> masks;
  final Function(String) validator;
  final bool enable;
  final BoxConstraints sizeForFlex;
  final TextAlign textAlign;
  final String hint;
  final bool readOnly;
  final String errorText;
  TitleDescriptionTextFormFieldWidget(
      {this.title,
      this.controller,
      this.decoration,
      this.keyboard,
      this.masks,
      this.obscure,
      this.onChange,
      this.onTap,
      this.suffixIcon,
      this.validator,
      this.enable,
      this.sizeForFlex,
      this.prefixIcon,
      this.textAlign,
      this.onSubmited,
      this.hint,
      this.readOnly = false, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            title == null
                ? Container()
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 0),
                    padding: EdgeInsets.only(top: 5, bottom: 0),
                    child: Text(
                      title,
                      maxLines: 1,
                      style:
                          AppThemeUtils.normalSize(color: AppThemeUtils.black),
                    )),
            GestureDetector(
                onTap: onTap,
                child: Container(
                  constraints: sizeForFlex ?? BoxConstraints(),
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: TextFormField(
                    validator: validator,
                    controller: controller,
                    obscureText: obscure == true,
                    enabled: readOnly ? false : enable ?? onTap == null,
                    onChanged: onChange,
                    onFieldSubmitted: onSubmited,
                    keyboardType: keyboard,
                    inputFormatters: masks ?? [],
                    textAlign: textAlign ?? TextAlign.start,

                    decoration:  decoration ??
                        InputDecoration(
                            hintText: hint ?? "",
                            suffixIcon: suffixIcon,
                            prefixIcon: prefixIcon,errorText: errorText,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            border: OutlineInputBorder()),
                  ),
                ))
          ]),
    );
  }
}
