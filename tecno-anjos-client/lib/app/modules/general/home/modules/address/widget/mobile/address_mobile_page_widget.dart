import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/components/builder/builder_component.dart';
import 'package:tecnoanjosclient/app/components/load/load_elements.dart';
import 'package:tecnoanjosclient/app/components/page/default_tab_page.dart';
import 'package:tecnoanjosclient/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/address/address_bloc.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/model/my_address.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';

import '../address_builder.dart';
import 'location_page.dart';

Widget addressMobilePageWidget(AddressBloc addressBloc, bool hidePrefix,
    {Function(MyAddress) addressSave,
    Function(MyAddress) selectedItem,
    String cep = ""}) {
  return AddressMobileContentWidget(addressBloc, hidePrefix, null,
      addressSave: addressSave, selectedItem: selectedItem, cep: cep);
}

TabController _tab;

class AddressMobileContentWidget extends StatefulWidget {
  final AddressBloc addressBloc;
  final bool hidePrefix;
  final Function(bool) removeElement;
  final Function selectedItem;
  final Function(MyAddress) addressSave;
  final String cep;

  AddressMobileContentWidget(
      this.addressBloc, this.hidePrefix, this.removeElement,
      {this.selectedItem, this.addressSave, this.cep = ""});

  @override
  _AddressMobileContentWidgetState createState() =>
      _AddressMobileContentWidgetState();
}

class _AddressMobileContentWidgetState
    extends State<AddressMobileContentWidget> {
  MyAddress address;

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: () {
          widget.addressBloc.getListAddress();
        },
        child: StreamBuilder<bool>(
            stream: widget.addressBloc.hideListAddress,
            builder: (context, snapshot) => snapshot.data == null
                ? loadElements(context)
                : snapshot.data
                    ? SingleChildScrollView(
                        child: LocationPage(
                            cep: widget.cep,
                            onSave: (address) {
                              _tab?.animateTo(0);
                            }))
                    : DefaultTabPage(
                        _tab,
                        title: [
                          StringFile.enderecoCadastrado,
                          StringFile.novoEndereco,
                        ],
                        tapIndex: (index) {
                          widget.addressBloc.myAddress.sink.add(MyAddress());
                          if (widget.removeElement != null) {
                            widget.removeElement(_tab.index == 1);
                          }
                        },
                        neverScroll: NeverScrollableScrollPhysics(),
                        changeTab: (tabController) {
                          _tab = tabController;
                        },
                        page: [
                          Column(
                            children: [
                              Expanded(
                                  child: builderComponent<ResponsePaginated>(
                                      stream: widget
                                          .addressBloc.listAddressInfo.stream,
                                      emptyMessage:
                                          StringFile.semEnderecoCadastrado,
                                      initCallData: () => {},
                                      buttomText:
                                          StringFile.cliqueParaCadastrar,
                                      // tryAgain: () {
                                      //   _tab?.animateTo(1);
                                      // },
                                      onEmptyAction: () {
                                        _tab?.animateTo(1);
                                      },
                                      buildBodyFunc: (context, response) {
                                        if ((response.content ?? []).isEmpty) {
                                          _tab?.animateTo(1);
                                        }
                                        return AddressBuilder()
                                            .buildBodyAddress(
                                                context,
                                                response,
                                                widget.addressBloc,
                                                _tab,
                                                widget.hidePrefix,
                                                actionEdit: () {},
                                                selectedItem: (addr) {
                                          if (widget.addressSave != null) {
                                            address = (addr);
                                          }
                                          if (widget.selectedItem != null) {
                                            widget.selectedItem(addr);
                                          }
                                        });
                                      })),
                              widget.addressSave == null
                                  ? SizedBox()
                                  : Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 45,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 15),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Theme.of(context)
                                                  .primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                              )),
                                          onPressed: () {
                                            if (widget.addressSave != null) {
                                              widget.addressSave(address);
                                            }
                                          },
                                          //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                          child: Text(
                                            StringFile.selecionar,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          )))
                            ],
                          ),
                          LocationPage(
                              cep: widget.cep,
                              onSave: (address) {
                                if (widget.addressSave != null) {
                                  widget.addressSave(address);
                                }
                                _tab?.animateTo(0);
                              }),
                        ],
                      )));
  }
}
