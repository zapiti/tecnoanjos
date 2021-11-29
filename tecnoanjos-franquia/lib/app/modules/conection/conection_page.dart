import 'package:tecnoanjos_franquia/app/routes/constants_routes.dart';
import 'package:tecnoanjos_franquia/app/utils/image/image_path.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';


class ConectionPage extends StatefulWidget {

  String message;
  ConectionPage(this.message);

  @override
  _ConectionPageState createState() => _ConectionPageState();
}

class _ConectionPageState extends State<ConectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(  backgroundColor: Colors.white,body:  Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 30,),
            Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Image.asset(
                  ImagePath.imageLostConnection,
                  height: 150,
                  width:  150,

                )),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
          widget.message ??    "Servidor está sem conexão, tente novamente.",
                maxLines: 6,textAlign: TextAlign.center,
                style: AppThemeUtils.normalSize(
                    color: Theme.of(context).textTheme.bodyText1.color),
              ),
            ),
            SizedBox(height: 15,),
            FlatButton(
                onPressed: (){
                  Modular.to.pushReplacementNamed(ConstantsRoutes.SPLASH);
                },
                child: Text(
                  "Atualizar",
                  style: AppThemeUtils.normalSize(
                      color: Theme.of(context).primaryColor),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    side: BorderSide(color: Theme.of(context).primaryColor))),
          ],
        )));
  }
}
