import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tecnoanjos_franquia/app/components/builder/builder_component.dart';
import 'package:tecnoanjos_franquia/app/utils/object/map_utils.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';

import 'default_header.dart';
import 'my_data_table_header.dart';
import 'my_responsive_datable.dart';

class ResponsiveTableWeb extends StatelessWidget {
  final String nameTable;
  List<Map<String, dynamic>> _selecteds = List<Map<String, dynamic>>();
  String _sortColumn;
  bool _sortAscending = true;
  final Stream stream;
  final List<MyDatableHeader> listHeader;
  final Function initCallData;
  final Function actionEdit;
  final Function actionDelete;
  final Widget subWidgetHeader;
  final Widget bottomWidgetHeader;
  final bool containsBack;
  final List<Widget> footer;

  ResponsiveTableWeb(
      {this.listHeader,
      this.nameTable,
      this.stream,
      this.initCallData,
      this.actionEdit,
      this.bottomWidgetHeader,
      this.actionDelete,
      this.footer,
      this.subWidgetHeader,
      this.containsBack = false});

  @override
  Widget build(BuildContext context) {
    return builderComponentSimple(
        stream: stream,
        initCallData: () {
          initCallData();
        },
        enableLoad: false,
        buildBodyFunc: (context, result) => Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(0),
                child: Card(
                  elevation: 1,
                  shadowColor: Colors.black,
                  clipBehavior: Clip.none,
                  child: Container(
                      child: MyResponsiveDatable(
                    isBig: bottomWidgetHeader != null,
                    title: nameTable == null
                        ? null
                        : Expanded(
                            child: Column(
                            children: [
                              Container(
                                  child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  containsBack
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.chevron_left,
                                            color: AppThemeUtils.colorPrimary,
                                          ),
                                          onPressed: () {
                                            Modular.to.pop();
                                          })
                                      : SizedBox(),
                                  Expanded(
                                      child: Container(
                                          margin: EdgeInsets.all(30),
                                          child: Text(
                                            nameTable,
                                            style: AppThemeUtils.normalSize(
                                                fontSize: 24,
                                                color: AppThemeUtils.black),
                                          ))),
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: subWidgetHeader)
                                ],
                              )),
                              bottomWidgetHeader ?? SizedBox()
                            ],
                          )),
                    actions: [],
                    headers: DefaultHeader().headersListTableResume(
                        context, listHeader, actionDelete: (row) {
                      actionDelete(row);
                    }, actionEdit: (row) {
                      actionEdit(row);
                    }),
                    source: MapUtils.convertArrayToListMap(result?.content),
                    selecteds: _selecteds,
                    showSelect: false,
                    autoHeight: false,
                    onTabRow: (data) {
                      debugPrint(data);
                    },
                    onSort: (value) {},
                    sortAscending: _sortAscending,
                    sortColumn: _sortColumn,
                    isLoading: result == null,
                    onSelect: (value, item) {},
                    onSelectAll: (value) {},
                    footers: footer,
                  )),
                ),
              ),
            ));
  }
}
