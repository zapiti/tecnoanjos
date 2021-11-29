
import 'package:flutter/material.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';

import 'dialog/dialog_generic.dart';

class ShowSeeMore extends StatelessWidget {
  String text;
  String title;

  ShowSeeMore(this.text, this.title);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: text == null || text == "null"  ? SizedBox():Container(
            padding: EdgeInsets.all(4.0),
            width: 200.0,
            child: Row(
              children: <Widget>[
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    strutStyle: StrutStyle(fontSize: 12.0),
                    text: TextSpan(
                        style: TextStyle(color: Colors.black), text: text),
                  ),
                ),
                Container(


                  child: FlatButton(

                    onPressed: () {
                      showGenericDialog(context,
                          title: title,
                          description: text, positiveCallback: () {

                          }, positiveText: "ok");
                    },
                    child: Text(
                      'Detalhar',
                      style: TextStyle(color: AppThemeUtils.colorPrimary, fontSize: 16),
                    ),
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide.none),
                  ),
                )
              ],
            )));
  }
}
