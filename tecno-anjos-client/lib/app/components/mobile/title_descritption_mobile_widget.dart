import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

Widget titleDescriptionWebWidget(BuildContext context,
    {String title,
    String description,
    GestureTapCallback action,
    Widget customIcon}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 15),
    child: Column(
      children: <Widget>[
        SizedBox(height: 10),
        SizedBox(
          width: 20,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                child: SelectableText(title ?? "--",
                    style: AppThemeUtils.normalSize(fontSize: 14))),
          ],
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            child: SelectableText(
              description ?? "--",
              style: AppThemeUtils.normalBoldSize(),
            )),
        SizedBox(width: 10),
        action != null ? Icon(Icons.keyboard_arrow_right) : SizedBox(),
        SizedBox(width: 20),
      ],
    ),
  );
}

Widget titleDescriptionWebListWidget(BuildContext context,
    {String title,
    List<String> description,
    GestureTapCallback action,
    Widget customIcon,
    bool wrap = false}) {
  return Container(
    decoration: !wrap
        ? null
        : BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppThemeUtils.colorPrimary,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
    child: Column(
      children: <Widget>[
        SizedBox(height: title == null ? 0 : 10),
        SizedBox(
          width: 20,
        ),
        title == null
            ? SizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width,
                      child: SelectableText(title ?? "--",
                          style: AppThemeUtils.normalSize(fontSize: 14))),
                ],
              ),
        Container(
            margin: EdgeInsets.only(left: 0),
            child: ChipsChoice<String>.multiple(
              value: description,
              wrapped: wrap,
              onChanged: (val) => {},
              choiceStyle: C2ChoiceStyle(
                color: AppThemeUtils.colorPrimary,
                margin: EdgeInsets.zero,
                borderOpacity: .3,
              ),
              choiceActiveStyle: C2ChoiceStyle(
                color: AppThemeUtils.colorPrimary,
                margin: EdgeInsets.only(right: 3),
                brightness: Brightness.dark,
              ),
              choiceItems: C2Choice.listFrom<String, String>(
                source: description,
                value: (i, v) => v,
                label: (i, v) => v,
              ),
            )),
        SizedBox(width: 10),
        action != null ? Icon(Icons.keyboard_arrow_right) : SizedBox(),
        SizedBox(width: 20),
      ],
    ),
  );
}

Widget titleDescriptionMobileWidget(BuildContext context,
    {String title,
    String description,
    GestureTapCallback action,
    Widget customIcon}) {
  return InkWell(
    onTap: action,
    child: Column(
      children: <Widget>[
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(title ?? "",
                        style: AppThemeUtils.normalBoldSize(fontSize: 14))),
              ],
            )),
            Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  description,
                  style: AppThemeUtils.normalSize(fontSize: 14),
                )),
            SizedBox(width: 10),
            action != null
                ? Icon(
                    Icons.keyboard_arrow_right,
                    color: AppThemeUtils.colorPrimary,
                  )
                : SizedBox(),
            SizedBox(width: 20),
          ],
        ),
      ],
    ),
  );
}

Widget titleDescriptionBigMobileWidget(BuildContext context,
    {String title,
    String description,
    GestureTapCallback action,
    Color color,
    Color descrColor,
    int maxLine = 3,
    bool hideNotDescription = false,
    Widget customTitle,
    iconData,
    double titleSize,
    double descriptionSize,
    double padding = 12,
    Widget customIcon,
    double height,
    Widget customDescription,
    Widget prefix,
    Widget iconWidget}) {
  return InkWell(
      onTap: () {
        if (action != null) {
          action();
        }
      },
      child: Container(
        padding: EdgeInsets.all(padding),
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                prefix ?? SizedBox(),
                iconData == null && iconWidget == null
                    ? SizedBox()
                    : Container(
                        padding: EdgeInsets.only(right: 20),
                        child: iconWidget ??
                            Icon(
                              iconData,
                              color: Theme.of(context).primaryColor,
                            )),
                Expanded(
                    child: Container(
                        child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    hideNotDescription && description == null
                        ? SizedBox()
                        : customTitle ??
                            Text(title ?? "",
                                maxLines: 1,
                                style: AppThemeUtils.normalBoldSize(
                                    color: color ??
                                        Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .color,
                                    fontSize: titleSize ?? 16)),
                    SizedBox(
                      height: 5,
                    ),
                    customDescription ??
                        (description == null
                            ? SizedBox()
                            : Text(
                                description,
                                style: AppThemeUtils.normalSize(
                                    color: descrColor ??
                                        Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .color,
                                    fontSize: descriptionSize ?? 14),
                              )),
                  ],
                ))),
                SizedBox(width: 10),
                customIcon ??
                    (action != null
                        ? Icon(
                            Icons.keyboard_arrow_right,
                            color: Theme.of(context).primaryColor,
                          )
                        : SizedBox()),
                SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ));
}

Widget titleDescriptionBigMobileWidget2(BuildContext context,
    {String title,
    String description,
    GestureTapCallback action,
    Color color,
    Color descrColor,
    int maxLine = 3,
    bool hideNotDescription = false,
    Widget customTitle,
    iconData,
    double titleSize,
    double descriptionSize,
    double padding = 12,
    Widget customIcon,
    double height,
    Widget customDescription,
    Widget prefix,
    Widget iconWidget}) {
  return InkWell(
      onTap: () {
        if (action != null) {
          action();
        }
      },
      child: Row(children: [
        Expanded(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: padding),
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              hideNotDescription && description == null
                  ? SizedBox()
                  : customTitle ??
                      Text(title ?? "",
                          maxLines: 1,
                          style: AppThemeUtils.normalSize(
                              fontSize: titleSize ?? 14)),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  prefix ?? SizedBox(),
                  iconData == null && iconWidget == null
                      ? SizedBox()
                      : Container(
                          padding: EdgeInsets.only(right: 20),
                          child: iconWidget ??
                              Icon(
                                iconData,
                                color: Theme.of(context).primaryColor,
                                size: 30,
                              )),
                  Expanded(
                      child: Container(
                          child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      customDescription ??
                          (description == null
                              ? SizedBox()
                              : Text(
                                  description,
                                  maxLines: maxLine,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppThemeUtils.normalSize(
                                      color:
                                          descrColor ?? AppThemeUtils.darkGrey,
                                      fontSize: descriptionSize ?? 18),
                                )),
                    ],
                  ))),
                  SizedBox(width: 10),
                ],
              ),
            ],
          ),
        )),
        Center(
            child: Container(
          child: customIcon ??
              (action != null
                  ? Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.black,
                      size: 30,
                    )
                  : SizedBox()),
        )),
        SizedBox(width: 10),
      ]));
}
