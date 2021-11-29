

import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/utils/date_utils.dart';




class MyConversationTecnoClient {
  bool isMe = true;
  String id;
  String message;
  String dataSend ;
  String roomName;
  String userId;
  String userName;
  String userImage;

  static const server = "SERVER";

  static const appMaker = 'CLIENTE';

  MyConversationTecnoClient({this.isMe, this.role, this.text, this.received,this.id,this.date,this.image,this.room,this.name});

  static Future<MyConversationTecnoClient> fromMap(Map<String, dynamic> map,Attendance attendance) async {

    var date =  MyDateUtils.parseDateTimeFormat(map['date'],null,format: "HH:mm");
    try {
      return new MyConversationTecnoClient(
        name: map['role'] == appMaker ? attendance?.userClient?.name : attendance.userTecno.name ,
        id: map['id'].toString(),
        isMe: map['role'] == appMaker,
        role: map['role'] as String,
        text: map['text'] as String,
        room: map['room'].toString(),
        date: date,
        image: map['role'] == appMaker ? attendance.userClient.pathImage : attendance.userTecno.pathImage ,
        received: 1,
      );
    } catch (e) {
      return null;
    }
  }

  factory MyConversationTecnoClient.fromMapText(String text,Attendance attendance) {
    try {
      return new MyConversationTecnoClient(
        isMe: true,
        role: MyConversationTecnoClient.appMaker,
        room:attendance?.id.toString(),
        text:text,
      );
    } catch (e) {
      return null;
    }
  }



  Future<Map<String, dynamic>> toMapText(Attendance attendance) async {
    var _dateTime =  await MyDateUtils.getTrueTime();
    return  {
      "name":attendance?.userClient?.name,
      "text": this.text,
      "role": MyConversationTecnoClient.appMaker,
      "id": attendance.userClient?.id,
      "date":  MyDateUtils.convertDateToDate(_dateTime,_dateTime).toString(),
      'room':attendance?.id,
      "image":attendance.userClient?.pathImage,
    };
  }
}
