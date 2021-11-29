import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class ItensServicesWidget extends StatelessWidget {
  final String title;
  final String description;
  final String pricingParcel;
  final String pricingTotal;
  final Function action;
  final bool recomendado;

  ItensServicesWidget({this.title,
    this.description,
    this.pricingParcel,
    this.pricingTotal,
    this.action, this.recomendado});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Container(
        margin: EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
              color: !recomendado
                  ? AppThemeUtils.colorError
                  : AppThemeUtils.colorPrimary,
              width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(18.0)),
        ),
        child: Column(
          children: [
            !recomendado
                ? SizedBox()
                : Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                decoration: BoxDecoration(
                  color: AppThemeUtils.colorPrimary,
                  border: Border.all(
                      color: AppThemeUtils.colorPrimary, width: 1.0),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0)),
                ),
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Text(
                  StringFile.recomendado,
                  textAlign: TextAlign.center,
                  style: AppThemeUtils.normalSize(
                      color: AppThemeUtils.whiteColor),
                )),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.more_time_rounded,
                      color: AppThemeUtils.colorPrimary,
                      size: 40,
                    ),
                    Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            title,
                            style: AppThemeUtils.normalBoldSize(fontSize: 22),
                          ),
                        ))
                  ],
                )),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppThemeUtils.colorPrimary,
                    ),
                    Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            description,
                            style: AppThemeUtils.normalSize(fontSize: 16),
                          ),
                        ))
                  ],
                )),
            SizedBox(
              height: 5,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  pricingParcel,
                                  style: AppThemeUtils.normalBoldSize(
                                      fontSize: 16),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  StringFile.ou,
                                  style: AppThemeUtils.normalSize(
                                      fontSize: 12,
                                      color: AppThemeUtils.colorPrimary),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  pricingTotal,
                                  style: AppThemeUtils.normalSize(fontSize: 14),
                                ),
                              )
                            ],
                          ),
                        )),
                    Expanded(
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppThemeUtils.colorPrimary,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(4))),),

                              onPressed: () {
                                action();
                              },
                              child: AutoSizeText(
                                StringFile.comprar,
                                maxLines: 1,
                                style: AppThemeUtils.normalBoldSize(
                                  color: AppThemeUtils.whiteColor,
                                ),
                              ),

                            )))
                  ],
                )),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
