import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/avaliation/models/avaliation.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';
import 'package:tecnoanjosclient/app/utils/attendance/attendance_utils.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

Widget avaliationItemListWidget(BuildContext context, Avaliation evaluation) {
  return Container(
    width: MediaQuery.of(context).size.width,
    color: evaluation.isAttendance
        ? AppThemeUtils.colorPrimary
        : Colors.transparent,
    margin: EdgeInsets.symmetric(horizontal: 5),
    child: Card(
        child: InkWell(
            onTap: () {
              if (evaluation.isAttendance) {
                Modular.to
                    .pushNamed(ConstantsRoutes.CALL_MAKE_AVALIATION,
                        arguments: evaluation.attendance)
                    .then((value) {
                  Modular.to.pushReplacementNamed(ConstantsRoutes.AVALIACOES);
                });
              } else {
                AttendanceUtils.pushNamed(
                    context, ConstantsRoutes.CALL_DETAILS_AVALIATION,
                    arguments: evaluation);
              }
            },
            child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(
                                top: 5, left: 0, right: 5, bottom: 10),
                            child: Column(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(
                                        top: 5, left: 10, right: 5, bottom: 5),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                        child: Container(
                                            width: 60,
                                            height: 60,
                                            color: Colors.grey[200],
                                            child: (evaluation.isReceiver
                                                        ? evaluation
                                                            .imageUrlReceiver
                                                        : evaluation
                                                            .imageUrlSender) ==
                                                    null
                                                ? SizedBox()
                                                : Image.network((evaluation
                                                .isReceiver
                                                ? evaluation
                                                .imageUrlReceiver
                                                : evaluation
                                                .imageUrlSender),
                                                    fit: BoxFit.fill,

                                                    width: 80,
                                                    height: 80,

                                                  )))),
                              ],
                            )),
                        Expanded(
                            child: Container(
                                padding: EdgeInsets.only(right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          (evaluation.isReceiver
                                                  ? evaluation.userNameReceiver
                                                  : evaluation
                                                      .userNameSander) ??
                                              "",
                                          maxLines: 2,
                                          style: AppThemeUtils.normalBoldSize(
                                              color: AppThemeUtils.black,
                                              fontSize: 18),
                                        )),
                                    Text(
                                      (evaluation?.description ?? "").isEmpty
                                          ? StringFile.semDepoimento
                                          : (evaluation?.description ?? ""),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: AppThemeUtils.normalSize(
                                          fontSize: 14),
                                    ),
                                  ],
                                ))),
                        Container(
                          width: 120,
                          child: Column(
                            children: [
                              Container(
                                  child: evaluation?.rating == null
                                      ? SizedBox(
                                          width: 10,
                                        )
                                      : RatingBar(
                                          initialRating:
                                              evaluation.rating ?? 0.0,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: false,
                                          ignoreGestures: true,
                                          itemSize: 20,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 2, vertical: 0),
                                          ratingWidget: RatingWidget(
                                              full: Icon(
                                                Icons.star,
                                                color:
                                                    AppThemeUtils.colorPrimary,
                                              ),
                                              half: Icon(
                                                Icons.star,
                                                color:
                                                    AppThemeUtils.colorPrimary,
                                              ),
                                              empty: Icon(
                                                Icons.star_border,
                                                color:
                                                    AppThemeUtils.colorPrimary,
                                              )),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        )),
                              evaluation.isAttendance
                                  ? SizedBox()
                                  : Container(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: AutoSizeText(
                                        StringFile.lerDepoimento,
                                        maxLines: 1,
                                        style: AppThemeUtils.normalBoldSize(
                                            color: AppThemeUtils.colorPrimary,
                                            fontSize: 16),
                                      )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                )))),
  );
}
