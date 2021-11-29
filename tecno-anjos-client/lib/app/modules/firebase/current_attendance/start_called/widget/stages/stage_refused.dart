import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:tecnoanjosclient/app/components/atendimento/center_view_attendance.dart';
import 'package:tecnoanjosclient/app/components/atendimento/view_atendimento.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/my_current_attendance_bloc.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import '../../start_called_bloc.dart';

class StageReviewCalledTecnoRefuzed extends StatefulWidget {
  final Attendance attendance;

  StageReviewCalledTecnoRefuzed(this.attendance);

  @override
  _StageReviewCalledTecnoRefuzedState createState() =>
      _StageReviewCalledTecnoRefuzedState();
}

class _StageReviewCalledTecnoRefuzedState
    extends State<StageReviewCalledTecnoRefuzed> {
  var controllerPendency = TextEditingController();
  var startCalledBloc = Modular.get<StartCalledBloc>();
  var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();

  @override
  Widget build(BuildContext context) {
    return ViewAttendanceWidget(
      childTop: null,
      childCenter: CenterViewAttendance(subtitle: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
              "Tecnoanjo não ira ajustar como devemos continuar?",
                  style: AppThemeUtils.normalSize(fontSize: 18),
                  textAlign: TextAlign.center,
                )),
            lineViewWidget(),
            Column(
              mainAxisSize: MainAxisSize.max,
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
          ])),
      childBottom: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppThemeUtils.lightGray,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                        ),
                        onPressed: () {
                          var currentBloc =
                              GetIt.I.get<MyCurrentAttendanceBloc>();
                          currentBloc.patchCancel(context, widget.attendance);
                        },
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                        child: Text(
                          "NÃO CONCORDO E CONCLUIR",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ))),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                        ),
                        onPressed: () {
                          var currentBloc =
                              GetIt.I.get<MyCurrentAttendanceBloc>();
                          currentBloc.patchConclude(context, widget.attendance);
                        },
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                        child: Text(
                          "ACEITAR e CONCLUIR",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center,
                        ))),
              )
            ],
          )),
    );
  }
}
