import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/models/profile.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class ProfileInfoWidget extends StatelessWidget {
  final Profile profile;

  ProfileInfoWidget(this.profile);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shadowColor: Colors.grey,
      borderRadius: BorderRadius.circular(4),
      color: Colors.white,
      child: Container(
        height: 560,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        margin: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            titleDescriptionEditText(
              hint: StringFile.nome,
              title: StringFile.nome,onTap: (){},
              controller: TextEditingController(text: profile?.name ?? ""),
            ),
            titleDescriptionEditText(
              hint: StringFile.cpf,onTap: (){},
              controller: TextEditingController(text: profile?.cpf ?? ""),
              title:  StringFile.cpf,
            ),
            titleDescriptionEditText(
              hint:  StringFile.email,onTap: (){},
              controller: TextEditingController(text: profile?.email ?? ""),
              title:  StringFile.email,
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
              Expanded(child:   titleDescriptionEditText(
                  hint:  StringFile.sexo,onTap: (){},
                  controller:
                      TextEditingController(text: profile?.gender ?? ""),
                  title: StringFile.sexo,
                )),
                Expanded(child:  titleDescriptionEditText(
                  hint: "dd/mm/aaaa",onTap: (){},
                  controller:
                      TextEditingController(text: profile?.birthDate ?? ""),
                  title: StringFile.dataNasc,
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

titleDescriptionEditText({
  String title,
  TextEditingController controller,
  bool obscure = false,
  Function onTap,
  String hint,
  ValueChanged<String> onChange,
  TextInputType keyboard,
  InputDecoration decoration,
  Icon suffixIcon,
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
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: 45,
              child: TextField(
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(80),],
                controller: controller,
                obscureText: obscure,
                enabled: onTap == null,
                onChanged: onChange,
                keyboardType: keyboard,
                decoration: decoration ??
                    InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        hintText: "",
                        suffixIcon: suffixIcon,

                        border: const OutlineInputBorder()),
              ),
            ))
      ]);
}
