import 'package:flutter/material.dart';

import '../../table_money_bloc.dart';

Widget tableMoneyWebPageWidget(TableMoneyBloc tableMoneyBloc) {
  return LayoutBuilder(builder: (context, constraint) {
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
        child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
                child: Flex(
              direction: width > 1400 ? Axis.horizontal : Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Container(
                  margin: EdgeInsets.all(10),
                  child: tableMoneyWebPageWidget(tableMoneyBloc),
                )),
                Expanded(
                    child: Container(
                        margin: width > 1400
                            ? EdgeInsets.only(top: 10, right: 20)
                            : EdgeInsets.all(10),
                        child: tableMoneyWebPageWidget(tableMoneyBloc)))
              ],
            ))));
  });
}
