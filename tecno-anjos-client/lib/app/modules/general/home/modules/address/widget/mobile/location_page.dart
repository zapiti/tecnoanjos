import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tecnoanjosclient/app/components/credcard/credit_card_widget.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';

import 'package:tecnoanjosclient/app/components/image/image_with_bg_widget.dart';
import 'package:tecnoanjosclient/app/components/select/select_button.dart';
import 'package:tecnoanjosclient/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjosclient/app/models/pairs.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/model/my_address.dart';
import 'package:tecnoanjosclient/app/utils/image/image_path.dart';

import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

import '../../address_bloc.dart';

class LocationPage extends StatelessWidget {
  final addressBloc = Modular.get<AddressBloc>();
  final Function(MyAddress) onSave;
  final String cep;

  LocationPage({this.onSave, this.cep});

  final controllerAddress = TextEditingController();
  final controllerComplement = TextEditingController();
  final controllerRegion = TextEditingController();
  final controllerNeighborhood = TextEditingController();
  final controllerNumber = TextEditingController();
  final controllerTitle = TextEditingController(text: "Minha casa");
  final controllerCep = MaskedTextController(mask: Utils.geMaskCep());
  final controllerUf = TextEditingController();

  final focusAddress = FocusNode();
  final focusComplement = FocusNode();
  final focusRegion = FocusNode();
  final focusNeighborhood = FocusNode();
  final focusNumber = FocusNode();
  final focusTitle = FocusNode();
  final focusCep = FocusNode();
  final focusUf = FocusNode();

  @override
  Widget build(BuildContext context) {
    editData(context);
    loadSeconds(context);
    return SingleChildScrollView(child: buildColumnContent(context));
  }

  void editData(BuildContext context) {
    updateByAdrress(addressBloc.myAddress.stream.value);
    controllerCep.selection = TextSelection.fromPosition(
        TextPosition(offset: controllerCep.text.length));

    controllerCep.addListener(() {
      addressBloc.saveCep(context, Utils.removeMask(controllerCep.text),
          (address) {
        updateByAdrress(address);
      });
    });

    controllerTitle.selection = TextSelection.fromPosition(
        TextPosition(offset: controllerTitle.text.length));

    controllerTitle.addListener(() {
      addressBloc.saveTitle(controllerTitle.text);
    });

    controllerAddress.selection = TextSelection.fromPosition(
        TextPosition(offset: controllerAddress.text.length));
    controllerAddress.addListener(() {
      addressBloc.saveAddres(controllerAddress.text);
    });

    controllerComplement.selection = TextSelection.fromPosition(
        TextPosition(offset: controllerComplement.text.length));

    controllerComplement.addListener(() {
      addressBloc.saveCityComplement(controllerComplement.text);
    });

    controllerRegion.selection = TextSelection.fromPosition(
        TextPosition(offset: controllerRegion.text.length));

    controllerRegion.addListener(() {
      addressBloc.saveCity(controllerRegion.text);
    });

    controllerNeighborhood.selection = TextSelection.fromPosition(
        TextPosition(offset: controllerNeighborhood.text.length));

    controllerNeighborhood.addListener(() {
      addressBloc.saveNeighborhood(controllerNeighborhood.text);
    });
    controllerUf.selection = TextSelection.fromPosition(
        TextPosition(offset: controllerUf.text.length));

    controllerUf.addListener(() {
      addressBloc.saveUf(controllerUf.text);
    });

    controllerNumber.selection = TextSelection.fromPosition(
        TextPosition(offset: controllerNumber.text.length));

    controllerNumber.addListener(() {
      addressBloc.saveNum(controllerNumber.text);
    });
  }

  void updateByAdrress(MyAddress address) {
    controllerNumber.text = address?.num ?? "";
    controllerTitle.text = address?.title ?? "";
    controllerAddress.text = address?.myAddress ?? "";
    controllerComplement.text = address?.complement ?? "";
    controllerRegion.text = address?.nameRegion ?? "";
    controllerNeighborhood.text = address?.neighborhood ?? "";
    controllerCep.text = Utils.removeMask(address?.postal ?? "");

    controllerUf.text = address?.uf ?? "";
  }

  Widget buildColumnContent(BuildContext context) {
    return StatefulWrapper(
        onInit: () {
          loadSeconds(context);
        },
        child: Column(
          children: <Widget>[
            imageWithBgWidget(context, ImagePath.imageMap,
                height: MediaQuery.of(context).size.height * 0.12),
            // Container(
            //     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            //     child: Text(
            //       StringFile.cliqueParaPegarLocalizacao,
            //       style: AppThemeUtils.normalBoldSize(fontSize: 18),
            //     )),
            // Container(
            //   width: 60,
            //   height: 60,
            //   margin: EdgeInsets.only(bottom: 20),
            //   child: ElevatedButton(
            //       color: Theme.of(context).primaryColor,
            //       onPressed: () {
            //         showLoading(true);
            //         Future.delayed(Duration(seconds: 1), () {
            //           showLoading(false);
            //         });
            //
            //         LocationUtils.openLocation(context).then((value) {
            //           if (value != null) {
            //             var address = Utils.addressFormat(value);
            //             controllerAddress.text = address;
            //             addressBloc
            //                 .searchRegionByName(
            //                     context, value, value.subAdminArea)
            //                 .then((region) {
            //               updateByAdrress(region);
            //             });
            //           } else {
            //             showGenericDialog(
            //                 context: context,
            //                 title: StringFile.opps,
            //                 description: StringFile.naoFoiPossivelLocalizacao,
            //                 iconData: Icons.error_outline,
            //                 positiveCallback: () {},
            //                 positiveText: StringFile.ok);
            //           }
            //         });
            //       },
            //       //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
            //       child: Icon(
            //         Icons.add_location,
            //         color: AppThemeUtils.whiteColor,
            //       ),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(30)),
            //           borderSide: BorderSide.none)),
            // ),
            Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(80),
                  ],
                  controller: controllerCep,
                  focusNode: focusCep,
                  onChanged: (text) {
                    // addressBloc.saveCep(context, Utils.removeMask(text), (address) {
                    //   updateByAdrress(address);
                    // });
                  },
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (form) {
                    Utils.fieldFocusChange(context, focusCep, focusTitle);
                  },
                  decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppThemeUtils.colorError),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: StringFile.cep,
                  ),
                )),
            // Container(
            //     margin: EdgeInsets.only(top: 5, bottom: 5),
            //     padding: EdgeInsets.symmetric(horizontal: 20),
            //     child: TextField(
            //       focusNode: focusTitle,
            //       textInputAction: TextInputAction.next,
            //       inputFormatters: [
            //         LengthLimitingTextInputFormatter(20),
            //       ],
            //       onSubmitted: (form) {
            //         Utils.fieldFocusChange(context, focusTitle, focusNumber);
            //       },
            //       controller: controllerTitle,
            //       decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            //         border: RoundedRectangleBorder(
            //             borderSide: BorderSide(color: AppThemeUtils.colorError),
            //             borderRadius: BorderRadius.all(Radius.circular(10))),
            //         labelText: StringFile.descricao,
            //       ),
            //     )),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Center(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              StringFile.descricao,
                            )),
                        SelectButton(
                          initialItem: controllerTitle.text == "Casa"
                              ? 0
                              : controllerTitle.text == "Trabalho"
                                  ? 1
                                  : null,
                          tapIndex: (i) {
                            controllerTitle.text = i?.first ?? "";
                          },
                          title: [
                            Pairs("Casa", "Casa"),
                            Pairs("Trabalho", "Trabalho"),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    )),
              ),
            ),

            Row(
              children: [
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        padding: EdgeInsets.only(right: 5, left: 20),
                        child: TextField(
                          controller: controllerAddress,
                          focusNode: focusAddress,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100),
                          ],
                          onSubmitted: (form) {
                            Utils.fieldFocusChange(
                                context, focusAddress, focusNumber);
                          },
                          decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppThemeUtils.colorError),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            labelText: StringFile.endereco,
                          ),
                        ))),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        padding: EdgeInsets.only(right: 20, left: 5),
                        child: TextField(
                          controller: controllerNumber,
                          focusNode: focusNumber,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(6),
                          ],
                          onSubmitted: (form) {
                            Utils.fieldFocusChange(
                                context, focusNumber, focusComplement);
                          },
                          decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppThemeUtils.colorError),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            labelText: StringFile.numero,
                          ),
                        ))),
              ],
            ),
            Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                  controller: controllerNeighborhood,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppThemeUtils.colorError),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: StringFile.bairro,
                  ),
                )),
            Row(
              children: [
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      padding: EdgeInsets.only(right: 10, left: 20),
                      child: TextField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(80),
                        ],
                        controller: controllerRegion,
                        textInputAction: TextInputAction.next,
                        enabled: false,
                        decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppThemeUtils.colorError),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          labelText: StringFile.cidade,
                        ),
                      )),
                ),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        padding: EdgeInsets.only(right: 20, left: 0),
                        child: TextField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(80),
                          ],
                          controller: controllerUf,
                          textInputAction: TextInputAction.next,
                          enabled: false,
                          decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppThemeUtils.colorError),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            labelText: StringFile.estado,
                          ),
                        ))),
              ],
            ),
            Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: controllerComplement,
                  focusNode: focusComplement,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(20),
                  ],
                  onSubmitted: (form) {
                    getAddressEditOrSave(context);
                  },
                  decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppThemeUtils.colorError),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: StringFile.complemento,
                  ),
                )),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        )),
                    onPressed: () {
                      getAddressEditOrSave(context);
                    },
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                    child: Text(
                      addressBloc.myAddress.stream.value?.id != null
                          ? StringFile.editar
                          : StringFile.salvar,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )))
          ],
        ));
  }

  void loadSeconds(BuildContext context) {
    // controllerCep.clear();
    if ((cep ?? "").isNotEmpty) {
      addressBloc.myAddress.sink.add(MyAddress());
      if (controllerCep.text.isEmpty) {
        controllerCep.text = cep;
      }
      Future.delayed(Duration(seconds: 1), () {
        addressBloc.saveCep(context, Utils.removeMask(controllerCep.text),
            (address) {
          updateByAdrress(address);
        }, ignoreCondition: true);
      });
    }
  }

  void getAddressEditOrSave(BuildContext context) {
    var error;
    var calling = addressBloc.myAddress.stream.value;
    if (calling.postal == null || calling.postal.toString().isEmpty) {
      error = StringFile.cepNaoPodeSerVazio;
    } else if (calling.postal == "00000000" || calling.postal.length < 8) {
      error = StringFile.cepInvalidado;
    } else if (calling.myAddress == null ||
        calling.myAddress.toString().isEmpty) {
      error = StringFile.enderecoNaoPodeSerVazio;
    } else if (calling.title == null || calling.title.toString().isEmpty) {
      error = StringFile.descricaoNaoPodeSerVazio;
    } else if (calling.num == null || calling.num.toString().isEmpty) {
      error = StringFile.numeroNaoPodeSerVazio;
    } else if (calling.neighborhood == null ||
        calling.neighborhood.toString().isEmpty) {
      error = StringFile.bairroNaoPodeSerVazio;
    } else if ((calling.uf?.toString() ?? "").isEmpty) {
      error = StringFile.cepParaIndicarEstado;
    } else if (calling.nameRegion == null ||
        calling.nameRegion.toString().isEmpty) {
      error = StringFile.cepParaIndicarEstado;
    }

    if (error == null) {
      if (calling?.id != null) {
        addressBloc.editarNewAddress(context, this.onSave);
      } else {
        addressBloc.createNewAddress(context, this.onSave);
      }
    } else {
      showGenericDialog(
          context: context,
          title: StringFile.atencao,
          description: "$error",
          iconData: Icons.error_outline,
          positiveCallback: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          positiveText: StringFile.ok);
    }
  }
}
