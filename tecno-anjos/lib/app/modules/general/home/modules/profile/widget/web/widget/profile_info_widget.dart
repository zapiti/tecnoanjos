import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tecnoanjostec/app/components/title_description_edittext.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/models/profile.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';

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
                title: StringFile.nome,
                enable: false,
                controller: TextEditingController(text: profile?.name ?? ""),
                isExpanded: false,
                fixedSize: 70),
            titleDescriptionEditText(
                hint: StringFile.cpf,
                controller: TextEditingController(text: profile?.cpf ?? ""),
                enable: false,
                title: StringFile.cpf,
                isExpanded: false,
                fixedSize: 70),
            titleDescriptionEditText(
              hint: StringFile.email,
              controller: TextEditingController(text: profile?.email ?? ""),
              title: StringFile.email,
              enable: false,
              fixedSize: 70,
              isExpanded: false,
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                titleDescriptionEditText(
                    hint: StringFile.genero,
                    enable: false,
                    controller:
                        TextEditingController(text: profile?.gender ?? ""),
                    title: StringFile.genero,
                    isExpanded: true,
                    fixedSize: 70),
                titleDescriptionEditText(
                  hint: "dd/mm/aaaa",
                  enable: false,
                  controller:
                      TextEditingController(text: profile?.birthDate ?? ""),
                  title: StringFile.dataNasc,
                  isExpanded: true,
                )
              ],
            ),
//            Container(
//                width: MediaQuery.of(context).size.width / 2,
//                height: 45,
//                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
//                child: ElevatedButton(
//                  color: Theme.of(context).primaryColor,
//                  onPressed: () {},
//                  //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
//                  child: Text(
//                    StringFile.salvar,
//                    style: TextStyle(color: Colors.white, fontSize: 16),
//                  ),
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.all(Radius.circular(8)),
//                      borderSide: BorderSide.none),
//                )),
          ],
        ),
      ),
    );
  }
}
