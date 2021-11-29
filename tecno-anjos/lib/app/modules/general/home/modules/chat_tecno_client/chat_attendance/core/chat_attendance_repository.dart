import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/app_bloc.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/chat_tecno_client/chat_attendance/model/conversation.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';

class ChatAttendanceRepository {
  static const serviceGetChatMessages = 'CredParSP.getChatMessages';
  static const serviceSendMessage = 'CredParSP.sendMessage';



  static const serviceCreateChat = 'CredParSP.createChat';

  Stream<QuerySnapshot> getChatMessage(Attendance attendance, {bool  notRemove = false}) {

    if (!notRemove) {
      setSelected(attendance);
    }

    return Modular.get<AppBloc>()
        .firebaseReference()
        .collection('MESSAGE')
        .doc("CHAT_ATTENDANCE")
        .collection(attendance?.id.toString())
        .orderBy('send_hr')
        .snapshots();
  }

  sendMessage(
      Conversation conversation, Attendance attendance) async {
    Modular.get<AppBloc>()
        .firebaseReference()
        .collection('MESSAGE')
        .doc("CHAT_ATTENDANCE")
        .collection(attendance?.id.toString())
        .add(conversation.toMap());

    await setSelected(attendance);
  }

  Future setSelected(
    Attendance attendance,
  ) async {
    var dateTime =  MyDateUtils.getTrueTime();
    var chats = await Modular.get<AppBloc>()
        .firebaseReference()
        .collection('MESSAGE')
        .doc("CHAT_ATTENDANCE")
        .collection(attendance?.id.toString())
        .where("read_at", isNull: true)
        .get();

    chats.docs.forEach((element) {
      var converset = Conversation.fromMap(element.data());
      if (converset.sender?.id != attendance.userTecno?.id) {
        converset.readAt = MyDateUtils.parseDateTimeFormat(dateTime, null,
            format: "dd/MM/yyyy HH:mm:ss");
        Modular.get<AppBloc>()
            .firebaseReference()
            .collection('MESSAGE')
            .doc("CHAT_ATTENDANCE")
            .collection(attendance?.id.toString())
            .doc(element?.id)
            .set(converset.toMap());
      }
    });
  }
}
