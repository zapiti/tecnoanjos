import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/configuration/aws_configuration.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import 'package:universal_html/html.dart' as html;

Widget cardCallTeamView(Attendance attendance) {
  return attendance?.address?.id != null
      ? SizedBox()
      : attendance?.dateEnd != null
          ? SizedBox()
          : Card(
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: Modular.get<FirebaseClientTecnoanjo>()
                          .getTeamViewUrl(),
                      builder: (ctx, snapshot) => RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "",
                            style: AppThemeUtils.normalSize(
                                color: Colors.grey[700], fontSize: 12),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Entre no site ',
                                  style: AppThemeUtils.normalSize(
                                      color: Colors.grey[700], fontSize: 12)),
                              TextSpan(
                                  text: snapshot.data?.data() == null ?  AwsConfiguration.teamViewUrl: snapshot.data?.data()['url'] ?? AwsConfiguration.teamViewUrl,
                                  style: AppThemeUtils.normalSize(
                                      color: AppThemeUtils.colorPrimary,
                                      fontSize: 16),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                    if(kIsWeb){
                                      html.window.open(snapshot.data?.data()['url'], 'nova aba');

                                    }
                                    }),
                              TextSpan(
                                  text: ' no seu computador e siga o passo a passo',
                                  style: AppThemeUtils.normalSize(
                                      color: Colors.grey[700], fontSize: 12)),
                            ],
                          )))),
            );
}
