import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjostec/app/app_bloc.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/notification/model/notification.dart';
import 'package:tecnoanjostec/app/utils/firebase/firebase_client_tecnoanjo.dart';


class NotificationBloc extends Disposable {
  var listNotification = BehaviorSubject<ResponsePaginated>();
  var deleteAllSubject = BehaviorSubject<bool>.seeded(false);
 static const String LISTNOTIFICATION = "LISTNOTIFICATION2";

  @override
  void dispose() {
    listNotification.close();
    deleteAllSubject.close();
  }

  salveNotification(MyNotification myNotification) async {
    deleteAllSubject.sink.add(false);
    Modular.get<FirebaseClientTecnoanjo>()
        .updateMessageNotification(myNotification);
  }

  removeNotification(MyNotification myNotification) async {
    clear();
    Modular.get<FirebaseClientTecnoanjo>()
        .deleteMessageNotification(myNotification);
  }

  void clear() {
    if (listNotification.stream.value.content is List) {
      if (listNotification.stream.value.content.length <= 1) {
        listNotification.sink.add(ResponsePaginated());
      }
    }
  }

  addTemp() {
    var list = [
      MyNotification(
          id: Modular.get<AppBloc>().dateNowWithSocket.stream.value.microsecondsSinceEpoch.toString(),
          title: "vai da bom",
          description: "teste",
          dtCreate: Modular.get<AppBloc>().dateNowWithSocket.stream.value.toString()),
      MyNotification(
          id: 2.toString(),
          title: "vai da bom",
          description: "teste",
          dtCreate: Modular.get<AppBloc>().dateNowWithSocket.stream.value.toString())
    ];
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      salveNotification(list.first);
    });
  }

  var appBloc = Modular.get<AppBloc>();

  Future<List> getListNotification() async {
    listNotification.sink.add(null);
    // var myList = await codePreferences.getString(key: LISTNOTIFICATION);
    var localNotification = [];
    //  addTemp();
    var user =   await  Modular.get<FirebaseClientTecnoanjo>().collectionDocUser();
    Modular.get<FirebaseClientTecnoanjo>()
        .countNotificationNotRead(user)
        .listen((event) {
      localNotification = [];

      var list = event.docs;
      if (list.length > 0) {
        appBloc.notificationsCount.sink.add(list.length.toString());
      } else {
        appBloc.notificationsCount.sink.add(null);
      }
    });
    Modular.get<FirebaseClientTecnoanjo>()
        .getListNotification(user)
        .listen((event) {
      localNotification = [];
      if (!deleteAllSubject.stream.value) {
        event.docs.forEach((doc) {
          var myNotification = MyNotification.fromMap(doc.data(),id:doc?.id);
          localNotification.add(myNotification);
          listNotification.sink
              .add(ResponsePaginated(content: localNotification));
        });
      }
    });

    listNotification.sink.add(ResponsePaginated(content: localNotification));
    return localNotification ?? [];
  }

  void deleteOne(MyNotification myNotification) {
    Modular.get<FirebaseClientTecnoanjo>()
        .updateMessageReadNotification(myNotification);
  }

  void readOne(MyNotification myNotification) {
    Modular.get<FirebaseClientTecnoanjo>()
        .updateMessageReadNotification(myNotification);
  }

  void deleteAll(List list) {
    clear();
    list.forEach((element) {
      if (element is MyNotification) {
        removeNotification(element);
      }
      listNotification.sink.add(ResponsePaginated());
    });
    deleteAllSubject.sink.add(true);
    clear();
  }

  void readAll(List list) {
    list.forEach((element) {
      if (element is MyNotification) {
        Modular.get<FirebaseClientTecnoanjo>()
            .updateMessageReadNotification(element);
      }
    });
  }
}
