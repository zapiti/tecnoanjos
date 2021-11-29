import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/configuration/aws_configuration.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';


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
                                  text: snapshot.data?.data() == null ?  AwsConfiguration.teamViewUrl: snapshot.data?.get('url') ?? AwsConfiguration.teamViewUrl,
                                  style: AppThemeUtils.normalSize(
                                      color: AppThemeUtils.colorPrimary,
                                      fontSize: 16),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // launch(AwsConfiguration.teamViewUrl);
                                    }),
                              TextSpan(
                                  text: ' no seu computador e siga o passo a passo',
                                  style: AppThemeUtils.normalSize(
                                      color: Colors.grey[700], fontSize: 12)),
                            ],
                          )))),
            );
}
