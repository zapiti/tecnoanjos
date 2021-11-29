import 'package:tecnoanjos_franquia/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjos_franquia/app/components/gradient_container.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:flutter/material.dart';


void showGenericDialog(BuildContext context,
    {IconData iconData,
      String title,
      String description,
      String subtitle,
      VoidCallback positiveCallback,
      VoidCallback negativeCallback,
      String positiveText,
      String negativeText,
      Color color,
      bool hideSubTitle = true, bool isLight = false}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return _DialogGeneric(
          iconData: iconData,
          title: title,
          description: description,
          positiveCallback: positiveCallback,
          negativeCallback: negativeCallback,
          positiveText: positiveText,
          subtitle: subtitle,
          negativeText: negativeText,
          color: color,isLight:isLight,
          hideSubTitle: hideSubTitle);
    },
  );
}

class _DialogGeneric extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String description;
  final VoidCallback positiveCallback;
  final VoidCallback negativeCallback;
  final String positiveText;
  final String negativeText;
  final Color color;
  final String subtitle;
  final bool hideSubTitle;
  final bool isLight;

  _DialogGeneric(
      {this.iconData,
        this.title,
        this.description,
        this.positiveCallback,
        this.negativeCallback,
        this.positiveText,
        this.negativeText,
        this.color,this.isLight = true,
        this.subtitle,
        this.hideSubTitle = true});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width > 450
                  ? 400
                  : MediaQuery.of(context).size.width * 0.8,
              child: Material(
                color: Colors.white,
                child: ListBody(
                  children: <Widget>[
                    gradientContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 0),
                              child: Icon(
                                iconData,
                                color: color ?? AppThemeUtils.colorPrimary,
                                size: 50,
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 0, bottom: 10),
                                child: Text(
                                  title,
                                  style: AppThemeUtils.normalBoldSize(
                                      color:
                                      color ?? Theme.of(context).primaryColor,
                                      fontSize: 22),
                                )),
                          ],
                        )),
                    Container(
                      padding: EdgeInsets.only(top: 20, bottom: 0),
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(color: Colors.white, width: 1),
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 200,
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    child: Wrap(
                                      children: <Widget>[
                                        Text(
                                          description,
                                          textAlign: TextAlign.center,
                                          style: AppThemeUtils.normalSize(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          hideSubTitle
                              ? SizedBox(height: 20,)
                              : Container(
                            width: 200,
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Wrap(
                                      children: <Widget>[
                                        Text(
                                          subtitle ??
                                              "O que você deseja fazer agora?",
                                          textAlign: TextAlign.center,
                                          style: AppThemeUtils
                                              .normalBoldSize(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          lineViewWidget(),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                positiveCallback == null
                                    ? SizedBox()
                                    : Container(
                                  margin: EdgeInsets.only(
                                      right: 10,
                                      left: 10,
                                      bottom: 10,
                                      top: 5),
                                  child: RaisedButton(
                                    color: AppThemeUtils.colorPrimary,
                                    elevation: 0,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      positiveCallback();
                                    },
                                    child: Text(
                                      positiveText ?? 'Sim',
                                      style: AppThemeUtils.normalBoldSize(
                                        color: isLight ?AppThemeUtils.colorPrimary:  AppThemeUtils.whiteColor,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                  ),
                                ),
                                lineViewWidget(),
                                negativeCallback == null
                                    ? SizedBox()
                                    : Container(
                                  margin: EdgeInsets.only(
                                      right: 10,
                                      left: 10,
                                      bottom: 10,
                                      top: 10),
                                  child: RaisedButton(
                                    color:isLight ?Colors.transparent:  AppThemeUtils.colorError,
                                    elevation: 0,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      negativeCallback();
                                    },
                                    child: Text(
                                      negativeText ?? 'Não',
                                      style: AppThemeUtils.normalBoldSize(
                                        color:isLight ?AppThemeUtils.colorPrimary:  AppThemeUtils.whiteColor,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        side: BorderSide(
                                            color:
                                            isLight ?Colors.transparent:    AppThemeUtils.colorError,
                                            width: 1)),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
