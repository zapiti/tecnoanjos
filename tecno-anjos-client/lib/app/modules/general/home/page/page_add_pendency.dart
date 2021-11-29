import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tecnoanjosclient/app/components/card_call_teamview.dart';

import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';

import 'package:tecnoanjosclient/app/components/image/image_with_bg_widget.dart';
import 'package:tecnoanjosclient/app/components/load/load_elements.dart';

import 'package:tecnoanjosclient/app/components/ntp_time/ntp_time_component.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';

import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/start_called_bloc.dart';

import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class PageAddPendency extends StatelessWidget {
  final Attendance attendance;

  PageAddPendency(this.attendance);

  final enableButton = false;
  final startAttendanceBloc = Modular.get<StartCalledBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(StringFile.atendimento),
          centerTitle: true,
        ),
        body: NtpTimeComponent(buildTime: (_context, _dateTime) {
          if (_dateTime == null) {
            return loadElements(context);
          } else {
            return Column(
              children: [
                Expanded(
                    child: Container(
                        child: SingleChildScrollView(
                            child: Column(children: <Widget>[
                  cardCallTeamView(attendance),
                  imageWithBgWidget(context, ImagePath.inAttendance),
                  Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      child: Text(StringFile.voceEstaEmAtendimento,
                          style: AppThemeUtils.normalSize(fontSize: 20))),
                  Column(
                    children: [
                      lineViewWidget(),
                      Container(
                          margin: EdgeInsets.all(20),
                          child: TextField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(80),
                            ],
                            maxLines: 5,
                            onChanged: startAttendanceBloc.pendency.sink.add,
                            decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.3),
                                ),
                                hintText: StringFile.pendencias,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.3),
                                ),
                                fillColor: Colors.grey[300]),
                            style: AppThemeUtils.normalSize(fontSize: 18),
                          )),
                      lineViewWidget(),
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 30),
                          child: Text(
                            (attendance.pendencies ?? []).length == 0
                                ? StringFile.digaOqDeveSerAlterado
                                : StringFile.digaMotivoDarecusa,
                            style: AppThemeUtils.normalSize(fontSize: 22),
                            textAlign: TextAlign.center,
                          )),
                    ],
                  )
                ])))),
                StreamBuilder<String>(
                    stream: startAttendanceBloc.pendency.stream,
                    builder: (context, content) {
                      var enableButton = !(content?.data?.isEmpty ?? true);
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          margin: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: enableButton
                                    ? AppThemeUtils.colorPrimary
                                    : AppThemeUtils.lightGray,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                )),

                            onPressed: !enableButton
                                ? null
                                : () {
                                    startAttendanceBloc.addPendency(
                                        context, attendance, content?.data);
                                  },
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                            child: Text(
                              StringFile.enviar,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ));
                    }),
              ],
            );
          }
        }));
  }
}
