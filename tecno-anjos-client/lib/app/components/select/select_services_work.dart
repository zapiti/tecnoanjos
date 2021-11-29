import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tecnoanjosclient/app/models/pairs.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/model/service_prod.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

class SelectServicesWork extends StatefulWidget {
  final Pairs elements;
  final BehaviorSubject<List<ServiceProd>> selectProdSubject;

  SelectServicesWork({this.selectProdSubject, this.elements});

  @override
  _SelectServicesWorkState createState() => _SelectServicesWorkState();
}

class _SelectServicesWorkState extends State<SelectServicesWork> {
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ServiceProd>>(
        initialData: [],
        stream: widget.selectProdSubject,
        builder: (context, snapshot) => Container(
                child: Column(
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        expanded = !expanded;
                      });
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                              margin: EdgeInsets.all(10),
                              child: Text(
                                widget.elements.first,
                                style: AppThemeUtils.normalBoldSize(),
                              ),
                            )),
                            Utils.getCountByPairs(
                                        widget.elements, snapshot.data) ==
                                    0
                                ? SizedBox()
                                : Container(
                                    padding: EdgeInsets.all(6),
                                    child: Text(
                                      Utils.getCountByPairs(
                                              widget.elements, snapshot.data)
                                          .toString(),
                                      style: AppThemeUtils.normalSize(
                                          color: AppThemeUtils.whiteColor,
                                          fontSize: 12),
                                    ),
                                    decoration: BoxDecoration(
                                        color: AppThemeUtils.colorPrimary,
                                        shape: BoxShape.circle)),
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Icon(
                                !expanded
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_up_outlined,
                                color: AppThemeUtils.black,
                              ),
                            )
                          ],
                        ))),
                !expanded
                    ? SizedBox()
                    : Column(
                        children: widget.elements.second
                            .map<Widget>((item) => _CheckBoxService(
                                  serviceProd: (snapshot.data ?? []).firstWhere(
                                      (element) =>
                                          item.name == element.name &&
                                          item.id == element.id,
                                      orElse: () => item),
                                  handleChecked: (selected) {
                                    final list = snapshot.data ?? [];
                                    final tempElement = list.firstWhere(
                                        (element) =>
                                            selected.name == element.name &&
                                            selected.id == element.id,
                                        orElse: () => null);

                                    final index =
                                        list.indexOf(tempElement) ?? -1;
                                    if (index >= 0) {
                                      list.removeAt(index);
                                      selected.selected = false;
                                      widget.selectProdSubject.sink.add(list);
                                    } else {
                                      selected.selected = true;
                                      list.add(selected);

                                      widget.selectProdSubject.sink.add(list);
                                    }
                                  },
                                ))
                            .toList())
              ],
            )));
  }
}

class _CheckBoxService extends StatelessWidget {
  final ValueChanged<ServiceProd> handleChecked;

  final ServiceProd serviceProd;

  _CheckBoxService({this.handleChecked, this.serviceProd});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          handleChecked(serviceProd);
        },
        child: Container(
          padding: EdgeInsets.all(20),
          color: (serviceProd.selected ?? false)
              ? AppThemeUtils.colorPrimaryLigth
              : AppThemeUtils.whiteColor,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: 24,
                        height: 24,
                        margin: EdgeInsets.only(right: 5),
                        child: Checkbox(
                          value: serviceProd.selected ?? false,
                          activeColor: AppThemeUtils.colorPrimary,
                          checkColor: AppThemeUtils.whiteColor,
                          onChanged: (selected) {
                            handleChecked(serviceProd);
                          },
                        )),
                    Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                serviceProd.name,
                                textAlign: TextAlign.start,
                                style:
                                    AppThemeUtils.normalBoldSize(fontSize: 14),
                              )),
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                serviceProd.description,
                                textAlign: TextAlign.start,
                                style: AppThemeUtils.normalSize(fontSize: 14),
                              ))
                        ])),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          MoneyMaskedTextController(
                                  initialValue: serviceProd.price,
                                  leftSymbol: "R\$")
                              .text,
                          style: AppThemeUtils.normalBoldSize(fontSize: 14),
                        ))
                  ],
                )
              ]),
        ));
  }
}
