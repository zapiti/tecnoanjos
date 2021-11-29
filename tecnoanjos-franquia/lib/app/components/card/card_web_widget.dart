import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tecnoanjos_franquia/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjos_franquia/app/routes/constants_routes.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';

class CardWebWidget extends StatelessWidget {

  final Widget child;
  final Widget subTitle;
  final String title;

  CardWebWidget({
    @required this.child, this.title, this.subTitle
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(0),
          child: Card(
            elevation: 1,
            shadowColor: Colors.black,
            clipBehavior: Clip.none,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              Container(child: Text(title ?? ConstantsRoutes.getNameByRoute(
                  ModalRoute
                      .of(context)
                      .settings
                      .name),style: AppThemeUtils.normalBoldSize(color: AppThemeUtils.colorPrimary,fontSize: 22),), margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),),
              subTitle ?? SizedBox(),
            lineViewWidget(),
            Expanded(child:  Container(
            margin: EdgeInsets.all(10),
    padding: EdgeInsets.all(0),
    child: child))
            ],),
          ),
        ));
  }
}

