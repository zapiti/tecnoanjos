

import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

Widget getTitleDescriptionOptions(BuildContext context, String title,
    List itensFilter,
    List selectedList, ValueChanged<List> changedPairs) {
  if (itensFilter is List) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.only(top: 0, bottom: 20),
              child: Text(
                title,
                style: AppThemeUtils.normalBoldSize(),
              )),
          Container(

              child: getListStatus(
                  context, itensFilter, selectedList, changedPairs)),
        ]);
  } else {
    return Container();
  }
}

Widget getListStatus(BuildContext context, List itensFilter,
    List selectedList, ValueChanged<List> changedPairs) {
  return Row(
      children: itensFilter
          .map<Widget>((e) {
        var selected = selectedList.firstWhere(
                (element) => element.first.toString() == e.first.toString(),
            orElse: () => null) != null;
        return Expanded(child: titleCheckBox(context,
            intialstate: selected,
            handleChecked: (value) {
              var tempItem = selectedList.firstWhere(
                      (element) =>
                  element.first.toString() == e.first.toString(),
                  orElse: () => null);
              selectedList.clear();
              if (tempItem == null) {
                selectedList.add(e);
              } else {
                selectedList.remove(tempItem);
              }

              changedPairs(selectedList);
            }, title: e.second));
      })
          .toList());
}

Widget titleCheckBox(BuildContext context,
    {bool intialstate = false,
      ValueChanged<bool> handleChecked,
      String title}) {
  return InkWell(
      onTap: () {
        handleChecked(!intialstate);
      },
      child: Container(
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                  width: 24,
                  height: 24,
                  margin: EdgeInsets.only(right: 5),
                  child: Checkbox(
                    value: intialstate,
                    activeColor: Colors.grey[300],
                    checkColor: Theme.of(context).primaryColor,
                    onChanged: handleChecked,
                  )),
              Text(
                title,
                textAlign: TextAlign.start,
                style: AppThemeUtils.normalSize(
                    color: Theme.of(context).textTheme.bodyText2.color),
              ),
            ],
          )
        ]),
      ));
}
