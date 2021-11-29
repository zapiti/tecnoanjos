import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/call_heaven/model/conversation.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';


class Bubble extends StatelessWidget {

  final MyConversation conversation;

  Bubble({this.conversation});

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: conversation.isMe ? EdgeInsets.only(left: 40) : EdgeInsets.only(right: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment:
            conversation.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment:
            conversation.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child:   Align(
                    child:  Text(
                      conversation.name ?? "--",
                      textAlign: conversation.isMe ? TextAlign.end : TextAlign.start,style: TextStyle(fontSize: 10),
                    ),
                    alignment: conversation.isMe ? Alignment.centerRight : Alignment.centerLeft,
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
                  crossAxisAlignment:
                  conversation.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      conversation.text ?? "",
                      textAlign: conversation.isMe ? TextAlign.end : TextAlign.start,
                      style: TextStyle(
                        color: conversation.isMe ? Colors.white : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child:   Align(
                child: Row(
                  mainAxisAlignment:conversation.isMe ? MainAxisAlignment.end :MainAxisAlignment.start,crossAxisAlignment:conversation.isMe ? CrossAxisAlignment.end:CrossAxisAlignment.start,
                  children: [
                    Text(
                      conversation.date  ?? "--",
                      textAlign: conversation.isMe ? TextAlign.end : TextAlign.start,style: TextStyle(fontSize: 8),
                    ),Icon(
                      conversation.received == 1 ? Icons.done_all: Icons.access_time,
                      size: 12,color: AppThemeUtils.colorPrimary,
                    ),
                  ],) ,
                alignment: conversation.isMe ? Alignment.centerRight : Alignment.centerLeft,
              ))
        ],
      ),
    );
  }
}
