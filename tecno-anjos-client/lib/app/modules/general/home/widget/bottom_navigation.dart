import 'package:flutter/material.dart';

import 'package:tecnoanjosclient/app/components/text_appearance/title_description_icon.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/page/await_page.dart';
import 'package:tecnoanjosclient/app/modules/general/home/page/page_add_pendency.dart';

import 'package:tecnoanjosclient/app/utils/string/string_file.dart';

Widget bottomNavigationCurrentAttendance(
    BuildContext context, Attendance attendance,
    {bool constainsInit = false,
    VoidCallback action,
    bool isCurrent = false,
    String nameAction,
    Function actionEdit,
    bool onlyAction}) {
  return Align(
      alignment: Alignment.bottomCenter,
      child: (Container(
        height: 90.0,
        color: Colors.transparent,
        child: new Container(
            decoration: new BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(40.0),
                  topRight: const Radius.circular(40.0),
                )),
            child: new Center(
              child: Row(
                children: <Widget>[
                  isCurrent
                      ? SizedBox()
                      : (!constainsInit
                          ? SizedBox()
                          : Expanded(
                              child: InkWell(
                                  onTap: () {
                                    if (attendance?.userTecno?.id != null) {
                                      // AttendanceUtils.pushNamed(context,
                                      //     ConstantsRoutes
                                      //         .ATENDIMENTO_ATUAL);
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AwaitPage(attendance)),
                                      );
                                      // AttendanceUtils.pushNamed(
                                      //     context,
                                      //     ConstantsRoutes
                                      //         .CALLING_ATENDIMENTO_AWAIT,
                                      //     arguments: attendance);
                                    }
                                  },
                                  child: titleDescriptionIcon(
                                      context,
                                      Icons.play_circle_filled,
                                      StringFile.iniciarEncerrar,
                                      colorIcon:
                                          Theme.of(context).backgroundColor)))),
                  !isCurrent
                      ? SizedBox()
                      : Expanded(
                          child: InkWell(
                              onTap: () {
                                actionEdit();
                              },
                              child: titleDescriptionIcon(context, Icons.edit,
                                  StringFile.editarAdicionar,
                                  colorIcon:
                                      Theme.of(context).backgroundColor))),
                  !isCurrent
                      ? SizedBox()
                      : Expanded(
                          child: InkWell(
                              onTap: () {
                                if (attendance != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PageAddPendency(attendance)),
                                  );
                                }

                                //   AttendanceUtils.pushNamed(
                                //       context, ConstantsRoutes.PENDENCY,
                                //       arguments: attendance);
                                // }
                              },
                              child: titleDescriptionIcon(
                                  context,
                                  Icons.error_outline,
                                  StringFile.adicionarPendencia,
                                  colorIcon:
                                      Theme.of(context).backgroundColor))),
                ],
              ),
            )),
      )));
}
