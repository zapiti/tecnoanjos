import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tecnoanjostec/app/models/pairs.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';


/// O first é PK
/// O second e o que vai exibir
/// */
class CustomDropMenuWidget extends StatefulWidget {
  final TextEditingController controller;
  final List<Pairs> listElements;
  final String title;
  final bool isExpanded;
  final Function listen;
  final double sized;
  CustomDropMenuWidget(
      {@required this.title,
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
              margin: EdgeInsets.symmetric(horizontal: 0),
              padding: EdgeInsets.only(top: 5, bottom: 0),
              child: Text(
                widget.title,
                maxLines: 1,
                style: AppThemeUtils.normalSize(color: AppThemeUtils.black),
              )),
          SizedBox(
            height: 2,
          ),
          Container(
            height: widget.sized,
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Container(

                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: AppThemeUtils.black)),
                child: DropdownButton<String>(
                  isExpanded: widget.isExpanded ?? false,
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
                      child: Text(
                    widget.controller.text,
                    maxLines: 1,
                  )),
                  selectedItemBuilder: (BuildContext context) {
                    return (widget.listElements ?? []).map<Widget>((item) {
                      return Center(
                          child: Text(
                        item?.second ?? "",
                        maxLines: 1,
                      ));
                    }).toList();
                  },
                  items: (widget.listElements ?? []).map((item) {
                    return DropdownMenuItem<String>(
                      child: Center(
                          child: new Text(
                        item?.second ?? "",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      )),
                      value: item?.first ?? "",
                    );
                  }).toList(),
                ),
              ))
        ]);
  }
}
