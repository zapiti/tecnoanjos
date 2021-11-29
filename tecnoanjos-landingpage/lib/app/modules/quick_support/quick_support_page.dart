import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecno_anjos_landing/app/modules/landing_page/widget/navbar/navigation_drawer.dart';
import 'package:tecno_anjos_landing/app/modules/landing_page/widget/navigation_bar/navigation_bar.dart';
import 'package:tecno_anjos_landing/app/modules/quick_support/widget/quick_support_view.dart';
import 'package:tecno_anjos_landing/app/utils/image/image_path.dart';
import 'package:tecno_anjos_landing/app/utils/theme/app_theme_utils.dart';
class QuickSupportPage extends StatefulWidget {
  @override
  _QuickSupportPageState createState() => _QuickSupportPageState();
}

class _QuickSupportPageState extends State<QuickSupportPage> {


  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {


    return LayoutBuilder(builder: (context, constraint) {
      return Center(
          child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 2048),
              child: Scaffold(
                  drawer: constraint.maxWidth <= 800
                      ? Modular.get<NavigationDrawer>()
                      : null,
                  body: DraggableScrollbar.rrect(
                      controller: _scrollController,
                      heightScrollThumb:
                      MediaQuery.of(context).size.height * 0.2,
                      backgroundColor: AppThemeUtils.colorPrimaryDark,
                      scrollbarTimeToFade: Duration(days: 1),
                      alwaysVisibleScrollThumb: true,
                      padding: EdgeInsets.only(top: 0, bottom: 0),
                      child: ListView(controller: _scrollController, children: [ Stack(children: <Widget>[
                            headerLandingPage(context),
                            Column(
                              children: [NavigationBar(), QuickSupportView()],
                            )
                          ])])))));
    });


  }
}

Widget headerLandingPage(BuildContext context) {
  return ConstrainedBox(
      constraints: new BoxConstraints(minHeight: 600, maxHeight: 600),
      child: Image.asset(
        ImagePath.imageHeaderLandingPage,fit: BoxFit.fill,


        width: MediaQuery.of(context).size.width,
      ));
}
