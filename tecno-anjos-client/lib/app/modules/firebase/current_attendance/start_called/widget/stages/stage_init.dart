import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/atendimento/center_view_attendance.dart';
import 'package:tecnoanjosclient/app/components/atendimento/view_atendimento.dart';
import 'package:tecnoanjosclient/app/modules/google_maps/scrolling_map.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/start_called_bloc.dart';
import 'package:tecnoanjosclient/app/utils/attendance/activity_utils.dart';
import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

TabController tab;

class StageInit extends StatelessWidget {
  final Attendance attendance;
  final Function actionInitAttendance;

  StageInit(this.attendance, {this.actionInitAttendance});

  final startCalledBloc = Modular.get<StartCalledBloc>();


  @override
  Widget build(BuildContext context) {
    return attendance.status == ActivityUtils.REMOTAMENTE
        ?
    Container(
        color: Theme
            .of(context)
            .backgroundColor,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: initAttendanceView(context))
        : Column(
      children: [
        Container(
            color: AppThemeUtils.colorPrimary,
            width: MediaQuery
                .of(context)
                .size
                .width,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Text(
              "Seu Tecnoanjo está indo até você!",
              style: AppThemeUtils.normalBoldSize(
                  color: AppThemeUtils.whiteColor, fontSize: 20),
              textAlign: TextAlign.center,
            )),
        Expanded(child: ScrollingMapPage(attendance))
      ],
    );
    // DefaultTabPage(tab,
    //         title: ["Local", "Iniciar atendimento"],neverScroll: NeverScrollableScrollPhysics(),
    //
    //         changeTab: (tabController) {
    //           actionInitAttendance(tabController);
    //         },
    //         Page: [
    //           MapScreenWeb(attendance),
    //           initAttendanceView(context),
    //         ],
    //       );
  }

  Widget initAttendanceView(BuildContext context) {
    return ViewAttendanceWidget(
      childTop: null,
      childCenter: CenterViewAttendance(
        image: ImagePath.imagePlay, title: this.attendance.status ==
          ActivityUtils.REMOTAMENTE
          ? "Aguarde seu Tecnoanjo  solicitar o início ${ActivityUtils
          .getStatusName(this.attendance?.status)}!"
          : "Seu Tecnoanjo esta indo até você",

      ),

    );
  }
}
