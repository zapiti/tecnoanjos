import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:tecnoanjostec/app/components/external/chat_view.dart';
import 'package:tecnoanjostec/app/components/external/models/chat_message.dart';
import 'package:tecnoanjostec/app/components/external/models/chat_user.dart';
import 'package:tecnoanjostec/app/components/external/models/reply.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/call_heaven/model/heaven.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

import '../../../../../../app_bloc.dart';

class ChatPerspectiveHeaven extends StatelessWidget {
  final Heaven heaven;

  ChatPerspectiveHeaven(this.heaven);

  @override
  Widget build(BuildContext context) {
    return _MyChatPage(heaven);
  }
}

class _MyChatPage extends StatefulWidget {
  final Heaven heaven;

  _MyChatPage(this.heaven);

  @override
  _MyChatPageState createState() => _MyChatPageState();
}

class _MyChatPageState extends State<_MyChatPage> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  ChatUser user;

  ChatUser otherUser;

  List<ChatMessage> messages = List<ChatMessage>.from([]);
  var m = List<ChatMessage>.from([]);

  var i = 0;

  @override
  void initState() {
    user = ChatUser(
      name: widget.heaven.nameTecnoanjo,
      firstName: widget.heaven?.nameTecnoanjo == null
          ? ""
          : widget.heaven?.nameTecnoanjo?.split(" ")[0],
      lastName: "",
      uid: widget.heaven?.idTecnoanjo.toString(),
      avatar: widget.heaven.imageTecnoanjo,
    );
    otherUser = ChatUser(
      name: widget.heaven.nameAdmin,
      firstName: widget.heaven?.nameAdmin == null
          ? ""
          : widget.heaven?.nameAdmin?.split(" ")[0],
      lastName: "",
      uid: widget.heaven?.idAdmin.toString(),
      avatar: widget.heaven.imageAdmin,
    );
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

  void onSend(ChatMessage message) async {
    print(message.toJson());
    var dateNow =  MyDateUtils.getTrueTime();
    var documentReference = Modular.get<AppBloc>()
        .firebaseReference()
        .collection('Messages')
        .doc("Heaven")
        .collection(widget.heaven?.id.toString())
        .doc(MyDateUtils.convertDateToDate(dateNow, dateNow)
            .millisecondsSinceEpoch
            .toString());
    FirebaseFirestore db = GetIt.I.get<FirebaseFirestore>();
    await db.runTransaction((transaction) async {
       transaction.set(
        documentReference,
        message.toJson(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children:[
        Card(
        color: AppThemeUtils.colorPrimary,
        child:  Container(
        width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    child:Text("Aqui você fala com nossos atendentes da Tecnoanjos para ajudar no seu atendimento.\nComo podemos te ajudar?",
      style: AppThemeUtils.normalSize(color: Colors.white),))
        )   ,     
    Expanded(child:     StreamBuilder<QuerySnapshot>(
            stream: Modular.get<AppBloc>()
                .firebaseReference()
                .collection('Messages')
                .doc("Heaven")
                .collection(widget.heaven?.id.toString())
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
                  onSend: onSend,
                  sendOnEnter: true,
                  textInputAction: TextInputAction.send,
                  user: user,
                  sendButtonBuilder: (sender) {
                    return IconButton(
                      onPressed: sender,
                      icon: Icon(
                        Icons.send,
                        color: Color(0xff3E8DF3),
                      ),
                    );
                  },
                  inputDecoration: InputDecoration.collapsed(
                      hintText: StringFile.adicionaeMsg),
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
                  messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
                  alwaysShowSend: true,
                  inputTextStyle: TextStyle(fontSize: 16.0),
                  inputContainerStyle: BoxDecoration(
                    border: Border.all(width: 0.0),
                    color: Colors.white,
                  ),
                  onQuickReply: (Reply reply) {
                    setState(() {
                      var value  = MyDateUtils.getTrueTime();
                        messages.add(ChatMessage(
                            text: reply.value,
                            createdAt:
                            MyDateUtils.convertDateToDate(value, value),
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
                  trailing: <Widget>[
                  ],
                );
              }
            })),

      ])

    );
  }
}
