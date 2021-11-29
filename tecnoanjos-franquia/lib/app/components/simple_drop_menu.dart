
import 'package:tecnoanjos_franquia/app/models/current_server.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


Widget simpleDropMenu(
    {CurrentServer selectedElement,
    List listElements,
    String hint = "",
    String title,
    Widget customWidget,
    Color color = Colors.white,
    ValueChanged changeElement,
    bool isExpanded = true}) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 5,
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Container(
              height: 48.0,
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: Colors.grey[300])),
              child: Center(
                  child: DropdownButton<String>(
                isExpanded: isExpanded,
                underline: SizedBox(),
                value: selectedElement?.NOMESERV,
                onChanged: (string) {
                  var currentServer = (listElements ?? []).firstWhere(
                      (element) => element.NOMESERV == string,
                      orElse: () => null);
                  changeElement(currentServer);
                },
                hint: Center(child: customWidget ?? Text(hint ?? "",maxLines: 1,)),
                selectedItemBuilder: (BuildContext context) {
                  return (listElements ?? []).map<Widget>(( item) {
                    return Center(child: Text(item?.NOMESERV ?? "",maxLines: 1,));
                  }).toList();
                },
                items: (listElements ?? []).map(( item) {
                  return DropdownMenuItem<String>(
                    child: Center(
                        child: new Text(
                      item?.NOMESERV ?? "",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    )),
                    value: item?.NOMESERV ?? "",
                  );
                }).toList(),
              )

//                DropdownButton<String>(
//              selectedItemBuilder: ,
//
//                  hint: customWidget ?? Text(hint ?? ""),
//                  items: (listElements ?? []).map((CurrentServer value) {
//                    return new DropdownMenuItem<String>(
//                      value:   value?.NOMESERV ?? "",
//                      child: new Text(
//                        value?.NOMESERV ?? "",
//                        maxLines: 1,
//                      ),
//                    );
//                  }).toList(),
//                  onChanged: (element) {
//
//                  },
//                ),
                  ),
            ))
      ]);
}
