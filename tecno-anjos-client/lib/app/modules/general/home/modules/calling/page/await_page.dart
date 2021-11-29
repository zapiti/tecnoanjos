import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:tecnoanjosclient/app/components/image/image_with_bg_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/my_current_attendance_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/widget/stages/stage_receipt.dart';
import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class AwaitPage extends StatelessWidget {
  final Attendance attendance;

  AwaitPage(this.attendance);

  final attendanceBloc = Modular.get<AttendanceBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: AppThemeUtils.colorPrimary),
        ),
        body: Column(children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
                  child: Column(children: <Widget>[
            imageWithBgWidget(context, ImagePath.imageHands, height: 80),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Text(
                  StringFile.estamosProcurando,
                  style: AppThemeUtils.normalBoldSize(fontSize: 18),
                )),
            Container(
                child: ReceiptCard2(
              attendance,
              false,
              null,
              showImage: false,
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Container(
                        padding: EdgeInsets.all(15),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                  side: BorderSide(
                                      color: AppThemeUtils.colorError)),
                              primary: AppThemeUtils.colorError,
                            ),
                            onPressed: () {
                              var currentBloc =
                                  GetIt.I.get<MyCurrentAttendanceBloc>();
                              currentBloc.patchCancelCurrentAttendance(
                                  context, attendance);
                            },
                            child: Container(
                                height: 45,
                                child: Center(
                                    child: Text(
                                  StringFile.cancelarChamado,
                                  style: AppThemeUtils.normalSize(
                                      color: AppThemeUtils.whiteColor),
                                )))))),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ])))
        ]));
  }
}
