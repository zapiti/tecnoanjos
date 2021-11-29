import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';

import 'package:tecnoanjostec/app/components/external/models/chat_message.dart';


import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/modules/notification/model/notification.dart';


import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';
import 'package:tecnoanjostec/app/utils/object/object_utils.dart';


import '../../app_bloc.dart';
import 'firebase_utils.dart';

class FirebaseClientTecnoanjo {
  static const COLLECTION_ATTENDANCE = "ATTENDANCE";
  static const COLLECTION_CURRENT_ATTENDANCE = "CURRENT-ATTENDANCE";
  static const REQUEST_ATTENDANCE = "REQUEST-ATTENDANCE";
  static const COLLECTION_CURRENT_ATTENDANCE_MAP = "CURRENT-ATTENDANCE-MAP";
  static const LATITUDE = "latitude";
  static const LONGITUDE = "longitude";
  static const LIST = "LIST";
  static const String AWAIT = "AWAIT";
  static const String INATTENDANCE = "IN_ATTENDANCE";

  String collectionDate() => "0";

  String collectionDocUser() {
    var appBloc = Modular.get<AppBloc>();
    var user = appBloc.getCurrentUserFutureValue().stream.value;
    return user?.id?.toString() ?? "-1";
  }

  setCollectionAccept(Attendance attendance) {}

  removeCollectionAccept() {}

  deleteAttendanceOnAwait(Attendance attendance) {}

  Stream getDataAttendanceSnapshotByID(String idAttendance) {
    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection(COLLECTION_ATTENDANCE)
        .doc(idAttendance)
        .collection(collectionDate())
        .doc(COLLECTION_CURRENT_ATTENDANCE)
        .snapshots();
  }

  Stream getDataAttendanceSnapshotByUser(user) {
    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection(COLLECTION_ATTENDANCE)
        .doc(user.toString())
        .collection(collectionDate())
        .doc(COLLECTION_CURRENT_ATTENDANCE)
        .snapshots();
  }

  removeCollection() {
    // db
    //     .collection(COLLECTION_ATTENDANCE)
    //     .doc(collectionDocUser())
    //     .collection(collectionDate())
    //     .doc(COLLECTION_CURRENT_ATTENDANCE)
    //     .delete();
  }

  setCollectionUser(Attendance attendance, user) {
    Modular.get<AppBloc>()
        .firebaseReference()
        .collection(COLLECTION_ATTENDANCE)
        .doc(user.toString())
        .collection(collectionDate())
        .doc(COLLECTION_CURRENT_ATTENDANCE)
        .set(attendance?.toMap());
  }

  setCollection(Attendance attendance) async {
    var user = await collectionDocUser();
    Modular.get<AppBloc>()
        .firebaseReference()
        .collection(COLLECTION_ATTENDANCE)
        .doc(user)
        .collection(collectionDate())
        .doc(COLLECTION_CURRENT_ATTENDANCE)
        .set(attendance?.toMap());
    Modular.get<AppBloc>()
        .firebaseReference()
        .collection(COLLECTION_ATTENDANCE)
        .doc(attendance?.userClient?.id.toString())
        .collection(collectionDate())
        .doc(COLLECTION_CURRENT_ATTENDANCE)
        .set(attendance?.toMap());
  }

  Stream<DocumentSnapshot> getDataAttedanceSnapshot(String user) {
    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection(COLLECTION_ATTENDANCE)
        .doc(user)
        .collection(collectionDate())
        .doc(COLLECTION_CURRENT_ATTENDANCE)
        .snapshots();
  }

  Future<DocumentSnapshot> getDataAttedanceFuture() async {
    var user = await collectionDocUser();
    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection(COLLECTION_ATTENDANCE)
        .doc(user)
        .collection(collectionDate())
        .doc(COLLECTION_CURRENT_ATTENDANCE)
        .get();
  }

  Stream<QuerySnapshot> getDataAcceptSnapshot() {
    String user = collectionDocUser();
    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection(REQUEST_ATTENDANCE)
        .doc(user)
        .collection(FirebaseClientTecnoanjo.LIST)
        // .collection(collectionDate())
        // .doc(COLLECTION_CURRENT_ATTENDANCE)
        .snapshots();
  }

  Future<QuerySnapshot> getDataAcceptFuture() async {
    var user = await collectionDocUser();
    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection(REQUEST_ATTENDANCE)
        .doc(user)
        .collection(FirebaseClientTecnoanjo.LIST)
        // .collection(collectionDate())
        // .doc(COLLECTION_CURRENT_ATTENDANCE)
        .get();
  }

  getCurrentAttendance(BuildContext context) async {
    var appBloc = Modular.get<AppBloc>();
    var user = await collectionDocUser();
    appBloc
        .firebaseReference()
        .collection(REQUEST_ATTENDANCE)
        .doc(user)
        .collection(FirebaseClientTecnoanjo.AWAIT)
        .snapshots()
        .listen((listSnapshot) {
      var listAttendance = listSnapshot.docs;
      if (listAttendance.isNotEmpty) {
        if (!appBloc.openAwaitPopup.stream.value) {
          appBloc.openAwaitPopup.sink.add(true);
        }
      } else {
        appBloc.openAwaitPopup.sink.add(false);
      }
    });
  }

  bool notExistsAttendance(Attendance atendimento) {
    var appBloc = Modular.get<AppBloc>();
    var user = collectionDocUser();
    if (atendimento == null) {
      return true;
    } else {
      if (atendimento.tecnoAvaliation == true &&
          atendimento.tecnoNF == true &&
          atendimento.status == ActivityUtils.FINALIZADO) {
        removeCollection();
        return true;
      } else if (atendimento.tecnoNF == true &&
          (atendimento.status == ActivityUtils.CANCELADO_CLIENTE ||
              atendimento.status == ActivityUtils.CANCELADO_TECNO ||
              atendimento.status == ActivityUtils.CANCELADO)) {
        removeCollection();
        return true;
      }
      if (atendimento.tecnoAvaliation == true) {
        removeCollection();
        return true;
      }
      if (atendimento.status == ActivityUtils.CANCELADO &&
          atendimento.tecnoNF == true) {
        return true;
      }
      if (atendimento.status == ActivityUtils.PENDENTE &&
          atendimento?.userTecno?.id != null) {
        removeCollection();
        return true;
      }
      if (atendimento?.userTecno?.id != null) {
        if (atendimento.userTecno.id.toString() != user) {
          return true;
        }
      }

      appBloc.addAvaliations.sink.add(false);
      return false;
    }
  }

  Stream<DocumentSnapshot> getDataMapSnapshot() {
    var user = collectionDocUser();
    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection(COLLECTION_ATTENDANCE)
        .doc(user)
        .collection(collectionDate())
        .doc(COLLECTION_CURRENT_ATTENDANCE_MAP)
        .snapshots();
  }

  Future<void> setCollectionMessage(
      Attendance attendance, ChatMessage message) async {
    var _infancy = Modular.get<AppBloc>().firebaseReference();

    var qtd = await _infancy
        .collection('Messages')
        .doc("AWAIT")
        .collection(attendance?.id.toString())
        .doc(attendance.userTecno?.id.toString())
        .get();

    var map = qtd.data();
    var tempTot = 0;
    if (map != null) {
      tempTot = ObjectUtils.parseToInt(map["count"]) + 1;
    }

    _infancy
        .collection('Messages')
        .doc("AWAIT")
        .collection(attendance?.id.toString())
        .doc(attendance.userTecno?.id.toString())
        .set({"count": tempTot});
  }

  Stream getMessage(Attendance attendance) {
    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection('Messages')
        .doc("AWAIT")
        .collection(attendance?.id.toString())
        .doc(attendance.userClient?.id.toString())
        .snapshots();
  }

  removeMessageView(Attendance attendance) async {
    var _intancia = Modular.get<AppBloc>().firebaseReference();
    _intancia
        .collection('Messages')
        .doc("AWAIT")
        .collection(attendance?.id.toString())
        .doc(attendance.userClient?.id.toString())
        .set({"count": 0});
  }

  updateMessageNotification(MyNotification myNotification) async {
    var user = await collectionDocUser();
    Modular.get<AppBloc>()
        .firebaseReference()
        .collection('NOTIFICATION')
        .doc("USER")
        .collection(user)
        .doc(myNotification?.id.toString())
        .set(myNotification.toMap());
  }

  updateListMessageReadNotification(List<MyNotification> listMyNotification) {
    listMyNotification.forEach((element) {
      element.read = true;
      updateMessageNotification(element);
    });
  }

  updateMessageReadNotification(MyNotification myNotification) {
    myNotification.read = true;
    updateMessageNotification(myNotification);
  }

  Stream<QuerySnapshot> getListNotification(String user) {
    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection('NOTIFICATION')
        .doc("USER")
        .collection(user)
        .where("delete", isEqualTo: false)
        .snapshots();
  }

  deleteMessageNotification(MyNotification myNotification) {
    myNotification.delete = true;
    updateMessageNotification(myNotification);
  }

  Stream<QuerySnapshot> countNotificationNotRead(String user) {
    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection('NOTIFICATION')
        .doc("USER")
        .collection(user)
        .where("read", isEqualTo: false)
        .where("delete", isEqualTo: false)
        .snapshots();
  }

  Stream<DocumentSnapshot> getTeamViewUrl() {
    FirebaseFirestore db = GetIt.I.get<FirebaseFirestore>();
    return db
        .collection(FirebaseUtils.SERVER_DEFAULT)
        .doc(FirebaseUtils.TEAM_VIEW_URL)
        .snapshots();
  }

  getActualVersion() {
    FirebaseFirestore db = GetIt.I.get<FirebaseFirestore>();
    return db
        .collection(FirebaseUtils.SERVER_DEFAULT)
        .doc(FirebaseUtils.VERSAOATUAL)
        .snapshots();
  }

  void successInLocal(Attendance attendance) {
    Modular.get<AppBloc>()
        .firebaseReference()
        .collection(INATTENDANCE)
        .doc(attendance.id.toString())
        .set({"status": "S"});
  }

  void updateInLocal(Attendance attendance) {
    if(attendance.address == null) {
      return null;
    }else{
      Modular.get<AppBloc>()
          .firebaseReference()
          .collection(INATTENDANCE)
          .doc(attendance.id.toString())
          .set({"status": "E"});
    }

  }

  void sendInLocal(Attendance attendance) {
    Modular.get<AppBloc>()
        .firebaseReference()
        .collection(INATTENDANCE)
        .doc(attendance.id.toString())
        .set({"status": "A"});
  }

  Stream<DocumentSnapshot> streamInLocal(Attendance attendance) {
    if(attendance.address == null) {
      return null;
    }else{
      return Modular.get<AppBloc>()
          .firebaseReference()
          .collection(INATTENDANCE)
          .doc(attendance.id.toString())
          .snapshots();
    };

  }

  void deleteInLocal(Attendance attendance) {
    Modular.get<AppBloc>()
        .firebaseReference()
        .collection(INATTENDANCE)
        .doc(attendance.id.toString())
        .delete();
  }
}
