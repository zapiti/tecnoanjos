import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import '../../start_called_bloc.dart';

class StageFinish extends StatelessWidget {
  final startCalledBloc = Modular.get<StartCalledBloc>();
  final Attendance attendance;

  StageFinish(this.attendance);

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
            child: Column(children: <Widget>[
      Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Image.asset(ImagePath.imagePlay)),
      Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: RichText(
              text: TextSpan(
            text: " O Tecnoanjo ${attendance.userTecno?.id} ",
            style: AppThemeUtils.normalBoldSize(
                fontSize: 26,
                color: Theme.of(context).textTheme.bodyText1.color),
            children: <TextSpan>[
              TextSpan(
                  text:
                      "esta aguardando sua validação para finalizar o atendimento",
                  style: AppThemeUtils.normalSize(fontSize: 24)),
            ],
          ))),
      StreamBuilder(
          stream: startCalledBloc.hideButton,
          initialData: false,
          builder: (context, snapshot) => snapshot.data == true
              ? SizedBox()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Container(
                      margin: EdgeInsets.all(15),
                      child: Center(child: ConfirmationSlider(
                        width: MediaQuery.of(context).size.width > 400 ? 400 : MediaQuery.of(context).size.width - 50,

                        foregroundColor: AppThemeUtils.colorPrimary,height: 60,backgroundColorEnd: AppThemeUtils.colorPrimary,
                        onConfirmation: () {
                          startCalledBloc.finishAttendance(
                              context, attendance, () {});
                        },
                      text :
                          "Finalizar atendimento",

                      ))))),
      SizedBox(
        height: 30,
      ),
    ]));
  }
}
