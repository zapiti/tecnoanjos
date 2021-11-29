import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_date_time.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjosclient/app/components/select/select_button.dart';
import 'package:tecnoanjosclient/app/models/pairs.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/calling_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/profile_bloc.dart';
import 'package:tecnoanjosclient/app/utils/date_utils.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

import '../../../../../../app_bloc.dart';


class CpfPage extends StatefulWidget {
  final String preNumber;

  CpfPage(this.preNumber);

  @override
  _CpfPageState createState() => _CpfPageState();
}

class _CpfPageState extends State<CpfPage> {
  var controller;
  var controllerDtNasc = TextEditingController();
  var controllerGender = TextEditingController();

  var controllerGenderNamed = TextEditingController();
  var callingBloc = Modular.get<CallingBloc>();
  var errorCpf;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = MaskedTextController(
        mask: Utils.cpfCnpj(widget.preNumber), text: widget.preNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(StringFile.cadastro),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                padding: EdgeInsets.only(
                    bottom: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 0),
                      child: Icon(
                        Icons.web_sharp,
                        color: AppThemeUtils.colorPrimary,
                        size: 80,
                      ),
                    ),
                    Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.8,
                        margin: EdgeInsets.only(
                            right: 10, left: 10, bottom: 20),
                        child: Text(
                          StringFile.vamosFinalizarCadastro,
                          textAlign: TextAlign.center,
                          style: AppThemeUtils.normalSize(fontSize: 18),
                        )),
                    Container(
                      padding: EdgeInsets.only(top: 0, bottom: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(color: Colors.white, width: 1),
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: controller,
                                    onChanged: (text) {
                                      if (text.length >= 14) {
                                        if (!CPF.isValid(text)) {
                                          setState(() {
                                            errorCpf = StringFile.cpfInvalido;
                                          });
                                        } else {
                                          setState(() {
                                            errorCpf = null;
                                          });
                                        }
                                        // showAlterGender(context,
                                        //     controller: controllerGender,
                                        //     controllerNamed:
                                        //         controllerGenderNamed);
                                      } else {
                                        if (errorCpf != null) {
                                          setState(() {
                                            errorCpf = null;
                                          });
                                        }
                                      }
                                    },
                                    decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                        labelText: StringFile.informeCPf,
                                        errorText: errorCpf,
                                        border: const OutlineInputBorder(
                                          borderRadius:
                                          const BorderRadius.all(
                                            const Radius.circular(10.0),
                                          ),
                                          borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 0.3),
                                        )),
                                  )),
                            ),
                          ),
                          // InkWell(
                          //     onTap: () {
                          //       // showAlterGender(context,
                          //       //     controller: controllerGender,
                          //       //     controllerNamed: controllerGenderNamed);
                          //     },
                          //     child:

                          Container(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 0),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          child: Text(
                                            StringFile.informeSeuSexo,
                                          )),
                                      SelectButton(
                                        tapIndex: (i) {
                                          controllerGender.text =
                                              i?.first ?? "";
                                        },
                                        title: [
                                          Pairs("M", "Masculino"),
                                          Pairs("F", "Feminino"),
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          //),
                          InkWell(
                              onTap: () {
                                showNasc(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: controllerDtNasc,
                                        enabled: false,
                                        onChanged: (text) {
                                          if (text.length > 0) {
                                            saveData(context);
                                          }
                                        },
                                        decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                            labelText:
                                            StringFile.informeDtNasc,
                                            border:
                                            const OutlineInputBorder(
                                              borderRadius:
                                              const BorderRadius.all(
                                                const Radius.circular(10.0),
                                              ),
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.3),
                                            )),
                                      )),
                                ),
                              )),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: Container(
                                      height: 45,
                                      margin: EdgeInsets.only(
                                          right: 20,
                                          left: 20,
                                          bottom: 10,
                                          top: 5),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: AppThemeUtils.colorPrimary,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),),

                                          onPressed: () {
                                            saveData(context);
                                          },
                                          child: Text(
                                            StringFile.confirmar,
                                            style: AppThemeUtils.normalBoldSize(
                                              color: AppThemeUtils.whiteColor,
                                            ),
                                          )
                                      ),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ))));
  }

  void saveData(BuildContext context) {
    if (controller.text.length < 11) {
      showGenericDialog(
          context: context,
          title: StringFile.opps,
          description: StringFile.cpfFormatoInvalido,
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else if (!CPF.isValid(controller.text)) {
      showGenericDialog(
          context: context,
          title: StringFile.opps,
          description: StringFile.cpfInvalido,
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else if (controllerGender.text.isEmpty) {
      showGenericDialog(
          context: context,
          title: StringFile.opps,
          description: StringFile.invalidGender,
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else if (controllerDtNasc.text.isEmpty) {
      showGenericDialog(
          context: context,
          title: StringFile.opps,
          description: StringFile.invalidNasc,
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else {
      var profileBloc = Modular.get<ProfileBloc>();
      profileBloc.updateFields(context, {
        'birthDate': controllerDtNasc.text,
        'gender': controllerGender.text,
        'cpf': Utils.removeMask(controller.text),
      }, () {
        callingBloc.hideConfirmButton.sink.add(true);
        Navigator.pop(context, controller.text);
      });
    }
  }

  Future showNasc(BuildContext context) async {
    DialogDateTime.selectDateNasc(context, (date) async {
      if (date != null) {
        var birthDate = MyDateUtils.converStringServer(date, date);
        controllerDtNasc.text =
            MyDateUtils.parseDateTimeFormat(birthDate, Modular
                .get<AppBloc>()
                .dateNowWithSocket
                .stream
                .value);
      }
    });
  }
}
