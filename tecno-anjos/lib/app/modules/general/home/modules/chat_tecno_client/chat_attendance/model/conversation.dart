import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/models/profile.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';
import '../../../../../../../app_bloc.dart';



class Conversation {
  static const IDENTIFICADOR = "<div><br></div>";

  String id;
  String body;

  Profile sender;
  String sendAt;
  String readAt;
  String sendHr;
  bool isMe;

  // == operator
  bool operator ==(o) => o?.id == this.id;

  Conversation(
      {this.id,
      this.body,
      this.sender,
      this.sendAt,
      this.readAt,
      this.isMe,
      this.sendHr});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'body': body,
      'sender': sender?.toMap(),
      'send_at': sendAt,
      'read_at': readAt,
      'send_hr': sendHr ??
          MyDateUtils.parseDateTimeFormat(
              Modular.get<AppBloc>().dateNowWithSocket.stream.value, null,
              format: "HHmmss"),
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
      isMe: Modular.get<AppBloc>().getCurrentUserFutureValue().stream.value?.id ==
          Profile.fromMap(map['sender'])?.id,
    );
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

}
