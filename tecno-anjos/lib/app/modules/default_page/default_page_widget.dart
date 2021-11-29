import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tecnoanjostec/app/modules/default_page/widget/sidebar_menu..dart';
import 'package:tecnoanjostec/app/modules/drawer/drawer_page.dart';
import 'package:tecnoanjostec/app/modules/notification/notification_page.dart';
import 'package:tecnoanjostec/app/routes/constants_routes.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

import '../../app_bloc.dart';

class DefaultPageWidget extends StatefulWidget {
  final Widget childWeb;
  final Widget childMobile;
  final bool enableBar;

  const DefaultPageWidget(
      {@required this.childWeb,
      @required this.childMobile,
      this.enableBar = true});

  @override
  _DefaultPageWidgetState createState() => _DefaultPageWidgetState();
}

class _DefaultPageWidgetState extends State<DefaultPageWidget> {
  var appBloc = Modular.get<AppBloc>();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      appBloc.currentContext.sink.add(context);
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DefaultPageWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      appBloc.currentContext.sink.add(context);
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      appBloc.currentContext.sink.add(context);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      //  appBloc.currentContext.sink.add(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (!kIsWeb) {
        return widget.enableBar
            ? Scaffold(
          backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Text(
                      ConstantsRoutes.getNameByRoute(
                          ModalRoute.of(context).settings.name),
                      style: AppThemeUtils.normalSize(
                          color: AppThemeUtils.colorPrimary)),
                  centerTitle: true,
                  actions: [
                    Builder(builder: (contextNew) {
                      return IconButton(
                        icon:  StreamBuilder<String>(
                          stream: appBloc.notificationsCount,
                          builder: (context, snapshot) => Stack(
                            children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: Icon(snapshot.data == null ? Icons.notifications:Icons.notifications_active,
                                    color: AppThemeUtils.colorPrimary,size: snapshot.data == null ? 24 : 30,)),
                              snapshot.data == null ? Align( ):      Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.circle,
                                    color: Colors.red,
                                    size: 16,
                                  )),    Align(
                                  alignment: Alignment.center,
                                  child:Container(
                                      width: 11,
                                      child: Center(child:   AutoSizeText(  snapshot.data?? "",maxLines: 1,maxFontSize: 12,minFontSize: 2,)))),
                            ],
                          ),
                        ),
                        color: AppThemeUtils.colorPrimary,
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
                              : MediaQuery.of(context).size.width  < 2000 ? MediaQuery.of(context).size.width  * 0.8: 1700,
                          child: widget.childWeb)))
            ]));
      }
    }));
  }
}
