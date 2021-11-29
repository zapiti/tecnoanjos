import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/models/profile.dart';

import '../../../../../../../app_bloc.dart';




class Conversation {
  static const identificador = "<div><br></div>";

  String id;
  String body;

  Profile sender;
  String sendAt;
  String readAt;
  String sendHr;
  bool isMe;


  Conversation({this.id, this.body, this.sender, this.sendAt, this.readAt, this. isMe,this.sendHr});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'body': body,
      'sender': sender?.toMap(),
      'send_at': sendAt,
      'read_at': readAt,
      'send_hr':sendHr,
      'isMe': isMe,
    };
  }

  factory Conversation.fromMap(dynamic map) {
    if (null == map) return null;

    return Conversation(
      id: map['id']?.toString() ?? "",
      body: map['body']?.toString() ?? "",
      sender: Profile.fromMap(map['sender']),
      sendAt: map['send_at']?.toString() ?? "",
      sendHr: map['send_hr']?.toString() ?? "",
      readAt: map['read_at']?.toString() ?? "",
      isMe: Modular.get<AppBloc>().getCurrentUserFutureValue().stream.value?.id ==  Profile.fromMap(map['sender'])?.id,
    );
  }
}


