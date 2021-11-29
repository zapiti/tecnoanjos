import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/components/image/image_with_bg_widget.dart';
import 'package:tecnoanjosclient/app/utils/amplitude/amplitude_util.dart';
import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class IntroRegistrePage extends StatefulWidget {
  @override
  _IntroRegistrePageState createState() => _IntroRegistrePageState();
}

class _IntroRegistrePageState extends State<IntroRegistrePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AmplitudeUtil.createEvent(AmplitudeUtil.eventoCadastroDeUsuario(1));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      imageWithBgWidget(context, ImagePath.imageAureula),
      Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Text("Sobre a Tecnoanjos",
              style: AppThemeUtils.normalBoldSize(
                  color: AppThemeUtils.black, fontSize: 28))),
      Container(
          width: MediaQuery.of(context).size.width * 0.8,
          margin: EdgeInsets.only(right: 10, left: 10),
          child: Text(
            "",
            textAlign: TextAlign.center,
            style: AppThemeUtils.normalSize(fontSize: 18),
          )),
    ]);
  }
}
