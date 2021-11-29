import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:tecnoanjostec/app/components/atendimento/center_view_attendance.dart';
import 'package:tecnoanjostec/app/components/atendimento/view_atendimento.dart';
import 'package:tecnoanjostec/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';

import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import '../../current_attendance_bloc.dart';
import '../../start_called_bloc.dart';

class StageReviewCalledTecno extends StatefulWidget {
  final Attendance attendance;

  StageReviewCalledTecno(this.attendance);

  @override
  _StageReviewCalledTecnoState createState() => _StageReviewCalledTecnoState();
}

class _StageReviewCalledTecnoState extends State<StageReviewCalledTecno> {
  var controllerPendency = TextEditingController();
  var startCalledBloc = Modular.get<StartCalledBloc>();
  var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();

  @override
  Widget build(BuildContext context) {
    return ViewAttendanceWidget(
      childTop: null,
      childCenter: CenterViewAttendance(
          title: StringFile.clienteQuerAlteracao,
          subtitle: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                lineViewWidget(),
                Column(
                  children: widget.attendance?.pendencies
                          ?.map<Widget>((e) => Card(
                                  child: ListTile(
                                title: new Text(
                                  "Ajuste solicitado",
                                  textAlign: TextAlign.center,
                                ),
                                subtitle: new Text(e.description),
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
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppThemeUtils.lightGray,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      onPressed: () {
                        var currentBloc =
                            GetIt.I.get<MyCurrentAttendanceBloc>();
                        currentBloc.patchRefusedReview(
                            context, widget.attendance);
                      },
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                      child: Text(
                        "RECUSAR",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          )),
                      onPressed: () {
                        var currentBloc =
                            GetIt.I.get<MyCurrentAttendanceBloc>();
                        currentBloc.patchAcceptReview(
                            context, widget.attendance);
                      },
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                      child: Text(
                        "ACEITAR",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )),
              )
            ],
          )),
    );
  }
}
