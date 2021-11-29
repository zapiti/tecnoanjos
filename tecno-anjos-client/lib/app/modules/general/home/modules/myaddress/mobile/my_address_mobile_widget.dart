
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/components/load/load_elements.dart';
import 'package:tecnoanjosclient/app/components/mobile/title_descritption_mobile_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/model/my_address.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/pages/widget/new_my_address_mobile_widget.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import '../my_address_bloc.dart';

class MyAddressMobileWidget extends StatefulWidget {
  final bool isSimpleNotDismissable;

  final bool dismissaAllOnsave;
  final Function(MyAddress p1) selectedItem;

  MyAddressMobileWidget(
      {this.isSimpleNotDismissable = false,
      this.dismissaAllOnsave,
      this.selectedItem});

  @override
  _MyAddressMobileWidgetState createState() => _MyAddressMobileWidgetState();
}

class _MyAddressMobileWidgetState extends State<MyAddressMobileWidget> {
  var myAddressBloc = Modular.get<MyAddressBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MyAddress>>(
        stream: myAddressBloc.listAddressForm,
        builder: (context, snapshot) => snapshot.data == null
            ? loadElements(context)
            : snapshot.data.isEmpty
                ? SingleChildScrollView(child:  Material(
                    child: ProgressHUD(
                        child: NewAddressMobileWidget(
                    isSimpleNotDismissable: true,
                    hasScroll: false,
                    selectedItem: (text) {
                      if (widget.selectedItem != null) {
                        widget.selectedItem(
                            myAddressBloc.selectedAddress.stream.value);
                      }
                    },
                  ))))
                : Column(children: [
                    Expanded(
                        child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (ctx, index) {
                        return Column(
                          children: [
                            index == 0
                                ? Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Selecione seu endereço",
                                          style: AppThemeUtils.normalBoldSize(),
                                        )),
                                        IconButton(
                                            icon: StreamBuilder<bool>(
                                                initialData: false,
                                                stream:
                                                    myAddressBloc.editAddress,
                                                builder: (ctx, snapshot) =>
                                                    !snapshot.data
                                                        ? Icon(
                                                            Icons.edit,
                                                            color: AppThemeUtils
                                                                .darkGrey,
                                                          )
                                                        : Icon(
                                                            Icons.close,
                                                            color: AppThemeUtils
                                                                .darkGrey,
                                                          )),
                                            onPressed: () {
                                              myAddressBloc.editAddress.sink
                                                  .add(!myAddressBloc
                                                      .editAddress
                                                      .stream
                                                      .value);
                                            })
                                      ],
                                    ))
                                : SizedBox(),
                            index == 0 ? lineViewWidget() : SizedBox(),
                            Row(children: [
                              Expanded(
                                  child: titleDescriptionBigMobileWidget(
                                context,
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                                action: () {
                                  if (widget.selectedItem != null) {
                                    widget.selectedItem(snapshot.data[index]);
                                  }
                                  myAddressBloc.setMainAddress(
                                      context, snapshot.data[index], () {
                                    if (widget.isSimpleNotDismissable) {
                                      Navigator.of(context).pop();
                                    }
                                  });
                                },
                                customIcon:
                                    (snapshot.data[index].isMain ?? false)
                                        ? Icon(
                                            Icons.check_circle,
                                            color: AppThemeUtils.colorPrimary,
                                          )
                                        : SizedBox(),
                                title: snapshot.data[index].title,
                                iconData: MaterialCommunityIcons.map,
                                description:
                                    snapshot.data[index].myAddress ?? "",
                              )),
                              StreamBuilder<bool>(
                                  initialData: false,
                                  stream: myAddressBloc.editAddress,
                                  builder: (ctx, snapshotForm) => !snapshotForm
                                          .data
                                      ? SizedBox()
                                      : Column(
                                          children: [
                                            IconButton(
                                                icon: Icon(
                                                  Icons.edit,
                                                  color:
                                                      AppThemeUtils.colorError,
                                                ),
                                                onPressed: () {
                                                  myAddressBloc
                                                      .setEditableAddress(
                                                          snapshot.data[index]);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => Material(
                                                            child: ProgressHUD(
                                                                child:
                                                                    NewAddressMobileWidget()))),
                                                  ).then((element) {
                                                    if (widget.selectedItem !=
                                                        null) {
                                                      widget.selectedItem(
                                                          myAddressBloc
                                                              .selectedAddress
                                                              .stream
                                                              .value);
                                                    }
                                                    if (widget
                                                        .dismissaAllOnsave) {
                                                      Navigator.pop(context);
                                                    }
                                                  });
                                                  // showGenericDialog(
                                                  //   context: context,
                                                  //   title:
                                                  //       StringFile.editarTitle,
                                                  //   description: StringFile
                                                  //       .editarEssseEndereco,
                                                  //   iconData: Icons.error,
                                                  //   positiveCallback: () {
                                                  //
                                                  //   },
                                                  //   negativeCallback: () {},
                                                  //   positiveText:
                                                  //       StringFile.sim,
                                                  //   negativeText:
                                                  //       StringFile.cancelar,
                                                  // );
                                                }),
                                            IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color:
                                                      AppThemeUtils.colorError,
                                                ),
                                                onPressed: () {
                                                  showGenericDialog(
                                                    context: context,
                                                    title: StringFile
                                                        .deletarEnderecoTitle,
                                                    description: StringFile
                                                        .deletarEsteEndereco,
                                                    iconData: Icons.error,
                                                    positiveCallback: () {
                                                      myAddressBloc
                                                          .deleteAddress(
                                                              context,
                                                              snapshot
                                                                  .data[index],
                                                              () {
                                                        if (widget
                                                                .selectedItem !=
                                                            null) {
                                                          widget.selectedItem(
                                                              myAddressBloc
                                                                  .selectedAddress
                                                                  .stream
                                                                  .value);
                                                        }
                                                      });
                                                    },
                                                    negativeCallback: () {},
                                                    positiveText:
                                                        StringFile.sim,
                                                    negativeText:
                                                        StringFile.cancelar,
                                                  );
                                                })
                                          ],
                                        ))
                            ]),
                            lineViewWidget(),
                          ],
                        );
                      },
                    )),

          Container(
              height: 45,
              width: MediaQuery.of(context).size.width,margin: EdgeInsets.all(15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary:
                    Theme
                        .of(context)
                        .primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(4)),
                    )),
                onPressed: () {
                  myAddressBloc.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Material(
                            child: ProgressHUD(
                                child: NewAddressMobileWidget(
                                  hasScroll: true,
                                )))),
                  ).then((element) {
                    if (widget.selectedItem != null) {
                      widget.selectedItem(myAddressBloc
                          .selectedAddress.stream.value);
                    }
                    if (widget.dismissaAllOnsave) {
                      Navigator.pop(context);
                    }
                  });
                },
                //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                child: Text(
                  "Adicionar endereço",
                  style: TextStyle(
                      color: Colors.white, fontSize: 16),
                ),
              )),
             
                  ]));
  }
}
