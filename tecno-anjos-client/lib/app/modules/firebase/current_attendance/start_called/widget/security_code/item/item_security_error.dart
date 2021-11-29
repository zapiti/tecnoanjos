import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/my_current_attendance_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/chat_tecno_client/chat/chat_perspective.dart';
import 'package:tecnoanjosclient/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class ItemSecurityError extends StatelessWidget {
  final Attendance attendance;
  final currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();
  ItemSecurityError(this.attendance);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            child: Icon(
              Icons.error,
              size: 100,
              color: AppThemeUtils.colorPrimary,
            ),
            margin: EdgeInsets.all(10),
          ),
          Container(
            child: Text(
              "Seu Tecnoanjos fez uma tentativa falha de verificação do código de segurança!\n\nO que deseja fazer?",
              textAlign: TextAlign.center,
              style: AppThemeUtils.normalBoldSize(
                  fontSize: 18, color: AppThemeUtils.colorPrimary),
            ),
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          ),
          Container(margin: EdgeInsets.all(10),
              child: chatField(attendance,context,hint: "Falar com o tecnoanjo")),
          Row(
            children: [

              Expanded(

                  child: Container(

                      padding: EdgeInsets.all(15),
                      child: ElevatedButton(
                        onPressed: () {
                          currentBloc.patchCancel(context, attendance);

                        },
                        style: ElevatedButton.styleFrom(
                            primary: AppThemeUtils.colorError,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0))),
                        child: Container(
                            height: 45,
                            child: Center(
                                child: Text(
                              "Cancelar atendimento",
                              textAlign: TextAlign.center,
                              style: AppThemeUtils.normalSize(
                                  color: AppThemeUtils.whiteColor),
                            ))),
                      ))),
              Expanded(
                  child: Container(

                      padding: EdgeInsets.all(15),
                      child: ElevatedButton(
                        onPressed: () {
                          Modular.get<FirebaseClientTecnoanjo>().sendInLocal(attendance);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: AppThemeUtils.colorPrimary,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0))),
                        child: Container(
                            height: 45,
                            child: Center(
                                child: Text(
                                  "Tentar novamente",
                                  textAlign: TextAlign.center,
                                  style: AppThemeUtils.normalSize(
                                      color: AppThemeUtils.whiteColor),
                                ))),
                      ))),
            ],
          )
        ],
      ),
    );
  }
}
