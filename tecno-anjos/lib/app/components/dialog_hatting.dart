import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/start_called_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';

import 'package:tecnoanjostec/app/routes/constants_routes.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
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
                "Avalie o seu atendimento",
                style:
                    AppThemeUtils.normalSize(color: AppThemeUtils.colorPrimary),
              ),
              automaticallyImplyLeading: false,
              centerTitle: true,
            ),
            body: EvaluateAttendanceView(this.attendance,
                success: this.success)));
  }
}

void showRattingDialog(Attendance attendance, {Function success}) {
  Modular.to.push(MaterialPageRoute(
      builder: (context) => RattingView(attendance, success)));
}

class EvaluateAttendanceView extends StatefulWidget {
  final Attendance attendance;
  final Function success;
  final appBloc = Modular.get<AppBloc>();
  final startBloc = Modular.get<StartCalledBloc>();

  EvaluateAttendanceView(this.attendance, {this.success});

  @override
  _EvaluateAttendanceViewState createState() => _EvaluateAttendanceViewState();
}

class _EvaluateAttendanceViewState extends State<EvaluateAttendanceView> {
  double hatting;
  String resenha;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Container(
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
                                  (widget.attendance.userClient.pathImage ??
                                      ""),
                                  fit: BoxFit.fill,
                                ),
                              )))),
                  Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(15),
                      child: Center(
                          child: Text(
                        widget.attendance?.userClient?.name ?? "",
                        style: AppThemeUtils.normalBoldSize(
                            fontSize: 20, color: AppThemeUtils.colorPrimary),
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
                            decoration: InputDecoration(
                                hintText: "Como foi seu atendimento?",
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
                ],
              ),
            ),
          ))),
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppThemeUtils.colorPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () {
                widget.startBloc.evalueteAction(
                    context, hatting ?? 5.0, resenha ?? "", widget.attendance);
                if (widget.success != null) {
                  widget.success();
                } else {}

                //   startBloc.conclude(context, attendance);
              },
              child: Text(
                'Enviar avaliação',
                style: AppThemeUtils.normalBoldSize(
                  color: AppThemeUtils.whiteColor,
                ),
              ),
            ),
          ),
          ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.white,elevation: 0),
              onPressed: () {
                if (widget.success != null) {
                  widget.success();
                } else {
                  widget.startBloc
                      .evalueteAction(context, null, null, widget.attendance);
                }
              },
              child: Container(
                  height: 45,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Avaliar depois',
                        textAlign: TextAlign.end,
                        style: AppThemeUtils.normalSize(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).primaryColor)),
                  ))),
        ]));
  }
}
