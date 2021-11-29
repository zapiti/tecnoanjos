import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/custom_drop_menu.dart';

import 'package:tecnoanjosclient/app/components/select/select_button.dart';
import 'package:tecnoanjosclient/app/models/pairs.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/model/my_address.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';
import '../../my_address_bloc.dart';

class NewAddressMobileWidget extends StatefulWidget {
  final bool isSimpleNotDismissable;
  final Function(MyAddress) selectedItem;
  final bool hasScroll;
  final bool hideSave;

  NewAddressMobileWidget(
      {this.isSimpleNotDismissable = false,
      this.selectedItem,
      this.hasScroll = false,
      this.hideSave = false});

  @override
  _FormPaymentMobileWidgetState createState() =>
      _FormPaymentMobileWidgetState();
}

class _FormPaymentMobileWidgetState extends State<NewAddressMobileWidget> {
  var myaddressBloc = Modular.get<MyAddressBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(      widget.hideSave ){
      myaddressBloc.controllerTitle.text = "Endereço do cartão";
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isSimpleNotDismissable
        ? _body(context)
        : Scaffold(
            appBar: widget.isSimpleNotDismissable
                ? null
                : AppBar(
                    title: Text(
                        myaddressBloc.tempAdress.stream.value?.id == null
                            ? "Novo endereço"
                            : "Atualização de endereço"),
                    centerTitle: true,
                  ),
            body: ProgressHUD(
                child: widget.hasScroll
                    ? SingleChildScrollView(
                        child: _body(context),
                      )
                    : _body(context)));
  }

  Column _body(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        height: 10,
      ),
      widget.hideSave  ?   Container(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      width: MediaQuery.of(context).size.width,
      child: Text(
      "Endereço de cobrança",
      )):    Container(
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
                    initialItem: myaddressBloc.controllerTitle.text == "Casa"
                        ? 0
                        : myaddressBloc.controllerTitle.text == "Trabalho"
                            ? 1
                            : 0,
                    tapIndex: (i) {
                      myaddressBloc.controllerTitle.text = i?.first ?? "Casa";
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
      Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: TextField(
            inputFormatters: [],
            keyboardType: TextInputType.number,
            controller: myaddressBloc.cepController,
            onChanged: (text) => myaddressBloc.searchCep(text, context),
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                hintText: "Cep",
                border: const OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                  borderSide: BorderSide(color: Colors.grey, width: 0.3),
                )),
          )),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Container(
            child: TextField(
          inputFormatters: [],
          controller: myaddressBloc.streetController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              hintText: "Endereço",
              border: const OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
                borderSide: BorderSide(color: Colors.grey, width: 0.3),
              )),
        )),
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Container(
            child: TextField(
          inputFormatters: [],
          keyboardType: TextInputType.number,
          controller: myaddressBloc.numberController,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              hintText: "Numero",
              border: const OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
                borderSide: BorderSide(color: Colors.grey, width: 0.3),
              )),
        )),
      ),
      Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                    child: TextField(
                  inputFormatters: [],
                  keyboardType: TextInputType.text,
                  enabled: true,
                  controller: myaddressBloc.cityController,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      hintText: "Cidade",
                      border: const OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(color: Colors.grey, width: 0.3),
                      )),
                )),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: 0),
                    child: StreamBuilder<MyAddress>(
                        stream: myaddressBloc.tempAdress,
                        builder: (context, snapshot) => CustomDropMenuWidget(
                            title: null,
                            isExpanded: true,
                            listElements: Utils.listStates,
                            initial: Utils.listStates.firstWhere(
                                (element) => element.first == snapshot.data?.uf,
                                orElse: () => null),
                            controller: myaddressBloc.stateController,
                            onChange: (pairs) {
                              var temp = myaddressBloc.tempAdress.stream.value;
                              temp.uf = pairs.first;
                              myaddressBloc.tempAdress.sink.add(temp);
                            }))

                    // TextField(
                    //   inputFormatters: [],
                    //   keyboardType: TextInputType.text,
                    //   enabled: false,
                    //   controller: myaddressBloc.stateController,
                    //   decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    //       hintText: "Estado",
                    //       border: const OutlineInputBorder(
                    //         borderRadius: const BorderRadius.all(
                    //           const Radius.circular(10.0),
                    //         ),
                    //         borderSide:
                    //         BorderSide(color: Colors.grey, width: 0.3),
                    //       )),
                    // )
                    ),
              )
            ],
          )),
      Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(right: 5),
                    child: TextField(
                      inputFormatters: [],
                      keyboardType: TextInputType.text,
                      controller: myaddressBloc.neighboorhoodController,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          hintText: "Bairro",
                          border: const OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.3),
                          )),
                    )),
              ),
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: 5),
                    child: TextField(
                      inputFormatters: [],
                      keyboardType: TextInputType.text,
                      controller: myaddressBloc.complementController,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          hintText: "Complemento",
                          border: const OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.3),
                          )),
                    )),
              )
            ],
          )),
      widget.hideSave
          ? SizedBox()
          : Container(
              height: 45,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      margin: EdgeInsets.only(left: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            )),
                        onPressed: () {
                          myaddressBloc.saveAddress(
                              context, widget.isSimpleNotDismissable,
                              (selected) {
                            if (widget.selectedItem != null) {
                              widget.selectedItem(selected);
                            }
                          });
                        },
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                        child: Text(
                          myaddressBloc.tempAdress.stream.value?.id == null
                              ? 'Salvar'
                              : "Editar endereço",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              )),
    ]);
  }
}
