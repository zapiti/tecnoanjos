import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:tecnoanjosclient/app/components/atendimento/center_view_attendance.dart';
import 'package:tecnoanjosclient/app/components/atendimento/view_atendimento.dart';
import 'package:tecnoanjosclient/app/components/not_init_now/not_init_now.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/my_current_attendance_bloc.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/utils/attendance/activity_utils.dart';
import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import '../../start_called_bloc.dart';

class StageQrCode extends StatelessWidget {
  final Attendance attendance;

  StageQrCode(this.attendance);

  @override
  Widget build(BuildContext context) {
    return PageGenerateQrcode(attendance);
  }
}

class PageGenerateQrcode extends StatefulWidget {
  final Attendance attendance;

  PageGenerateQrcode(this.attendance);

  @override
  _PageGenerateQrcodeState createState() => _PageGenerateQrcodeState();
}

class _PageGenerateQrcodeState extends State<PageGenerateQrcode> {
  final controllerPendency = TextEditingController();
  var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // getPermissionsStatus(context);
    });
  }

  getPermissionsStatus(BuildContext context) async {
    // var permissionStatus =
    // await Permission.getPermissionsStatus([permissionName]);
    // if (permissionStatus.first.permissionStatus != PermissionStatus.allow) {
    //   var permissions2 = await Permission.requestPermissions([permissionName]);
    //   if (permissions2.first.permissionStatus != PermissionStatus.allow) {
    //     showGenericDialog(
    //         context: context,
    //         title: "Ops!!!",
    //         description:
    //         "Para continuar voce precisa liberar permissão da camera",
    //         iconData: Icons.error_outline,
    //         positiveText: "Permitir",
    //         positiveCallback: () {
    //
    //           Permission.openSettings();
    //         },
    //         negativeCallback: () {
    //
    //         },
    //         negativeText: "Cancelar");
    //   } else {
    //     // setState(() {
    //     //   isOk = true;
    //     // });
    //   }
    // } else {
    //   // setState(() {
    //   //   isOk = true;
    //   // });
    // }
  }

  @override
  Widget build(BuildContext context) {
    var startCalledBloc = Modular.get<StartCalledBloc>();

    return ViewAttendanceWidget(
      childTop: null,
      childCenter:CenterViewAttendance(
        image:       widget.attendance?.status == ActivityUtils.NAO_AGUARDO_QR
            ? ImagePath.imageAureula
            : ImagePath.imageQrCode,
        title: widget.attendance?.status == ActivityUtils.NAO_AGUARDO_QR
            ? "Seu Tecnoanjo está aguardando"
            : '',
        subtitle: Column(children: <Widget>[
        Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.attendance?.status == ActivityUtils.NAO_AGUARDO_QR
                      ? "Deslize o botão a baixo para iniciar o atendimento"
                      : 'Para iniciar o atendimento, tire uma foto do QRCODE do celular do técnico',
                  style: AppThemeUtils.normalBoldSize(fontSize: 22),
                  textAlign: TextAlign.center,
                )
              ],
            )),
        widget.attendance?.status == ActivityUtils.NAO_AGUARDO_QR
            ? SizedBox()
            : Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        startCalledBloc.initManual(context, widget.attendance);
                      },
                      child: Container(
                          child: Align(
                        alignment: Alignment.center,
                        child: Text('Iniciar a distância',
                            textAlign: TextAlign.end,
                            style: AppThemeUtils.normalSize(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color)),
                      ))),
                  SizedBox(
                    height: 0,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
        buildNotInitNow(context, widget.attendance, currentBloc),
      ])),
      childBottom: widget.attendance?.status == ActivityUtils.AGUARDO_QR
          ? Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
                onPressed: () {
                  startCalledBloc.scan(context, widget.attendance);
                },
                //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                child: Text(
                  'Ler código QR',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ))
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Container(
                  child: Center(
                      child: ConfirmationSlider(
                width: MediaQuery.of(context).size.width > 400
                    ? 400
                    : MediaQuery.of(context).size.width - 50,height: 60,
                foregroundColor: AppThemeUtils.colorPrimary,backgroundColorEnd: AppThemeUtils.colorPrimary,
                onConfirmation: () {
                  startCalledBloc.initManual(context, widget.attendance);
                },
                text: StringFile.iniciarAtendimento,
              )))),
    );
  }

  Future resultAction(BuildContext context) async {
//      var result = await Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (BuildContext context) => ChangeDateDiaries(),
//              fullscreenDialog: true));
//      if (result != null) {
//        _controllerChoose.text = result;
//      }
  }
}
