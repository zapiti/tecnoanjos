import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/card_call_teamview.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_generic_textfield.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/components/image/image_with_bg_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import '../../start_called_bloc.dart';

class StageAlterCalledTecno extends StatefulWidget {
  final Attendance attendance;

  StageAlterCalledTecno(this.attendance);

  @override
  _StageAlterCalledTecnoState createState() => _StageAlterCalledTecnoState();
}

class _StageAlterCalledTecnoState extends State<StageAlterCalledTecno> {
  var controllerPendency = TextEditingController();
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cardCallTeamView(widget.attendance),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      height: 45,
                      child: imageWithBgWidget(
                        context,
                        ImagePath.inAttendance,
                      )),
                  Container(
                      margin: EdgeInsets.all(20),
                      child: Text(
                        "O Tecnoanjo solicitou uma alteração nos serviços",
                        style:
                        TextStyle(
                            color: AppThemeUtils.colorPrimary, fontSize: 22),
                      )),
                  lineViewWidget(),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        "Atendimento anterior",
                        style:
                        TextStyle(
                            color: AppThemeUtils.colorPrimary, fontSize: 18),
                      )),
                  // Container(
                  //     margin: EdgeInsets.symmetric(horizontal: 10),
                  //     child: ResumeCard(Calling.fromMapOld(widget.attendance),
                  //         color: Colors.grey[200])),
                  // lineViewWidget(),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        "Alteração",
                        style: TextStyle(
                            color: AppThemeUtils.colorError, fontSize: 18),
                      )),
                  // Container(
                  //     margin: EdgeInsets.symmetric(horizontal: 10),
                  //     child: ResumeCard(Calling.fromMap(widget.attendance))),
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 180),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: Container(
                              height: 45,
                              margin:
                              EdgeInsets.only(
                                  right: 10, left: 10, bottom: 10, top: 10),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: AppThemeUtils.colorError,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        side: BorderSide(
                                            color: AppThemeUtils.colorError,
                                            width: 1)),),

                                  onPressed: () {
                                    showTextFieldGenericDialog(
                                        context: context,
                                        title: StringFile.adicionarMotivo,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(100)
                                        ],
                                        minSize: 9,
                                        erroText: StringFile.digiteNoMinimo50,
                                        controller: controllerPendency,
                                        positiveCallback: () {
                                          var startCalledBloc =
                                          Modular.get<StartCalledBloc>();
                                          startCalledBloc
                                              .acceptRefusedAlterAttendance(
                                              context,
                                              false,
                                              controllerPendency.text,
                                              widget.attendance, () {
                                            Navigator.of(context).pop();
                                            Modular.get<
                                                FirebaseClientTecnoanjo>()
                                                .setCollection(
                                                widget.attendance);
                                          });
                                        },
                                        negativeCallback: () {});
                                  },
                                  child: Expanded(
                                      child: Text(
                                        StringFile.recusarAlteracao,
                                        textAlign: TextAlign.center,
                                        style: AppThemeUtils.normalBoldSize(
                                          color: AppThemeUtils.whiteColor,
                                        ),
                                      ))
                              ),
                            )),
                        Expanded(
                            child: Container(
                              height: 45,
                              margin:
                              EdgeInsets.only(
                                  right: 10, left: 10, bottom: 10, top: 5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: AppThemeUtils.colorPrimary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)))),

                                onPressed: () {
                                  var startCalledBloc = Modular.get<
                                      StartCalledBloc>();
                                  widget.attendance.dateEnd = null;
                                  startCalledBloc.acceptRefusedAlterAttendance(
                                      context, true, null,
                                      widget.attendance, () {
                                    Modular.get<FirebaseClientTecnoanjo>()
                                        .setCollection(widget.attendance);
                                  });
                                },
                                child: Expanded(
                                    child: Text(
                                      'Aceitar Alteração',
                                      textAlign: TextAlign.center,
                                      style: AppThemeUtils.normalBoldSize(
                                        color: AppThemeUtils.whiteColor,
                                      ),
                                    )),
                              ),
                            )),
                      ],
                    ),
                  ),
                  lineViewWidget(),
                ])));
  }
}
