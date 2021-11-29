import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tecnoanjosclient/app/app_bloc.dart';

import 'package:tecnoanjosclient/app/components/external/models/chat_message.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';



import 'package:tecnoanjosclient/app/modules/notification/model/notification.dart';

import 'package:tecnoanjosclient/app/utils/firebase/firebase_utils.dart';
import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';

import '../attendance/activity_utils.dart';


class FirebaseClientTecnoanjo extends Disposable {
  static const REQUEST_ATTENDANCE = "REQUEST-ATTENDANCE";
  static const COLLECTION_ATTENDANCE = "ATTENDANCE";
  static const IN_ATTENDANCE = "IN-ATTENDANCE";
  static const COLLECTION_CURRENT_ATTENDANCE = "CURRENT-ATTENDANCE";
  static const COLLECTION_CURRENT_ATTENDANCE_MAP = "CURRENT-ATTENDANCE-MAP";
  static const LATITUDE = "latitude";
  static const LONGITUDE = "longitude";
  static const String INATTENDANCE = "IN_ATTENDANCE";
  static const String LIST = "LIST";

  static const String AWAIT = "AWAIT";

  String collectionDate() => "0";
  var getDataAcceptSnapshotSubject = BehaviorSubject<Attendance>();
  var getDataAwaitSnapshotSubject = BehaviorSubject<Attendance>();

  @override
  void dispose() {
    getDataAwaitSnapshotSubject.drain();
    getDataAcceptSnapshotSubject.drain();
  }



  // MyDateUtils.parseDateTimeFormat(Modular.get<AppBloc>().dateNowWithSocket.stream.value, format: "dd-MM-yyyy");

  Future<String> collectionDocUser() async{
    final appBloc = Modular.get<AppBloc>();
    var user =  appBloc.getCurrentUserFutureValue().stream.value;
    //  return "155";
    return user?.id?.toString() ?? "-1";
  }

  removeCollection() async {
    var user = await collectionDocUser();
    Modular.get<AppBloc>()
        .firebaseReference()
        .collection(COLLECTION_ATTENDANCE)
        .doc(user)
        .collection(collectionDate())
        .doc(COLLECTION_CURRENT_ATTENDANCE)
        .delete();
  }

  removeCollectionDoubleCheck(String codAttendance) {
    Modular.get<AppBloc>()
        .firebaseReference()
        .collection(IN_ATTENDANCE)
        .doc(codAttendance)
        .collection(collectionDate())
        .doc(COLLECTION_CURRENT_ATTENDANCE)
        .delete();
  }

  getCurrentAttendance(BuildContext context) {

  }

  setCollectionAccept(Attendance attendance) {
    // db
    //     .collection(REQUEST_ATTENDANCE)
    //     .doc(collectionDocUser())
    //     .set(attendance.toMap());
  }

  deleteMessageNotification(MyNotification myNotification) {
    myNotification.delete = true;
    updateMessageNotification(myNotification);
  }

  updateMessageNotification(MyNotification myNotification) async {
    var user = await collectionDocUser();
    Modular.get<AppBloc>().firebaseReference()
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

  Stream<QuerySnapshot> getListNotification( String user)  {

    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection('NOTIFICATION')
        .doc("USER")
        .collection(user)
        .where("delete", isEqualTo: false)
        .snapshots();
  }

  Stream<QuerySnapshot> countNotificationNotRead(String user)  {

    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection('NOTIFICATION')
        .doc("USER")
        .collection(user)
        .where("read", isEqualTo: false)
        .where("delete", isEqualTo: false)
        .snapshots();
  }

  getTimeServer() {}

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
        .set(attendance.toMap());
  }

  deleteMyAttendanceOnAwait() {
    // db
    //     .collection(REQUEST_ATTENDANCE)
    //     .doc(collectionDocUser())
    //     .delete();
  }

  deleteAttendanceOnAwait(Attendance attendance) {
    try {
    } catch (e) {
      print("erro no cancelamento $e");
    }
  }

  Stream<DocumentSnapshot> getDataAttedanceSnapshot(String user)  {
    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection(COLLECTION_ATTENDANCE)
        .doc(user)
        .collection(collectionDate())
        .doc(COLLECTION_CURRENT_ATTENDANCE)
        .snapshots();
  }

  void getDataAcceptSnapshot(String user)  {
    if(user != null) {
      Modular.get<AppBloc>()
          .firebaseReference()
          .collection(REQUEST_ATTENDANCE)
          .doc(user)
          .collection(FirebaseClientTecnoanjo.LIST)
          .snapshots().listen((event) {
        if (event.docs.isNotEmpty) {
          final attendance =
          Attendance.fromMap(event.docs.first.data());
          getDataAcceptSnapshotSubject.sink.add(attendance);
        } else {
          resetAcceptAttendance();
        }
      });
    }
  }

  void resetAcceptAttendance() {
    Future.delayed(Duration(seconds: 2),(){
      getDataAcceptSnapshotSubject.sink.add(null);
    });

  }
  void getDataAwaitSnapshot(String user)  {

    if(user != null) {
      Modular.get<AppBloc>()
          .firebaseReference()
          .collection(FirebaseClientTecnoanjo.REQUEST_ATTENDANCE)
          .doc(user)
          .collection(FirebaseClientTecnoanjo.AWAIT)
          .snapshots().listen((event) {
        if (event.docs.isNotEmpty) {
          final attendance =
          Attendance.fromMap(event.docs.first.data());
          getDataAwaitSnapshotSubject.sink.add(attendance);
        } else {
          resetAttendance();
        }
      });
    }
  }

  void resetAttendance() {
    Future.delayed(Duration(seconds: 2),(){
      getDataAwaitSnapshotSubject.sink.add(null);
    });

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

  void removeAcceptCollection() {
    // Modular.get<AppBloc>()
    //     .firebaseReference()
    //     .collection(REQUEST_ATTENDANCE)
    //     .doc(collectionDocUser()) .collection(FirebaseClientTecnoanjo.LIST)
    //     .delete();
  }

  bool notExistsAttendance(Attendance atendimento) {
    final appBloc = Modular.get<AppBloc>();
    if (atendimento == null) {
      return true;
    } else {
      // if (atendimento.clientNF == true &&
      //     atendimento.tecnoNF == true &&
      //     atendimento.tecnoAvaliation == true &&
      //     atendimento.clientAvaliation == true &&
      //     atendimento.status == ActivityUtils.FINALIZADO) {
      //   removeCollection();
      // }


      if (atendimento.clientNF == true &&
          atendimento.clientAvaliation == true &&
          atendimento.status == ActivityUtils.FINALIZADO) {
        removeCollection();
        return true;
      } else if (atendimento.clientNF == true &&
          (atendimento.status == ActivityUtils.CANCELADO_CLIENTE ||
              atendimento.status == ActivityUtils.CANCELADO_TENO ||
              atendimento.status == ActivityUtils.CANCELADO)) {
        removeCollection();
        return true;
      }
      if (atendimento.status == ActivityUtils.PENDENTE &&
          atendimento?.userTecno?.id != null) {
        removeCollection();
        return true;
      }
      if (atendimento.clientAvaliation == true) {
        removeCollection();
        return true;
      }
      if (atendimento.status == ActivityUtils.CANCELADO &&
          atendimento.clientNF == true) {
        return true;
      }

      appBloc.addAvaliations.sink.add(false);
      return false;
    }
  }

  Stream getDataAttendanceSnapshotByID(String idAttendance) {
    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection(COLLECTION_ATTENDANCE)
        .doc(idAttendance)
        .collection(collectionDate())
        .doc(COLLECTION_CURRENT_ATTENDANCE)
        .snapshots();
  }

  Stream getDataAttendanceSnapshotByUser(String user) {
    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection(COLLECTION_ATTENDANCE)
        .doc(user.toString())
        .collection(collectionDate())
        .doc(COLLECTION_CURRENT_ATTENDANCE)
        .snapshots();
  }

  getDataMapSnapshot(String user) {
    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection(COLLECTION_ATTENDANCE)
        .doc(user)
        .collection(collectionDate())
        .doc(COLLECTION_CURRENT_ATTENDANCE_MAP)
        .snapshots();
  }

  // void updateLocation(LocationData cLoc) {
  //   Modular.get<AppBloc>()
  //       .firebaseReference()
  //       .collection(COLLECTION_ATTENDANCE)
  //       .doc(collectionDocUser())
  //       .collection(collectionDate())
  //       .doc(COLLECTION_CURRENT_ATTENDANCE_MAP)
  //       .set({
  //     'latitude': cLoc.latitude,
  //     'longitude': cLoc.longitude,
  //     'accuracy': cLoc.accuracy,
  //     'altitude': cLoc.altitude,
  //     'speed': cLoc.speed,
  //     'speed_accuracy': cLoc.speedAccuracy,
  //     'heading': cLoc.heading,
  //     'time': cLoc.time,
  //   });
  // }

  Future<void> setCollectionMessge(
      Attendance attendance, ChatMessage message) async {
    var _intancia = Modular.get<AppBloc>().firebaseReference();

    var qtd = await _intancia
        .collection('Messages')
        .doc("AWAIT")
        .collection(attendance?.id.toString())
        .doc(attendance.userClient?.id.toString())
        .get();

    var map = qtd.data();
    var tempTot = 0;
    if (map != null) {
      tempTot = ObjectUtils.parseToInt(map["count"]) + 1;
    }

    _intancia
        .collection('Messages')
        .doc("AWAIT")
        .collection(attendance?.id.toString())
        .doc(attendance.userClient?.id.toString())
        .set({"count": tempTot});
  }

  Stream getMessage(Attendance attendance) {
    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection('Messages')
        .doc("AWAIT")
        .collection(attendance?.id.toString())
        .doc(attendance.userTecno?.id.toString())
        .snapshots();
  }

  removeMessageView(Attendance attendance) async {
    var _intancia = Modular.get<AppBloc>().firebaseReference();
    _intancia
        .collection('Messages')
        .doc("AWAIT")
        .collection(attendance?.id.toString())
        .doc(attendance.userTecno?.id.toString())
        .set({"count": 0});
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
    }

  }

  void deleteInLocal(Attendance attendance) {
     Modular.get<AppBloc>()
        .firebaseReference()
        .collection(INATTENDANCE)
        .doc(attendance.id.toString())
        .delete();
  }

}
