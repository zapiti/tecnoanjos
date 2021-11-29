import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tecnoanjosclient/app/components/atendimento/center_view_attendance.dart';
import 'package:tecnoanjosclient/app/components/atendimento/view_atendimento.dart';

import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class StageReviewCalledTecno extends StatefulWidget {
  final Attendance attendance;

  StageReviewCalledTecno(this.attendance);

  @override
  _StageReviewCalledTecnoState createState() => _StageReviewCalledTecnoState();
}

class _StageReviewCalledTecnoState extends State<StageReviewCalledTecno> {
  var controllerPendency = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewAttendanceWidget(
        childTop: null,
        childCenter: CenterViewAttendance(
          image: ImagePath.inAttendance,
          title: StringFile.clienteQuerAlteracao,
          subtitle: Column(
            children: widget.attendance?.pendencies
                    ?.map<Widget>((e) => Card(
                            child: ListTile(
                          title: new Text(
                            "Ajuste solicitado",
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              new Text(
                                e.markerPendency ==
                                        widget.attendance.userTecno?.id
                                    ? widget.attendance.userTecno.name
                                    : widget.attendance.userClient.name,
                                style: AppThemeUtils.normalBoldSize(),
                              ),
                              lineViewWidget(top: 5, bottom: 10),
                              new Text(e.description),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                          onTap: () {},
                        )))
                    ?.toList() ??
                [],
          ),
        ));
  }
}
