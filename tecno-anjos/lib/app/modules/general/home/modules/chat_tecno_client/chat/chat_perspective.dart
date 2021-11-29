import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:tecnoanjostec/app/app_bloc.dart';
import 'package:tecnoanjostec/app/components/bublle.dart';
import 'package:tecnoanjostec/app/components/external/chat_view.dart';
import 'package:tecnoanjostec/app/components/external/models/chat_message.dart';
import 'package:tecnoanjostec/app/components/external/models/chat_user.dart';
import 'package:tecnoanjostec/app/components/external/models/reply.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/chat_tecno_client/chat_attendance/chat_attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/chat_tecno_client/chat_attendance/chat_attendance_page.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/profile_bloc.dart';

import 'package:tecnoanjostec/app/utils/date/date_utils.dart';
import 'package:tecnoanjostec/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

class ChatPerspective extends StatelessWidget {
 final Attendance attendance;

  ChatPerspective(this.attendance);

  @override
  Widget build(BuildContext context) {
    return ChatAttendancePage(attendance);
  }
}

class _MyChatPage extends StatefulWidget {
 final Attendance attendance;

  _MyChatPage(this.attendance);

  @override
  _MyChatPageState createState() => _MyChatPageState();
}

class _MyChatPageState extends State<_MyChatPage> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  var profileBloc = Modular.get<ProfileBloc>();
  ChatUser user;
  var textController = TextEditingController();
  var controller = TextEditingController();
  ChatUser otherUser;

  List<ChatMessage> messages = List<ChatMessage>.from([]);
  var m = List<ChatMessage>.from([]);

  var i = 0;

  @override
  void initState() {
    var appBloc = Modular.get<AppBloc>();
 appBloc.getCurrentUserFutureValue().listen((value) {

      Modular.get<FirebaseClientTecnoanjo>().removeMessageView(widget.attendance);
      appBloc.notificationsMSGCount.sink.add(null);
      user = ChatUser(
        name: widget.attendance?.userTecno?.name,
        firstName: widget.attendance?.userTecno?.name,
        lastName: "",
        uid: widget.attendance?.userTecno?.id?.toString() ?? value?.id,
        avatar: widget.attendance?.userTecno?.pathImage,
      );
      otherUser = ChatUser(
        name: widget.attendance?.userClient?.name,
        firstName: widget.attendance?.userClient?.name?.split(" ")[0],
        lastName: "",
        uid: widget.attendance?.userClient?.id.toString(),
        avatar: widget.attendance?.userClient?.pathImage,
      );
    });

    super.initState();
  }

  void systemMessage() {
    Timer(Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(Duration(milliseconds: 300), () {
        _chatViewKey.currentState.scrollController
          ..animateTo(
            _chatViewKey.currentState.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
      });
    });
  }

  void onSend(ChatMessage message, TextEditingController textController,
      Attendance attendance, ProfileBloc profileBloc, BuildContext context,
      {bool ignore: false}) async {
    if (textController.text != message.text || ignore) {
      Modular.get<FirebaseClientTecnoanjo>()
          .setCollectionMessage(attendance, message);
      textController.text = message.text;
      var progress;
      if (context != null) {
        progress = ProgressHUD.of(context);
        progress.showWithText('Enviando');
      }

      var _dateTime =  MyDateUtils.getTrueTime();
      var mydate =  MyDateUtils.convertDateToDate(_dateTime, _dateTime);
      profileBloc.sendMessage(message.text, attendance);
      print(message.toJson());
      var documentReference = Modular.get<AppBloc>()
          .firebaseReference()
          .collection('Messages')
          .doc("Attendance")
          .collection(attendance?.id.toString())
          .doc(mydate.millisecondsSinceEpoch.toString());
      FirebaseFirestore db = GetIt.I.get<FirebaseFirestore>();
      await db.runTransaction((transaction) async {
         transaction.set(
          documentReference,
          message.toJson(),
        );
        if (context != null) {
          progress.dismiss();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Chat",
            style: AppThemeUtils.normalSize(color: AppThemeUtils.whiteColor),
          ),
          centerTitle: true,
        ),
        body: ProgressHUD(
          child: StreamBuilder<QuerySnapshot>(
              stream: Modular.get<AppBloc>()
                  .firebaseReference()
                  .collection('Messages')
                  .doc("Attendance")
                  .collection(widget.attendance?.id.toString())
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                } else {
                  List<DocumentSnapshot> items = snapshot.data.docs;
                  var messages =
                      items.map((i) => ChatMessage.fromJson(i.data())).toList();
                  return DashChat(
                    key: _chatViewKey,
                    inverted: false,
                    onSend: (msg) => onSend(msg, textController,
                        widget.attendance, profileBloc, context),
                    sendOnEnter: true,
                    textInputAction: TextInputAction.send,
                    user: user,
                    // chatFooterBuilder: () {
                    //   return _chatField(widget.attendance);
                    // },
                    sendButtonBuilder: (sender) {
                      return Container(
                        padding: const EdgeInsets.all(15.0),
                        margin: EdgeInsets.only(right: 10, bottom: 8),
                        decoration: BoxDecoration(
                            color: AppThemeUtils.colorPrimary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 3),
                                  blurRadius: 5,
                                  color: Colors.grey)
                            ]),
                        child: InkWell(
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          onTap: sender,
                        ),
                      );
                      // return IconButton(
                      //   onPressed: sender,
                      //   icon: Icon(
                      //     Icons.send,
                      //     color: Color(0xff3E8DF3),
                      //   ),
                      // );
                    },
                    inputDecoration: InputDecoration.collapsed(
                        hintText: StringFile.adicioneAMessage),
                    dateFormat: DateFormat('dd-MMMM-yyyy', "pt_br"),
                    timeFormat: DateFormat('HH:mm'),
                    messages: messages,
                    showUserAvatar: false,
                    showAvatarForEveryMessage: false,
                    scrollToBottom: true,
                    onPressAvatar: (ChatUser user) {
                      print("OnPressAvatar: ${user.name}");
                    },
                    onLongPressAvatar: (ChatUser user) {
                      print("OnLongPressAvatar: ${user.name}");
                    },
                    inputMaxLines: 5,
                    messageContainerPadding:
                        EdgeInsets.only(left: 5.0, right: 5.0),
                    alwaysShowSend: true,
                    inputTextStyle: TextStyle(fontSize: 16.0),
                    inputContainerStyle: BoxDecoration(
                      border: Border.all(width: 0.0),
                      color: Colors.white,
                    ),
                    onQuickReply: (Reply reply) {
                      setState(() async {
                        var _dateTime =  MyDateUtils.getTrueTime();
                        var dateCreate =  MyDateUtils.convertDateToDate(
                            _dateTime, _dateTime);
                        messages.add(ChatMessage(
                            text: reply.value,
                            createdAt: dateCreate,
                            user: user));

                        messages = [...messages];
                      });

                      Timer(Duration(milliseconds: 300), () {
                        _chatViewKey.currentState.scrollController
                          ..animateTo(
                            _chatViewKey.currentState.scrollController.position
                                .maxScrollExtent,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 300),
                          );

                        if (i == 0) {
                          systemMessage();
                          Timer(Duration(milliseconds: 600), () {
                            systemMessage();
                          });
                        } else {
                          systemMessage();
                        }
                      });
                    },
                    onLoadEarlier: () {
                      print("laoding.");
                    },
                    shouldShowLoadEarlier: false,
                    showTraillingBeforeSend: true,
                    trailing: <Widget>[],
                  );
                }
              }),
        ));
  }
}

void onSend(ChatMessage message, TextEditingController textController,
    Attendance attendance, ProfileBloc profileBloc, BuildContext context,
    {bool ignore: false}) async {
  if (textController.text != message.text || ignore) {
    Modular.get<FirebaseClientTecnoanjo>()
        .setCollectionMessage(attendance, message);
    var progress;
    if (context != null) {
      progress = ProgressHUD.of(context);
      progress.showWithText('Enviando');
    }
    textController.text = message.text;
    var _dateTime =  MyDateUtils.getTrueTime();
    var mydate =  MyDateUtils.convertDateToDate(_dateTime, _dateTime);
    profileBloc.sendMessage(message.text, attendance);
    print(message.toJson());
    var documentReference = Modular.get<AppBloc>()
        .firebaseReference()
        .collection('Messages')
        .doc("Attendance")
        .collection(attendance?.id.toString())
        .doc(mydate.millisecondsSinceEpoch.toString());
    FirebaseFirestore db = GetIt.I.get<FirebaseFirestore>();
    await db.runTransaction((transaction) async {
       transaction.set(
        documentReference,
        message.toJson(),
      );
      if (context != null) {
        progress.dismiss();
      }
    });
  }
}

//
chatField(Attendance attendance, BuildContext context) {
  return InkWell(
      onTap: () {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPerspective(attendance)),
          );
        });
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(15.0),
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35.0),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 3),
                            blurRadius: 5,
                            color: Colors.grey)
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: "Fale com o cliente",alignLabelWithHint: true,
                              border: InputBorder.none,contentPadding: EdgeInsets.symmetric(vertical: 15),
                              suffixIcon: Icon(
                                Icons.send,
                                color: AppThemeUtils.colorPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(alignment: Alignment.bottomCenter,child:   StreamBuilder<int>(
              stream: Modular.get<ChatAttendanceBloc>().countQtdNotRead,
              builder: (context, snapshot) => (snapshot.data ?? 0) == 0
                  ? SizedBox()
                  :  Container(
                      margin: EdgeInsets.symmetric(horizontal:20.0,vertical: 25),

                      height: 45,
                      child: Container(
                          decoration: BoxDecoration(
                            color: AppThemeUtils.colorPrimary,
                            borderRadius: BorderRadius.circular(35.0),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 3),
                                  blurRadius: 5,
                                  color: Colors.grey)
                            ],
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextField(
                                  enabled: false,
                                  controller: TextEditingController(
                                    text:
                                        'Você tem ${(snapshot.data ?? 0)} mensagens',
                                  ),
                                  style: AppThemeUtils.smallSize(
                                      color: AppThemeUtils.whiteColor),
                                  decoration: InputDecoration(
                                    hintText:
                                        StringFile.adicioneAMessageToTecno,
                                    border: InputBorder.none,
                                    suffixIcon: Icon(
                                      Icons.send,
                                      color: AppThemeUtils.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                                ])))))





        ],
      ));
}
