import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/default_page/widget/sidebar_menu..dart';
import 'package:tecnoanjosclient/app/modules/drawer/drawer_page.dart';

import 'package:tecnoanjosclient/app/modules/notification/notification_bloc.dart';
import 'package:tecnoanjosclient/app/modules/notification/notification_page.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';

import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../app_bloc.dart';

final keyButton3 = GlobalKey();

class DefaultPageWidget extends StatefulWidget {
  final Widget childWeb;
  final Widget childMobile;
  final bool enableBar;
  final bool enableBack;

  const DefaultPageWidget(
      {@required this.childWeb,
      @required this.childMobile,
      this.enableBar = true,
      this.enableBack = false});

  @override
  _DefaultPageWidgetState createState() => _DefaultPageWidgetState();
}

class _DefaultPageWidgetState extends State<DefaultPageWidget> {
  final appBloc = Modular.get<AppBloc>();
  var notificationBloc = Modular.get<NotificationBloc>();
  final keyButton = GlobalKey();
  final keyButton2 = GlobalKey();
  final myKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = List.from([]);

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute
          .of(context)
          .settings
          .name == ConstantsRoutes.HOMEPAGE) {
        appBloc.getFirstOnboard((){
          initTargets();
          showTutorial();
        });

      }
    });


    notificationBloc.getListNotification();
  }

  @override
  Widget build(BuildContext ctx) {
    appBloc.currentContext.sink.add(ctx);

    if (!kIsWeb) {
      return widget.enableBar
              ? Scaffold(
        key: _scaffoldKey,
                  endDrawerEnableOpenDragGesture: false,
                  appBar: AppBar(
                    leading: IconButton(
                      key: keyButton2,
                      icon: Icon(Icons.menu),
                      onPressed: () {

                        print( _scaffoldKey.currentState.isDrawerOpen);
                      _scaffoldKey.currentState.openDrawer();
                      },
                    ),
                    title: Text(
                      ConstantsRoutes.getNameByRoute(
                          ModalRoute.of(context).settings.name),
                      style: AppThemeUtils.normalBoldSize(
                          color: Colors.white, fontSize: 18),
                    ),
                    centerTitle: true,
                    actions: [

                      Builder(builder: (contextNew) {
                        return IconButton(
                          key: keyButton,
                          icon: StreamBuilder<String>(
                            stream: appBloc.notificationsCount,
                            builder: (context, snapshot) => Stack(
                              children: [
                                Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      snapshot.data == null
                                          ? Icons.notifications
                                          : Icons.notifications_active,
                                      color: AppThemeUtils.whiteColor,
                                      size: snapshot.data == null ? 24 : 30,
                                    )),
                                snapshot.data == null
                                    ? Align()
                                    : Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.circle,
                                          color: Colors.red,
                                          size: 16,
                                        )),
                                Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                        width: 11,
                                        child: Center(
                                            child: AutoSizeText(
                                          snapshot.data ?? "",
                                          maxLines: 1,
                                          maxFontSize: 12,
                                          minFontSize: 2,
                                        )))),
                              ],
                            ),
                          ),
                          color: AppThemeUtils.whiteColor,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationPage()),
                            );
                          },
                        );
                      })
                    ],
                  ),
                  drawer: Modular.get<DrawerPage>(),
                  body: widget.childMobile,
                )
              : widget.childMobile;
    } else {
      return Material(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            Modular.get<SideBarMenu>(),
            SizedBox(
              width: 5,
            ),
            Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                        width: MediaQuery.of(context).size.width < 600
                            ? 600
                            : MediaQuery.of(context).size.width < 2000
                                ? MediaQuery.of(context).size.width * 0.8
                                : 1700,
                        child: widget.childWeb)))
          ]));
    }
  }

  void initTargets() {
    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: keyButton2,
        color: AppThemeUtils.colorPrimaryDark2,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Menu",
                    style: AppThemeUtils.normalBoldSize(
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Toque no menu lateral e veja todos nossos serviços",
                      style: AppThemeUtils.normalSize(color: Colors.white,fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
        shape: ShapeLightFocus.Circle,
        radius: 5,
      ),
    );

    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: keyButton,
        color: AppThemeUtils.colorPrimaryDark2,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Notificações",
                    style: AppThemeUtils.normalBoldSize(
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Toque aqui para ver as notificações e notícias",
                      style: AppThemeUtils.normalSize(color: Colors.white,fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
        shape: ShapeLightFocus.Circle,
        radius: 5,
      ),
    );



    targets.add(
      TargetFocus(
        identify: "Target 3",
        keyTarget: keyButton3,
        color: AppThemeUtils.colorPrimaryDark2,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Tecnoanjos",
                    style: AppThemeUtils.normalBoldSize(
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Toque aqui e segure para pedir sua ajuda tecnológica",
                      style: AppThemeUtils.normalSize(color: Colors.white,fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
        shape: ShapeLightFocus.Circle,
        radius: 5,
      ),
    );
  }

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.red,hideSkip: true,
      textSkip: "Pular",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        appBloc.setFirstOnboard(false,firstOnly: true);
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onSkip: () {
        appBloc.setFirstOnboard(false,firstOnly: true);
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
    )..show();
  }
}
