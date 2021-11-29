import 'package:flutter/material.dart';


import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';

import 'my_data_table_header.dart';

class DefaultHeader {
  var isAdd = false;

  List<MyDatableHeader> headersListTableResume(
      BuildContext context, List<MyDatableHeader> listFieldHeader,
      {Function actionEdit, Function actionDelete}) {
//    var constDataSource = MyDatableHeader(
//        text: "Ação",
//        value: "#action",
//        show: true,
//        sortable: true,
//        sourceBuilder: (value, row) {
//          return Flex(
//            direction: Axis.vertical,
//            children: [
//              RaisedButton(
//                color: AppThemeUtils.colorPrimary,
//                onPressed: () {
//                  actionEdit(row);
//                },
////Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
//                child: Text(
//                  'Editar',
//                  style: TextStyle(color: Colors.white, fontSize: 16),
//                ),
//                shape: OutlineInputBorder(
//                    borderRadius: BorderRadius.all(Radius.circular(8)),
//                    borderSide: BorderSide.none),
//              ),
//              RaisedButton(
//                color: AppThemeUtils.colorError,
//                onPressed: () {
//                  actionDelete(row);
//                },
////Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
//                child: Text(
//                  'Deletar',
//                  style: TextStyle(color: Colors.white, fontSize: 16),
//                ),
//                shape: OutlineInputBorder(
//                    borderRadius: BorderRadius.all(Radius.circular(8)),
//                    borderSide: BorderSide.none),
//              )
//            ],
//          );
//        },
//        textAlign: TextAlign.center);
//
//    listFieldHeader.last = constDataSource;
    return listFieldHeader;
  }
}
