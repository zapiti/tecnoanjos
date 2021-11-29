import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjos_franquia/app/components/card/card_web_widget.dart';
import 'package:tecnoanjos_franquia/app/modules/tecno/model/profile.dart';
import 'package:tecnoanjos_franquia/app/modules/tecno/widget/table/tecno_table.dart';
import 'package:tecnoanjos_franquia/app/routes/constants_routes.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';

class TecnoWidget extends StatefulWidget {
  @override
  _TecnoWidgetState createState() => _TecnoWidgetState();
}

class _TecnoWidgetState extends State<TecnoWidget> {
  @override
  Widget build(BuildContext context) {
    return CardWebWidget(title: "Tecnoanjos",
      child: TecnoTable(),
      subTitle: Container(width: MediaQuery
          .of(context)
          .size
          .width,margin: EdgeInsets.all(10), child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
        FlatButton(
            onPressed: () {

              Modular.to.pushNamed(ConstantsRoutes.CALL_NOVO_TECNICO,arguments: null);
            },
            child: Text(
              "NOVO TECNOANJO",
              style: AppThemeUtils.normalSize(
                  color: Theme
                      .of(context)
                      .primaryColor),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(7.0),
                side: BorderSide(color: Theme
                    .of(context)
                    .primaryColor)))
      ],),),);
  }
}
