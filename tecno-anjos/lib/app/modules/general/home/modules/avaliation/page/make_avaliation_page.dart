import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:tecnoanjostec/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/start_called_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';


import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

class MakeAvaliationPage extends StatefulWidget {
  final Attendance attendance;

  MakeAvaliationPage(this.attendance);

  @override
  _MakeAvaliationPageState createState() => _MakeAvaliationPageState();
}

class _MakeAvaliationPageState extends State<MakeAvaliationPage> {

  double hatting;
  String resenha;


  var startBloc = Modular.get<StartCalledBloc>();

  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
      childMobile: bodyAvaliation(context),
      childWeb: bodyAvaliation(context),
      enableBar: false,
    );
  }

  Scaffold bodyAvaliation(BuildContext context) {
    return Scaffold(
        backgroundColor: AppThemeUtils.whiteColor,
        appBar: AppBar(
          title: Text(
            StringFile.avalieAtendimento,
            style: AppThemeUtils.normalSize(color: AppThemeUtils.whiteColor),
          ),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery
                                    .of(context)
                                    .viewInsets
                                    .bottom),
                            child: Material(
                              color: Colors.white,
                              child: ListBody(
                                children: <Widget>[
                                  Center(
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              top: 5,
                                              left: 5,
                                              right: 5,
                                              bottom: 5),
                                          child: ClipRRect(
                                              borderRadius: BorderRadius
                                                  .circular(100.0),
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                color: Colors.grey[200],
                                                child: Image.network(
                                                  (widget.attendance.userClient
                                                      .pathImage ??
                                                      ""),
                                                  fit: BoxFit.fill,

                                                ),
                                              )))),
                                  Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.all(15),
                                      child: Center(
                                          child: Text(
                                            widget.attendance?.userClient
                                                ?.name ?? "",
                                            style: AppThemeUtils.normalBoldSize(
                                                fontSize: 20,
                                                color: AppThemeUtils
                                                    .colorPrimary),
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
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            ratingWidget: RatingWidget(
                                                full: Icon(
                                                  Icons.star,
                                                  color: AppThemeUtils
                                                      .colorPrimary,
                                                ),
                                                half: Icon(
                                                  Icons.star,
                                                  color: AppThemeUtils
                                                      .colorPrimary,
                                                ),
                                                empty: Icon(
                                                  Icons.star_border,
                                                  color: AppThemeUtils
                                                      .colorPrimary,
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
                                            keyboardType: TextInputType.text,
                                            onChanged: (text) {
                                              resenha = text;
                                            },
                                            decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                                hintText: StringFile
                                                    .comoFoiSeuAtendimento,
                                                border: const OutlineInputBorder(
                                                  borderRadius: const BorderRadius
                                                      .all(
                                                    const Radius.circular(10.0),
                                                  ),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.3),
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      margin:
                      EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 5),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: AppThemeUtils.colorPrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(12))), elevation: 0),

                          onPressed: () {
                            startBloc.evalueteAction(context,
                                hatting ?? 5.0, resenha ?? "",
                                widget.attendance);
                            Navigator.pop(context);
                          },
                          child: Text(
                            StringFile.enviarAvaliacao,
                            style: AppThemeUtils.normalBoldSize(
                              color: AppThemeUtils.whiteColor,
                            ),
                          ))),


                ])));
  }


}

