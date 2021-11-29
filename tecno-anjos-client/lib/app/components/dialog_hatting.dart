import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/avaliation/page/make_avaliation_page.dart';


import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/start_called_bloc.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';

import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import '../app_bloc.dart';

class RattingView extends StatelessWidget {
  final Attendance attendance;
  final Function success;

  RattingView(this.attendance, this.success);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (success == null) {
            Modular.to.pushReplacementNamed(ConstantsRoutes.HOMEPAGE);
            var startBloc = Modular.get<StartCalledBloc>();

            startBloc.currentAttendance.sink.add(null);
          }

          return true;
        },
        child: Scaffold(
            backgroundColor: AppThemeUtils.whiteColor,
            appBar: AppBar(
              title: Text(
                StringFile.avalieAtendimento,
                style:
                    AppThemeUtils.normalSize(color: AppThemeUtils.whiteColor),
              ),
              automaticallyImplyLeading: false,
              centerTitle: true,
            ),
            body: EvaluateAttendanceView(this.attendance,
                success: this.success)));
  }
}

void showRattingDialog(Attendance attendance, {Function sucess}) {
  Modular.to.push(
      MaterialPageRoute(builder: (context) => RattingView(attendance, sucess)));
}

// ignore: must_be_immutable
class EvaluateAttendanceView extends StatelessWidget {
  double hatting;
  String resenha;
  final Attendance attendance;
  final Function success;
  final appBloc = Modular.get<AppBloc>();

  EvaluateAttendanceView(this.attendance, {this.success});

  var startBloc = Modular.get<StartCalledBloc>();

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: SingleChildScrollView(
                      child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Material(
                  color: Colors.white,
                  child: ListBody(
                    children: <Widget>[
                      Center(
                          child: Container(
                              margin: EdgeInsets.only(
                                  top: 15, left: 5, right: 5, bottom: 5),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[200],
                                    child: Image.network(
                                      (attendance.userTecno?.pathImage ?? ""),
                                      fit: BoxFit.fill,

                                      // placeholder: (context, url) =>
                                      //     new CircularProgressIndicator(),
                                      // errorWidget: (context, url, error) =>
                                      //     new Icon(Icons.error_outline),
                                    ),
                                  )))),
                      Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(15),
                          child: Center(
                              child: Text(
                            attendance?.userTecno?.name ?? "",
                            style: AppThemeUtils.normalBoldSize(
                                fontSize: 20,
                                color: AppThemeUtils.colorPrimary),
                          ))),
                      Container(
                          width: double.infinity,
                          child: Center(
                              child: RatingBar(
                            initialRating: 5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            ratingWidget: RatingWidget(
                                full: Icon(
                                  Icons.star,
                                  color: AppThemeUtils.colorPrimary,
                                ),
                                half: Icon(
                                  Icons.star,
                                  color: AppThemeUtils.colorPrimary,
                                ),
                                empty: Icon(
                                  Icons.star_border,
                                  color: AppThemeUtils.colorPrimary,
                                )),
                            onRatingUpdate: (rating) {
                              hatting = (rating);
                            },
                          ))),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: TextField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(80),
                                ],
                                keyboardType: TextInputType.text,
                                onChanged: (text) {
                                  resenha = text;
                                },
                                decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                    hintText: StringFile.comoFoiSeuAtendimento,
                                    border: const OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 0.3),
                                    )),
                              )),
                        ),
                      ),
                      bodyFavorite(attendance),
                    ],
                  ),
                ),
              ))),
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                margin:
                    EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: AppThemeUtils.colorPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                  onPressed: () {
                    startBloc.evalueteAction(
                        context, hatting ?? 5.0, resenha ?? "", attendance);
                    //   startBloc.currentAttendance.sink.add(null);
                    if (success != null) {
                      success();
                    } else {
                      // attendance.tecnoAvaliation = true;
                      // attendance.tecnoNF = true;
                      // Modular.get<FirebaseClientTecnoanjo>().setCollection(attendance);
                      // Modular.to.pushReplacementNamed(ConstantsRoutes.HOMEPAGE);
                    }

                    //   startBloc.conclude(context, attendance);
                  },
                  child: Text(
                    StringFile.enviarAvaliacao,
                    style: AppThemeUtils.normalBoldSize(
                      color: AppThemeUtils.whiteColor,
                    ),
                  ),
                ),
              ),
              ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.white,elevation: 0),
                  onPressed: () {
                    if (success != null) {
                      success();
                    } else {
                      startBloc.evalueteAction(context, null, null, attendance);
                    }
                  },
                  child: Container(
                      height: 45,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(StringFile.avaliarDepois,
                            textAlign: TextAlign.end,
                            style: AppThemeUtils.normalSize(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).primaryColor)),
                      ))),
            ]));
  }
}
