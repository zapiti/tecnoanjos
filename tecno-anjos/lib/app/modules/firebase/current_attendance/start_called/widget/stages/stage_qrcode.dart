import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tecnoanjostec/app/components/atendimento/center_view_attendance.dart';
import 'package:tecnoanjostec/app/components/atendimento/view_atendimento.dart';
import 'package:tecnoanjostec/app/components/not_init_now/not_init_now.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';

import 'package:tecnoanjostec/app/utils/image/image_path.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

import '../../../../../../app_bloc.dart';
import '../../current_attendance_bloc.dart';



class StageQrCode extends StatelessWidget {
  final Attendance attendance;
  final currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();

  StageQrCode(this.attendance);

  @override
  Widget build(BuildContext context) {
    return attendance.status == ActivityUtils.NAO_AGUARDO_QR
        ? _SimplePage(attendance, currentBloc)
        : _PageGenerateQrcode(
        ActivityUtils.convertQrCode(attendance), attendance);
  }
}

class _SimplePage extends StatelessWidget {
  _SimplePage(this.attendance, this.currentAttendanceBloc);

  final Attendance attendance;
  final MyCurrentAttendanceBloc currentAttendanceBloc;

  @override
  Widget build(BuildContext context) {
    return ViewAttendanceWidget(
        childTop: null,
        childCenter: CenterViewAttendance(image: ImagePath.inAttendance,
            title: StringFile.aguardarValidacao ,subtitle: Column(children: [

            Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Text(StringFile.assimQueAprovado,
            textAlign: TextAlign.center,
            style: AppThemeUtils.normalSize(
                fontSize: 20, color: AppThemeUtils.colorPrimary))),
    buildNotInitNow(context, attendance, currentAttendanceBloc),
    SizedBox(
    height: 110,
    ),
    ])));
  }
}

class _PageGenerateQrcode extends StatelessWidget {
  final qrdataFeed = TextEditingController();
  final String qrCode;

  final Attendance attendance;

  _PageGenerateQrcode(this.qrCode, this.attendance);

  final appBar = Modular.get<AppBloc>();
  final currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();

  @override
  Widget build(BuildContext context) {
    return ViewAttendanceWidget(
        childTop: Center(
          child: Container(
            height: 80,
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "",
                  style: AppThemeUtils.normalBoldSize(
                      fontSize: 26,
                      color: Theme
                          .of(context)
                          .textTheme
                          .bodyText1
                          .color),
                  children: <TextSpan>[
                    TextSpan(
                        text: StringFile.pecaParaValidar,
                        style: AppThemeUtils.normalSize(fontSize: 22)),
                  ],
                )),
          ),
        ),
        childCenter: CenterViewAttendance(subtitle:  Column(
          children: <Widget>[

            Container(
                width: 180,
                height: 180,
                child: QrImage(
                  //plce where the QR Image will be shown
                  data: qrCode,
                )),
            buildNotInitNow(context, attendance, currentBloc),
            SizedBox(
              height: 40.0,
            ),
          ],
        )));
  }
}
