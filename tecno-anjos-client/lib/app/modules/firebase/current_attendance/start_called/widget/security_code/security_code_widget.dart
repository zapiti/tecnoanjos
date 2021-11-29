import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/widget/security_code/item/item_security_await.dart';
import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/widget/security_code/item/item_security_error.dart';
import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/widget/security_code/item/item_security_sucess.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/utils/firebase/firebase_client_tecnoanjo.dart';

class SecurityCodeWidget extends StatelessWidget {
  final Attendance attendance;

  SecurityCodeWidget(this.attendance);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream:
            Modular.get<FirebaseClientTecnoanjo>().streamInLocal(attendance),
        builder: (context, snapshot) => snapshot.data?.data() == null
            ? SizedBox(
                width: 0,
                height: 0,
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,

                child: snapshot.data?.data()["status"] == "E"
                    ? ItemSecurityError(attendance)
                    : snapshot.data?.data()["status"] == "S"
                        ? ItemSecuritySucess(attendance)
                        : ItemSecurityAwait(attendance),
              ));
  }
}
