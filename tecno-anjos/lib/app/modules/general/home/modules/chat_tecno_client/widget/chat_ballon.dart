import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/chat_tecno_client/chat_attendance/chat_attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/chat_tecno_client/chat_attendance/model/conversation.dart';

import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

class BubbleClient extends StatelessWidget {
  final conversationBloc = Modular.get<ChatAttendanceBloc>();
  final Conversation conversation;
  final Attendance attendance;

  BubbleClient({this.conversation, this.attendance});

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: conversation.isMe
          ? EdgeInsets.only(left: 40)
          : EdgeInsets.only(right: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment: conversation.isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: conversation.isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                    child: Text(
                      conversation.sender?.name ?? "--",
                      textAlign:
                          conversation.isMe ? TextAlign.end : TextAlign.start,
                      style: TextStyle(fontSize: 12),
                    ),
                    alignment: conversation.isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                  )),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: conversation.isMe
                      ? LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          stops: [
                              0.1,
                              1
                            ],
                          colors: [
                              AppThemeUtils.colorPrimaryDark,
                              AppThemeUtils.colorPrimary,
                            ])
                      : LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          stops: [
                              0.1,
                              1
                            ],
                          colors: [
                              Color(0xFFEBF5FC),
                              Color(0xFFEBF5FC),
                            ]),
                  borderRadius: conversation.isMe
                      ? BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(0),
                          bottomLeft: Radius.circular(15),
                        )
                      : BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(0),
                        ),
                ),
                child: Column(
                  crossAxisAlignment: conversation.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        conversation.body,
                        style: AppThemeUtils.normalSize(
                            color: conversation.isMe
                                ? AppThemeUtils.whiteColor
                                : AppThemeUtils.colorPrimary,
                            decoration: conversation.sendAt == null
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
              height: 12,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                child: Row(
                  mainAxisAlignment: conversation.isMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: conversation.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    conversation.sendAt != null
                        ? SizedBox()
                        : ElevatedButton(
                            onPressed: () {
                              conversationBloc.reSend(
                                  context, conversation, attendance);
                            },
                            child: Text(
                              "Reenviar",
                              style: AppThemeUtils.normalSize(
                                  fontSize: 12,
                                  color: AppThemeUtils.colorPrimary),
                            )),
                    Center(
                        child: Text(
                      conversation.sendAt ?? "Falha ao enviar",
                      textAlign:
                          conversation.isMe ? TextAlign.end : TextAlign.start,
                      style: TextStyle(
                        fontSize: 9,
                      ),
                    )),
                    Center(
                        child: Icon(
                      (conversation.readAt ?? "").isNotEmpty
                          ? Icons.done_all
                          : Icons.access_time,
                      size: 8,
                      color: (conversation.readAt ?? "").isNotEmpty
                          ? AppThemeUtils.colorPrimary
                          : AppThemeUtils.darkGrey,
                    )),
                  ],
                ),
                alignment: conversation.isMe
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
              ))
        ],
      ),
    );
  }
}
