import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:tecnoanjos_franquia/app/models/pairs.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';

/// O first é PK
/// O second e o que vai exibir
/// */
class CustomDropMenuWidget extends StatefulWidget {
  final TextEditingController controller;
  final List<Pairs> listElements;
  final String hint;

  final bool isExpanded;
  final Function listen;
  final double sized;
  CustomDropMenuWidget(
      {this.hint,
        @required this.controller,
        @required this.listElements,
        this.isExpanded, this.listen, this. sized});

  @override
  _CustomDropMenuWidgetState createState() => _CustomDropMenuWidgetState();
}

class _CustomDropMenuWidgetState extends State<CustomDropMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              height: 45,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(

                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: AppThemeUtils.black)),
                child: DropdownButton<String>(
                  isExpanded: widget.isExpanded ?? true,
                  underline: SizedBox(),
                  onChanged: (string) {
                    setState(() {
                      widget.controller.text = string;
                    });
                    if(widget.listen != null){
                      widget.listen(string);
                    }
                  },
                  hint: Center(
                      child: AutoSizeText(
                        widget.controller.text.isEmpty ?       widget.hint : widget.controller.text,minFontSize: 6,overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )),
                  selectedItemBuilder: (BuildContext context) {
                    return (widget.listElements ?? []).map<Widget>((item) {
                      return Center(
                          child: AutoSizeText(
                            item?.second ?? "",
                            maxLines: 1,minFontSize: 6,
                          ));
                    }).toList();
                  },
                  items: (widget.listElements ?? []).map((item) {
                    return DropdownMenuItem<String>(
                      child: Center(
                          child:  AutoSizeText(
                            item?.second ?? "",
                            maxLines: 1,
                            textAlign: TextAlign.center,minFontSize: 6,
                          )),
                      value: item?.first ?? "",
                    );
                  }).toList(),
                ),
              ))
        ]);
  }
}
