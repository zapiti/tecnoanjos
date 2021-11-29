
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/utils/image/image_path.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

import 'image/image_with_bg_widget.dart';


class AutoComplete extends StatefulWidget {

  final ValueChanged<bool> changeButton;

  final bool enableLoad;

  AutoComplete( this.changeButton,
      {this.enableLoad = false});

  @override
  _AutoCompleteState createState() => new _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete> {

  bool hideHeader = false;

  TextEditingController controller = new TextEditingController();

  _AutoCompleteState();

  void _loadData() async {

  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTap: () {},
        child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: SingleChildScrollView(
                child: new Column(children: <Widget>[
              hideHeader
                  ? SizedBox()
                  : MediaQuery.of(context).viewInsets.bottom > 0
                      ? SizedBox()
                      : Container(
                          height: 80,
                          child: imageWithBgWidget(
                            context,
                            ImagePath.imageMap,
                          )),
              hideHeader
                  ? SizedBox()
                  : MediaQuery.of(context).viewInsets.bottom > 0
                      ? SizedBox()
                      : Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          child: Text(
                            StringFile.qualRegiao,
                            style: AppThemeUtils.normalBoldSize(fontSize: 24),
                          )),
            ]))));
  }
}
