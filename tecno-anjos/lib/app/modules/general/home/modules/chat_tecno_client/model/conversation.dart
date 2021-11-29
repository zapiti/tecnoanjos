import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';

import '../../../../../../app_bloc.dart';



class MyConversationTecClient {
  bool isMe = true;
  String role;
  String text;
  int received;
  String dataSend;

  String id;
  String date;
  String image;
  String room;
  String name;
  static const server = "SERVER";

  static const appMaker = 'TECNOANJO';

  MyConversationTecClient(
      {this.isMe,
      this.role,
      this.text,
      this.received,
      this.id,
      this.date,
      this.image,
      this.room,
      this.name});

  factory MyConversationTecClient.fromMap(
      Map<String, dynamic> map, Attendance attendance) {
    try {
      return new MyConversationTecClient(
        name: map['role'] == appMaker
            ? attendance.userTecno.name
            : attendance?.userClient?.name,
        id: map['id'].toString(),
        isMe: map['role'] == appMaker,
        role: map['role'] as String,
        text: map['text'] as String,
        room: map['room'].toString(),
        date:
            MyDateUtils.parseDateTimeFormat(map['date'], null, format: "HH:mm"),
        image: map['role'] == appMaker
            ? attendance.userTecno.pathImage
            : attendance.userClient.pathImage,
        received: 1,
      );
    } catch (e) {
      return null;
    }
  }

  factory MyConversationTecClient.fromMapText(
      String text, Attendance attendance) {
    try {
      return new MyConversationTecClient(
        isMe: true,
        role: MyConversationTecClient.appMaker,
        room: attendance?.id.toString(),
        text: text,
      );
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toMapText(Attendance attendance) {
    return {
      "name": attendance.userTecno.name,
      "text": this.text,
      "role": MyConversationTecClient.appMaker,
      "id": attendance.userTecno?.id,
      "date": MyDateUtils.convertDateToDate(
              Modular.get<AppBloc>().dateNowWithSocket.stream.value, null)
          .toString(),
      'room': attendance?.id,
      "image": attendance.userTecno.pathImage,
    };
  }
}
