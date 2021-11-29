import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/builder/builder_component.dart';
import 'package:tecnoanjosclient/app/components/builder/builder_infinity_listView_component.dart';
import 'package:tecnoanjosclient/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/teste/teste_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/teste/widget/item_teste.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';

class TestePage extends StatefulWidget {
  @override
  _TestePageState createState() => _TestePageState();
}

class _TestePageState extends ModularState<TestePage, TesteBloc> {
  @override
  void initState() {
    super.initState();
    controller.getText();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
      childMobile: _layout(),
      childWeb: _layout(),
    );
  }

  Widget _layout() {
    return Column(
      children: [
        Expanded(
            child: Container(
          child: builderComponent<ResponsePaginated>(
              stream: controller.listTeste.stream,
              emptyMessage: "Sem testes cadastrados",
              initCallData: () => controller.getTextList(),
              buildBodyFunc: (context, response) =>
                  builderInfinityListViewComponent(response,
                      callMoreElements: (page) =>
                          controller.getTextList(page: page),
                      buildBody: (content) => ItemTeste(content))),
        )),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text("Salvar"),
              onPressed: () {
                controller.saveText(context, null);
              },
            ))
      ],
    );
  }
}
