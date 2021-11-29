


import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/builder/builder_component.dart';
import 'package:tecnoanjosclient/app/components/search/filter.dart';
import 'package:tecnoanjosclient/app/components/search/search_app_bar.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';


import '../../faq_bloc.dart';
import '../faq_builder.dart';

class FaqMobileWidget extends StatelessWidget {
  final _blocFaq = Modular.get<FaqBloc>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: SearchAppBar<String>(
        //   title: Text(StringFile.faq),
        //   searchButtonPosition: 0,
        //   centerTitle: true,
        //   keyboardType: TextInputType.text,
        //   hintText: StringFile.buscar,
        //   filter: Filters.contains,
        //   changeLabel: (value) {
        //     if(value.isEmpty){
        //       _blocFaq.getListFaq();
        //     }else{
        //       _blocFaq.getListSearch(value);
        //     }
        //
        //   },
        //   containsSearch: true,
        //   iconTheme: IconThemeData(color: Theme.of(context).backgroundColor),
        // ),

//
//        AppBar(
//          title: Text("FAQ"),
//        ),
        body: builderComponent<ResponsePaginated>(
            stream: _blocFaq.listFaqStream,
            emptyMessage: StringFile.semfaq,
            initCallData: () => _blocFaq.getListFaq(),
            // tryAgain: () {
            //   _blocFaq.getListFaq();
            // },
            buildBodyFunc: (context, response) =>
                FaqBuilder().buildBodyFaq(context, response)));
  }
}
