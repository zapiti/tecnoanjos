import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tecno_anjos_landing/app/components/divider/line_view_widget.dart';
import 'package:tecno_anjos_landing/app/components/mobile/title_descritption_mobile_widget.dart';
import 'package:tecno_anjos_landing/app/components/page/default_tab_page.dart';

import 'package:tecno_anjos_landing/app/components/title_description_edittext.dart';

import 'package:tecno_anjos_landing/app/modules/landing_page/landing_page_bloc.dart';
import 'package:tecno_anjos_landing/app/modules/landing_page/model/registre_franchise.dart';
import 'package:tecno_anjos_landing/app/utils/string/string_file.dart';
import 'package:tecno_anjos_landing/app/utils/theme/app_theme_utils.dart';

Widget bodyRegistreFranquise(BuildContext context) {
  return DefaultTabPage(
    title: [StringFile.tecnoIndividual, StringFile.franquia],

    Page: [
     bodyHomeBased(context),
      franquised(context),
    ],
  );
}

Widget franquised(BuildContext context) {
  var landingPageBloc = Modular.get<LandingPageBloc>();
  var nameController = TextEditingController();
  var cnpjController = TextEditingController();
  var telefoneController = TextEditingController();
  var emailController = TextEditingController();
  var complementController = TextEditingController();
  var numberController = TextEditingController();
  var contactController = TextEditingController();
  var cepController = TextEditingController();
  var cidadeController = TextEditingController();

  var enderecoController = TextEditingController();
  var temFranquised = RegisteFranchise();

  return  StreamBuilder<RegisteFranchise>(
      stream: landingPageBloc.currentFranquise,
      initialData: RegisteFranchise(),
      builder: (context, snapshot) => Column(
            children: [

              Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    StringFile.cadastreSe,
                    style: TextStyle(
                        color: AppThemeUtils.colorPrimary, fontSize: 18),
                  )),
              lineViewWidget(),
              titleDescriptionBigMobileWidget(context,
                  action: () {},
                  title: 'Tipo de franquia',
                  description:
                      temFranquised.franquise ? "Franquiadora" : "Quioesque",
                  customIcon: Switch(
                      value: temFranquised.franquise ?? false,
                      activeColor: AppThemeUtils.colorPrimary,
                      onChanged: (value) {
                        temFranquised.franquise = value;
                        landingPageBloc.currentFranquise.sink
                            .add(temFranquised);
                      })),
              titleDescriptionTextField(context, "Nome fantasia",
                  TextEditingController(text: temFranquised.nome),
                  onChange: (text) {
                temFranquised.nome = text;
                landingPageBloc.currentFranquise.sink.add(temFranquised);
              }),
              titleDescriptionTextField(context, "Razão social",
                  TextEditingController(text: temFranquised.razaoSocial),
                  onChange: (text) {
                temFranquised.razaoSocial = text;
                landingPageBloc.currentFranquise.sink.add(temFranquised);
              }),
              Row(
                children: [
                  Expanded(
                    child: titleDescriptionTextField(
                        context, "CNPJ", cnpjController, onChange: (text) {
                      temFranquised.cnpj = text;
                      landingPageBloc.currentIndividual.sink.add(temFranquised);
                    }),
                  ),
                  Expanded(
                    child: titleDescriptionTextField(
                        context, StringFile.telefone, telefoneController,
                        onChange: (text) {
                      temFranquised.telefone = text;
                      landingPageBloc.currentIndividual.sink.add(temFranquised);
                    }),
                  )
                ],
              ),
              titleDescriptionTextField(context, StringFile.email, emailController,
                  onChange: (text) {
                temFranquised.email = text;
                landingPageBloc.currentIndividual.sink.add(temFranquised);
              }),
              titleDescriptionTextField(
                  context, "Nome contato", contactController, onChange: (text) {
                temFranquised.contact = text;
                landingPageBloc.currentIndividual.sink.add(temFranquised);
              }),
              titleDescriptionTextField(context, "CEP", cepController,
                  onChange: (text) {
                landingPageBloc.getAddressByCepIndividual(context, text);
              }),
              Row(
                children: [
                  Expanded(
                    child: titleDescriptionTextField(
                        context, "Endereço", enderecoController,
                        onTap: () {}),
                  ),
                  Expanded(
                    child: titleDescriptionTextField(
                        context, "Cidade", cidadeController,
                        onTap: () {}),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: titleDescriptionTextField(
                        context, "Numero", numberController, onChange: (text) {
                   //   temFranquised?.address.num = text;
                      landingPageBloc.currentIndividual.sink.add(temFranquised);
                    }),
                  ),
                  Expanded(
                    child: titleDescriptionTextField(
                        context, "Complemento", complementController,
                        onChange: (text) {
                    ///  temFranquised?.address.complement = text;
                      landingPageBloc.currentIndividual.sink.add(temFranquised);
                    }),
                  )
                ],
              ),
              Container(
                  margin:
                      EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 20),
                  height: 45,
                  width: double.infinity,
                  child: RaisedButton(
                    color: AppThemeUtils.colorPrimary,
                    onPressed: () {
                      landingPageBloc.solicitateFranquise(context);
                    },
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                    child: Text(
                      'Solicitar',
                      style: TextStyle(
                          color: AppThemeUtils.whiteColor, fontSize: 16),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(4.0),
                        side: BorderSide(
                            color: AppThemeUtils.colorPrimary)),
                  )),
            ],
          ));
}

Widget bodyHomeBased(BuildContext context) {
  var landingPageBloc = Modular.get<LandingPageBloc>();
  var nameController = TextEditingController();
  var cnpjController = TextEditingController();
  var telefoneController = TextEditingController();
  var emailController = TextEditingController();
  var complementController = TextEditingController();
  var numberController = TextEditingController();
  var contactController = TextEditingController();
  var cepController = TextEditingController();
  var cidadeController = TextEditingController();

  var enderecoController = TextEditingController();
  var temFranquised = RegisteFranchise();

  return Column(
    children: [

      Container(
          margin: EdgeInsets.all(10),
          child: Text(
            'CADASTRE SE',
            style: TextStyle(
                color: AppThemeUtils.colorPrimary, fontSize: 18),
          )),
      lineViewWidget(),
      titleDescriptionTextField(context, StringFile.nome, nameController,
          onChange: (text) {
        temFranquised.nome = text;
        landingPageBloc.currentIndividual.sink.add(temFranquised);
      }),
      Row(
        children: [
          Expanded(
            child: titleDescriptionTextField(context, "CNPJ", cnpjController,
                onChange: (text) {
              temFranquised.cnpj = text;
              landingPageBloc.currentIndividual.sink.add(temFranquised);
            }),
          ),
          Expanded(
            child: titleDescriptionTextField(
                context, StringFile.telefone, telefoneController, onChange: (text) {
              temFranquised.telefone = text;
              landingPageBloc.currentIndividual.sink.add(temFranquised);
            }),
          )
        ],
      ),
      titleDescriptionTextField(context, StringFile.email, emailController,
          onChange: (text) {
        temFranquised.email = text;
        landingPageBloc.currentIndividual.sink.add(temFranquised);
      }),
      titleDescriptionTextField(context, "Nome contato", contactController,
          onChange: (text) {
        temFranquised.contact = text;
        landingPageBloc.currentIndividual.sink.add(temFranquised);
      }),
      titleDescriptionTextField(context, "Cep", cepController,
          onChange: (text) {
        landingPageBloc.getAddressByCepIndividual(context, text);
      }),
      Row(
        children: [
          Expanded(
            child: titleDescriptionTextField(
                context, "Endereço", enderecoController,
                onTap: () {}),
          ),
          Expanded(
            child: titleDescriptionTextField(
                context, "Cidade", cidadeController,
                onTap: () {}),
          )
        ],
      ),
      Row(
        children: [
          Expanded(
            child: titleDescriptionTextField(
                context, "Numero", numberController, onChange: (text) {

              landingPageBloc.currentIndividual.sink.add(temFranquised);
            }),
          ),
          Expanded(
            child: titleDescriptionTextField(
                context, "Complemento", complementController, onChange: (text) {

              landingPageBloc.currentIndividual.sink.add(temFranquised);
            }),
          )
        ],
      ),
      Container(
          margin: EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 20),
          height: 45,
          width: double.infinity,
          child: RaisedButton(
            color: AppThemeUtils.colorPrimary,
            onPressed: () {
              landingPageBloc.solicitateFranquiseIndividual(context);
            },
            //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
            child: Text(
              'Solicitar',
              style: TextStyle(color: AppThemeUtils.whiteColor, fontSize: 16),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(4.0),
                side: BorderSide(color: AppThemeUtils.colorPrimary)),
          )),
    ],
  );
}
