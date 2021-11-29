import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/components/atendimento/center_view_attendance.dart';

import 'package:tecnoanjostec/app/components/atendimento/view_atendimento.dart';

import 'package:tecnoanjostec/app/components/divider/line_view_widget.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/utils/image/image_path.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

class StageRefuzed extends StatefulWidget {
  final Attendance attendance;

  StageRefuzed(this.attendance);
  @override
  _StageRefuzedState createState() => _StageRefuzedState();
}

class _StageRefuzedState extends State<StageRefuzed> {

  var controllerPendency = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewAttendanceWidget(
        childTop: Center(
          child: Container(
            height: 80,
            child: Image.asset(
              ImagePath.inAttendance,
            ),
          ),
        ),
        childCenter: CenterViewAttendance(title:  StringFile.tecnicoQuerAlteracao,subtitle:  Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: widget.attendance?.pendencies
                    ?.map<Widget>((e) => Card(
                    child: ListTile(
                      title: new Text(
                        "Discussões",
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        new Text(e.markerPendency ==  widget.attendance.userTecno?.id ? widget.attendance.userTecno.name : widget.attendance.userClient.name,style: AppThemeUtils.normalBoldSize(),),
                        lineViewWidget(top: 5,bottom: 10),
                        new Text(e.description),
                          SizedBox(height: 10,)
                      ],),
                      onTap: () {},
                    )))
                    ?.toList() ??
                    [],
              ),
            ])));
  }
}
