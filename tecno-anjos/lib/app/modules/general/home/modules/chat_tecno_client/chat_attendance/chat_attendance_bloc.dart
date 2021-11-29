import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjostec/app/app_bloc.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';
import 'package:tecnoanjostec/app/utils/object/object_utils.dart';
import 'package:uuid/uuid.dart';
import 'core/chat_attendance_repository.dart';
import 'model/conversation.dart';



class ChatAttendanceBloc extends Disposable {
  var conversation = BehaviorSubject<List<Conversation>>.seeded([]);

  var appBloc = Modular.get<AppBloc>();
  ScrollController scrollController = new ScrollController(initialScrollOffset: 0);
  var focusNode = new FocusNode();
  var countQtdNotRead = BehaviorSubject<int>();

  final _repository = Modular.get<ChatAttendanceRepository>();

  getChatschedule(BuildContext context, Attendance attendance, {bool notRemove = false}) {


    if(attendance != null){
      _callChat(context, attendance, notRemove: notRemove);
    }

  }
  clearChat(Attendance attendance){
    _repository.setSelected(attendance);
  }


  _callChat(BuildContext context, Attendance attendance,{bool notRemove = false}) async {
    if(!notRemove){
      _repository.setSelected(attendance);
      countQtdNotRead.sink.add( 0);
    }
    _repository.getChatMessage(attendance,notRemove:notRemove).listen((resulted) {
      var resume =
          resulted.docs.map((e) => Conversation.fromMap(e.data())).toList();
      final result = ResponsePaginated(content: resume);
      if (result.content is List) {
        var future = Future(() {});
        var listNotRead = resume
            .where((element) =>
        (element.readAt ?? "").isEmpty &&
            element.sender?.id == attendance.userClient?.id)
            .toList();

        countQtdNotRead.sink.add(listNotRead.length ?? 0);
          future = future.then((_) {
            return Future.delayed(Duration(milliseconds: 50), () {
              var conversations = result.content ?? [];
              if(conversations.isEmpty){
                conversation.sink.add(List<Conversation>.from([]));
              }

              var last = conversation.stream.value ?? [];
              List<Conversation> temp = [];
              temp.addAll(last);
              temp.addAll(conversations);
              List<Conversation> distinct = ObjectUtils().removeDuplicates(temp);




              conversation.sink.add(distinct);

              scrollToBottom(context);
            });
          });

      }
      scrollToBottom(context);
    });
  }

  void sendMessage(
      BuildContext context, String text, Attendance attendance) async {
    var conversations = conversation.stream.value ?? [];

    var conversa = Conversation(
        id: Uuid().v4(),
        isMe: true,
        body: text,
        sendHr: "",
        sendAt: null,
        sender: attendance.userTecno);

    conversations.add(conversa);
    var distinct = ObjectUtils().removeDuplicates(conversations);
    conversation.sink.add(distinct);
    scrollToBottom(context);
    var dateTime =  MyDateUtils.getTrueTime();
    conversa.sendHr =
        MyDateUtils.parseDateTimeFormat(dateTime, null, format: "HHmmss");
    conversa.sendAt = MyDateUtils.parseDateTimeFormat(dateTime, null,
        format: "dd/MM/yyyy HH:mm:ss");

    await _repository.sendMessage(conversa, attendance);
  }

  void scrollToBottom(BuildContext context) {

    Future.delayed(Duration(milliseconds: 600), () {
      try{

      }catch(e){
        if(scrollController.hasClients){
          final bottomOffset = scrollController.position.maxScrollExtent;
          scrollController.animateTo(
            bottomOffset,
            duration: Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
          //  FocusScope.of(context).requestFocus(focusNode);
        }
      }


    });
  }
  Future<void> reSend(
      BuildContext context, Conversation resent, Attendance attendance) async {
    var conversations = conversation.stream.value ?? [];

    var index = conversations.indexOf(resent);
    conversations.removeAt(index);
    conversation.sink.add(conversations);

    Future.delayed(Duration(seconds: 1),(){


      var conversa = resent;

      conversations.add(conversa);
      var distinct = ObjectUtils().removeDuplicates(conversations);
      conversation.sink.add(distinct);
      scrollToBottom(context);
     var dateTime = MyDateUtils.getTrueTime();
        conversa.sendHr =
            MyDateUtils.parseDateTimeFormat(dateTime, null, format: "HHmmss");
        conversa.sendAt = MyDateUtils.parseDateTimeFormat(dateTime, null,
            format: "dd/MM/yyyy HH:mm:ss");

        _repository.sendMessage(conversa, attendance);


    });
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    countQtdNotRead.drain();
    conversation.drain();
  }


}
