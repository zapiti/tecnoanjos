import 'dart:async';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecno_anjos_landing/app/utils/image/image_path.dart';
import 'package:tecno_anjos_landing/app/utils/theme/app_theme_utils.dart';
import 'home/home_view.dart';
import 'landing_page_bloc.dart';

import 'widget/navbar/navigation_drawer.dart';
import 'widget/navigation_bar/navigation_bar.dart';

ScrollController _scrollController = ScrollController();

void scrollToBottom() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.elasticOut);
    } else {
      Timer(Duration(milliseconds: 400), () => scrollToBottom());
    }
  });
}

class LandingPagePage extends StatefulWidget {
  final bool scrollBotton;

  LandingPagePage(this.scrollBotton);

  @override
  _LandingPagePageState createState() => _LandingPagePageState();
}

class _LandingPagePageState extends State<LandingPagePage> {
  var landingBloc = Modular.get<LandingPageBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.scrollBotton ?? false) {
      scrollToBottom();
    }

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
                      child: ListView(controller: _scrollController, children: [
                        Stack(children: <Widget>[
                          headerLandingPage(context),
                          Column(
                            children: [NavigationBar(), HomeView()],
                          )
                        ])
                      ])))));
    });
  }
}

Widget headerLandingPage(BuildContext context) {
  return ConstrainedBox(
      constraints: new BoxConstraints(minHeight: 600, maxHeight: 600),
      child: Image.asset(
        ImagePath.imageHeaderLandingPage,
        fit: BoxFit.fill,
        width: MediaQuery.of(context).size.width,
      ));
}
