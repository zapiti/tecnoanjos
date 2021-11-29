import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_shifter/mask_shifter.dart';
import 'package:tecnoanjos_franquia/app/components/button/button_filled_web_widget.dart';
import 'package:tecnoanjos_franquia/app/components/button/button_outline_web_widget.dart';
import 'package:tecnoanjos_franquia/app/components/card/card_web_widget.dart';
import 'package:tecnoanjos_franquia/app/components/custom/custom_drop_menu.dart';
import 'package:tecnoanjos_franquia/app/components/custom/custom_flex_widget.dart';
import 'package:tecnoanjos_franquia/app/components/custom/title_description_text_form_field_widget.dart';
import 'package:tecnoanjos_franquia/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjos_franquia/app/components/load/load_view_element.dart';
import 'package:tecnoanjos_franquia/app/components/select/select_button.dart';
import 'package:tecnoanjos_franquia/app/models/current_user.dart';
import 'package:tecnoanjos_franquia/app/models/pairs.dart';
import 'package:tecnoanjos_franquia/app/modules/login/models/auth/local_user.dart';
import 'package:tecnoanjos_franquia/app/modules/search/search_page.dart';
import 'package:tecnoanjos_franquia/app/modules/tecno/model/profile.dart';
import 'package:tecnoanjos_franquia/app/modules/tecno/tecno_bloc.dart';
import 'package:tecnoanjos_franquia/app/utils/date_utils.dart';
import 'package:tecnoanjos_franquia/app/utils/object/object_utils.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjos_franquia/app/utils/utils.dart';
import 'package:universal_html/html.dart';

import '../../../../app_bloc.dart';

class TecnoRegistrationPageWidget extends StatelessWidget {
  TecnoRegistrationPageWidget({this.profile}) {
    tecnoBloc.listAddress.sink.add([]);
    if (profile != null) {
      _emailController.text = profile.email;
      _cpfController.text = profile.cpf;
      _phoneController.text = profile.telephone;
      _nameCorpController.text = profile.name;
      _genderController.text = profile.gender;
      _dateNascimentController.text =  MyDateUtils.parseDateTimeFormat(profile.birthDate) ;
      //  _roleController.text = previewUsers.role;

      if (profile.cityAttendance.isNotEmpty) {

        tecnoBloc.listAddress.sink.add(profile.cityAttendance
            ?.map<Pairs>((e) =>
            Pairs(
                "${e.name}-${e.state.name}", e.name,
                third: e.state.name))
            ?.toList() ??
            []);
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

  final List<TextInputFormatter> _maskCpfCnpj = [
    MaskedTextInputFormatterShifter(
        maskONE: "XXX.XXX.XXX-XX", maskTWO: "XXX.XXX.XXX-XX"),
    FilteringTextInputFormatter.allow(RegExp(r'[0-9\-\.\/]'))
  ];

  // final TextEditingController _nameFantasiaController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cpfController =
  MaskedTextController(mask: Utils.cpfCnpj(""));
  final _dateNascimentController = MaskedTextController(mask: "00/00/0000");

  final TextEditingController _nameCorpController = TextEditingController();

  final TextEditingController _phoneController =
  MaskedTextController(mask: '(00)00000-0000');

  //
  // final TextEditingController _roleController =
  // TextEditingController(text: LocalUser.ADMIN);
  //

  final Profile profile;

  final tecnoBloc = Modular.get<TecnoBloc>();

  @override
  Widget build(BuildContext context) {
    return CardWebWidget(
        title: profile?.id == null ? "Novo TecnoAnjo" : "Alterar TecnoAnjo",
        child: LoadViewElement(child:  SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    // TitleDescriptionTextFormFieldWidget(
                    //     title: "Nome Fantasia",
                    //     controller: _nameFantasiaController,
                    //     validator: (value) {
                    //       if (value.isEmpty) {
                    //         return "Obrigatório";
                    //       }
                    //
                    //       return null;
                    //     }),
                    TitleDescriptionTextFormFieldWidget(
                        title: "Nome",
                        controller: _nameCorpController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Obrigatório";
                          }

                          return null;
                        }),

                    TitleDescriptionTextFormFieldWidget(
                        title: "E-mail",
                        controller: _emailController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Obrigatório";
                          }

                          return null;
                        }),
                    CustomFlexWidget(children: [
                      Column(
                        children: [
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 0),
                              padding: EdgeInsets.only(top: 5, bottom: 0),
                              child: Text(
                                "Sexo",
                                maxLines: 1,
                                style: AppThemeUtils.normalSize(
                                    color: AppThemeUtils.black),
                              )),
                          SelectButton(
                            initialItem: _genderController.text == "F"
                                ? 1
                                : _genderController.text == "M"
                                ? 0
                                : null,
                            tapIndex: (i) {
                              _genderController.text = i?.first ?? "";
                            },
                            title: [
                              Pairs("M", "Masculino"),
                              Pairs("F", "Feminino"),
                            ],
                          ),
                        ],
                      ),
                      TitleDescriptionTextFormFieldWidget(
                          title: "Data nascimento ",
                          controller: _dateNascimentController,
                          keyboard: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Obrigatório";
                            }

                            return null;
                          }),
                    ]),
                    CustomFlexWidget(children: [
                      TitleDescriptionTextFormFieldWidget(
                          title: "Telefone ",
                          controller: _phoneController,
                          keyboard: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Obrigatório";
                            }

                            return null;
                          }),
                      TitleDescriptionTextFormFieldWidget(
                          title: "CPF",
                          controller: _cpfController,
                          masks: _maskCpfCnpj,
                          // sizeForFlex: BoxConstraints(maxWidth: 350),
                          keyboard: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Obrigatório";
                            }

                            // if (value.length < 14) {
                            //   return "CPF deve possuir 14";
                            // }

                            return null;
                          }),
                    ]),SizedBox(height: 40,),
                    CustomFlexWidget(children: [
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          padding: EdgeInsets.only(top: 5, bottom: 0),
                          child: Text(
                            "Regiões de atendimento",
                            maxLines: 1,
                            style: AppThemeUtils.normalSize(
                                color: AppThemeUtils.black),
                          )),
                      ButtonOutlineWebWidget(
                          text: "+Adicionar região para atendimento presencial",
                          onPressed: () {
                            goToFilter(tecnoBloc.getListAvaliableAddress(),
                                "Região de atendimento")
                                .then((value) {
                              if (value != null) {
                                var listElementes =
                                    tecnoBloc.listAddress.stream.value;
                                if(listElementes.firstWhere(
                                        (element) => element.first == value.first && element.second == value.second,
                                    orElse: () => null) == null){
                                  listElementes.add(value);
                                  tecnoBloc.listAddress.sink.add(listElementes);
                                }

                              }
                            });
                          })
                    ]),lineViewWidget(top: 10,bottom: 5),
                    StreamBuilder<List<Pairs>>(
                        stream: tecnoBloc.listAddress,
                        initialData: [],
                        builder: (context, snapshot) {
                          return snapshot.data.isNotEmpty
                              ? Column(children: snapshot.data.map((e) =>
                             Container(child:  Column(children: [  CustomFlexWidget(
                                children: [
                                  Container(
                                    color:Colors.blue[100],
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15,vertical: 15),

                                      child: Text(
                                        "${e.second}-${e.third}",
                                        maxLines: 1,
                                        style: AppThemeUtils.normalSize(
                                            color: AppThemeUtils.black),
                                      )),
                                 Center(child:  ElevatedButton(style: ElevatedButton.styleFrom(primary: AppThemeUtils.colorPrimary),
                                      child:Text("remover região",style: AppThemeUtils.normalSize(color: AppThemeUtils.whiteColor),) ,
                                      onPressed: () {
                                        var listElementes =
                                            snapshot.data;
                                        listElementes.remove(e);
                                        tecnoBloc.listAddress.sink
                                            .add(listElementes);
                                      })),
                                ],
                              ),lineViewWidget(top: 5,bottom: 5)]))).toList(),)

                              : SizedBox();
                        })
                  ,SizedBox(height: 40,),
                    // CustomFlexWidget(
                    //   children: [
                    //     profile != null
                    //         ? Container()
                    //         : TitleDescriptionTextFormFieldWidget(
                    //         title: "Senha",
                    //         controller: tecnoBloc.passController,
                    //         obscure: true,
                    //         masks: [
                    //           // FilteringTextInputFormatter.allow(
                    //           //     RegExp(r'[a-z0-9]'))
                    //         ],
                    //         validator: profile == null
                    //             ? (value) {
                    //           if (value.isEmpty) {
                    //             return "Obrigatório";
                    //           }
                    //
                    //           return null;
                    //         }
                    //             : null),
                    //     profile != null
                    //         ? Container()
                    //         : TitleDescriptionTextFormFieldWidget(
                    //         title: "Confirmação de Senha",
                    //         controller: tecnoBloc.confirmPassController,
                    //         obscure: true,
                    //         masks: [
                    //           // FilteringTextInputFormatter.allow(
                    //           //     RegExp(r'[a-z0-9]'))
                    //         ],
                    //         validator: profile == null
                    //             ? (value) {
                    //           if (value.isEmpty) {
                    //             return "Obrigatório";
                    //           }
                    //
                    //           return null;
                    //         }
                    //             : null),
                    //   ],
                    // ),
                    // CustomDropMenuWidget(
                    //   controller: _roleController,
                    //   title: "Acesso",
                    //   listElements: [
                    //
                    //     Pairs(LocalUser.ADMIN, "Admin do sistema"),
                    //     Pairs(LocalUser.USER, "Usuário do sistema"),
                    //   ],
                    // ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ButtonOutlineWebWidget(
                            text: "Cancelar",
                            onPressed: () {
                              Modular.to.pop();
                            }),
                        Expanded(
                            child: ButtonFilledWebWidget(
                                text: profile == null
                                    ? "Salvar Tecnoanjo"
                                    : "Alterar Tecnoanjo",
                                onPressed: () {
                                  if (!_formKey.currentState.validate()) {
                                    return;
                                  }

                                  Profile users;
                                  if (profile == null) {
                                    users = Profile();
                                  } else {
                                    users = profile;
                                  }
                                  final _appBloc = Modular.get<AppBloc>();
                                  final currentUser = _appBloc
                                      .getCurrentUserFutureValue()
                                      .stream
                                      .value;
                                  print(currentUser?.toMap());

                                  users.name = _nameCorpController.text;
                                  users.email = _emailController.text;
                                  users.birthDate =
                                      _dateNascimentController.text;
                                  users.gender = _genderController.text;
                                  users.cpf =
                                      Utils.removeMask(_cpfController.text);
                                  users.telephone =
                                      Utils.removeMask(_phoneController.text);

                                  users.franchiseId =
                                      currentUser?.id?.toString();
                                  users.role = CurrentUser.FUNCIONARY;
                                  // users.password =
                                  //     tecnoBloc.passController.text;

                                  tecnoBloc.save(
                                      context, profile == null, users);
                                })),
                      ],
                    )
                    ,SizedBox(height: 15,)
                  ]),
                )))));
  }

  bool isValid(BuildContext context) {
    // if (_passwordController.text != _confirmPasswordController.text) {
    //   showGenericDialog(
    //       context: context,
    //       iconData: Icons.info,
    //       title: "Atenção",
    //       description:
    //           "O campo 'Senha' e 'Confirmação de Senha' devem ser iguais",
    //       positiveCallback: () {
    //         Navigator.pop(context);
    //       },
    //       positiveText: "OK");
    //
    //   return false;
    // }

    return true;
  }
}
