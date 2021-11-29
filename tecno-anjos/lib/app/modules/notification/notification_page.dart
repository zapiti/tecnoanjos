import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/app_bloc.dart';
import 'package:tecnoanjostec/app/components/builder/builder_component.dart';
import 'package:tecnoanjostec/app/components/builder/builder_infinity_listView_component.dart';
import 'package:tecnoanjostec/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';

import 'package:tecnoanjostec/app/modules/notification/notification_bloc.dart';
import 'package:tecnoanjostec/app/utils/amplitude/amplitude_util.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';

import 'package:tecnoanjostec/app/utils/object/object_utils.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

import 'model/notification.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var notificationBloc = Modular.get<NotificationBloc>();
  var appBLoc = Modular.get<AppBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AmplitudeUtil.createEvent(AmplitudeUtil.eventoEntrouNaTela( "NOTIFICAÇÃO".toUpperCase()));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringFile.notificacoes,
          style: AppThemeUtils.normalSize(color: AppThemeUtils.colorPrimary),
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
      ),
      body: builderComponent<ResponsePaginated>(
          stream: notificationBloc.listNotification,
          emptyMessage: StringFile.naoANotificacoes,
          initCallData: () {
            notificationBloc.getListNotification();
          },
          buildBodyFunc: (context, response) => Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric( horizontal: 20),
                child: StreamBuilder<String>(
                    stream: appBLoc.notificationsCount,
                    initialData: "0",
                    builder: (context, snapshot) => Row(
                      children: [
                        Expanded(
                          child: Text(
                            (snapshot.data ?? "0") + "\nNotificações\nnão lidas",
                            textAlign: TextAlign.center,
                            style:
                            AppThemeUtils.normalSize(fontSize: 18),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 2,
                          color: AppThemeUtils.colorPrimary,
                        ),
                        Expanded(
                          child: Text(
                            (    ObjectUtils.parseToInt(response.content?.length) -
                                ObjectUtils.parseToInt(
                                    snapshot.data))
                                .toString() +
                                "\nNotificações\nlidas",
                            textAlign: TextAlign.center,
                            style:
                            AppThemeUtils.normalSize(fontSize: 18),
                          ),
                        )
                      ],
                    )),
              ),lineViewWidget(),
              Container(

                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                height: 50,
                  child:ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white),
                          onPressed: () {notificationBloc.readAll(response.content);},
                          child: Text(
                            StringFile.marcarTodosComoLida,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: AppThemeUtils.colorPrimary),
                          ))),
                    ),
                    Container(

                      width: 2,
                      color: AppThemeUtils.colorPrimary,
                    ),
                    Expanded(
                      child:Container(
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white),
                          onPressed: () {notificationBloc.deleteAll(response.content);},
                          child: Text(
                            StringFile.excluirTodos,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: AppThemeUtils.colorPrimary),
                          ))),
                    )
                  ],
                ),
              ),lineViewWidget(),
              Expanded(
                child: builderInfinityListViewComponent(response,
                    buildBody: (content) => _itemNotification(content)),
              )
            ],
          )),
    );
  }
}

_itemNotification(MyNotification notification) {
  var notificationBloc = Modular.get<NotificationBloc>();
  return BaseListTile(
      createAt: MyDateUtils.parseDateTimeFormat(notification.dtCreate, null,
          format: "dd/MM/yyyy HH:mm"),
      leading: Icon(
        notification.read == true ? Icons.email_outlined : Icons.email,
        color: notification.read == true
            ? AppThemeUtils.colorError
            : AppThemeUtils.colorPrimary,
      ),
      title: notification.title,
      subtitle: notification.description,
      trailing: notification.read == true
          ? IconButton(
        icon: Icon(
          Icons.delete,
          color: AppThemeUtils.colorError,
        ),
        onPressed: () {
          notificationBloc.removeNotification(notification);
        },
      )
          : Column(
        children: [
          IconButton(
            icon: Icon(
              Icons.check_circle,
              color: AppThemeUtils.colorPrimary,
            ),
            onPressed: () {
              notificationBloc.readOne(notification);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: AppThemeUtils.colorError,
            ),
            onPressed: () {
              notificationBloc.removeNotification(notification);
            },
          )
        ],
      ));
}

class BaseListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String createAt;
  final Widget leading;
  final Widget trailing;

  BaseListTile({
    this.title,
    this.subtitle,
    this.createAt,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.all(8),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.white,
                    child: Text(
                      createAt ?? "",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    )),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: leading,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(2),
                            ),
                            Text(
                              title ?? "",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(2),
                            ),
                            Text(
                              subtitle ?? "",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: trailing,
                    )
                  ],
                ),
              ],
            )),
        lineViewWidget()
      ],
    );
  }
}
