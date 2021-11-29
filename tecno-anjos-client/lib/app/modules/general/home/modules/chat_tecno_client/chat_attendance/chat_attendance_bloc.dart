import 'dart:async';

import 'package:tecnoanjosclient/app/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/utils/date_utils.dart';
import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';
import 'package:uuid/uuid.dart';

import 'core/chat_attendance_repository.dart';
import 'model/conversation.dart';

extension ListExtension<T> on List<T> {
  bool _containsElement(T e) {
    for (T element in this) {
      if (element.toString().compareTo(e.toString()) == 0) return true;
    }
    return false;
  }

  List<T> removeDuplicates() {
    List<T> tempList = [];

    this.forEach((element) {
      if (!tempList._containsElement(element)) tempList.add(element);
    });

    return tempList;
  }
}

class ChatAttendanceBloc extends Disposable {
  var conversation = BehaviorSubject<List<Conversation>>.seeded([]);
  var countQtdNotRead = BehaviorSubject<int>();
  final appBloc = Modular.get<AppBloc>();
  ScrollController scrollController = new ScrollController(initialScrollOffset: 0);
  var focusNode = new FocusNode();
  Timer timer;

  final _repository = Modular.get<ChatAttendanceRepository>();

  getChatschedule(BuildContext context, Attendance attendance, {bool notRemove = false}) {
    //   var result = await _repository.creatChat(
    //       appBloc.currentPersonSubject.stream.value ?? CurrentPerson());
    //
    //     appBloc.currentChatId.sink.add(result.content);
    //     _callChat(context);
    //     timer?.cancel();
    //     timer = Timer.periodic(
    //         Duration(seconds: 15), (Timer t) => _callChat(context));
    //   }
    // });


    if(attendance != null){
      _callChat(context, attendance, notRemove: notRemove);
    }
    // timer?.cancel();
    // timer = Timer.periodic(
    //     Duration(seconds: 15), (Timer t) => _callChat(context,attendance));
  }

  clearChat(Attendance attendance){
    _repository.setSelected(attendance);
  }


  _callChat(BuildContext context, Attendance attendance, {bool notRemove = false}) async {
    if(!notRemove){
      _repository.setSelected(attendance);
      countQtdNotRead.sink.add( 0);
    }

    _repository.getChatMessage(attendance,notRemove:notRemove).listen((resulted) {
      var resume =
          resulted.docs.map((e) => Conversation.fromMap(e.data())).toList();

      var listNotRead = resume
          .where((element) =>
      (element.readAt ?? "").isEmpty &&
              element.sender?.id == attendance.userTecno?.id)
          .toList();

      countQtdNotRead.sink.add(listNotRead.length ?? 0);

      final result = ResponsePaginated(content: resume);
      if (result.content is List) {
        var future = Future(() {});

        if (conversation.stream.value.length <= 0) {
          future = future.then((_) {
            return Future.delayed(Duration(milliseconds: 50), () {
              var conversations = result.content ?? [];
              if (conversations.isEmpty) {
                conversation.sink.add(List<Conversation>.from([]));
              }

              // conversations.sort((a, b) => MyDateUtils.compareTwoDates(
              //         MyDateUtils.convertDateToDate(a.send_at, null),
              //         MyDateUtils.convertDateToDate(b.send_at, null))
              //     ? 1
              //     : 0);
              // conversations.sort((a, b) => a.send_hr.compareTo(b.send_hr));
              var last = conversation.stream.value ?? [];
              List<Conversation> temp = [];
              temp.addAll(last);

              temp.addAll(conversations);
              List<Conversation> distinct =
                  ObjectUtils().removeDuplicates(temp);

              conversation.sink.add(distinct);
              scrollToBottom(context);
            });
          });
        } else {
          conversation.sink.add(result.content ?? []);
        }
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
        sender: attendance.userClient);

    conversations.add(conversa);
    var distinct = ObjectUtils().removeDuplicates(conversations);
    conversation.sink.add(distinct);
    scrollToBottom(context);
    var dateTime = await MyDateUtils.getTrueTime();
    conversa.sendHr =
        MyDateUtils.parseDateTimeFormat(dateTime, null, format: "HHmmss");
    conversa.sendAt = MyDateUtils.parseDateTimeFormat(dateTime, null,
        format: "dd/MM/yyyy HH:mm:ss");

    await _repository.sendMessage(conversa, attendance);
  }

  void scrollToBottom(BuildContext context) {
    if(scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 600), () {
        final bottomOffset = scrollController.position.maxScrollExtent;
        scrollController.animateTo(
          bottomOffset,
          duration: Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );

      });
    }
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    timer?.cancel();
    countQtdNotRead.drain();
    conversation.drain();
  }

  Future<void> reSend(
      BuildContext context, Conversation resent, Attendance attendance) async {
    var conversations = conversation.stream.value ?? [];

    var conversa = resent;

    conversations.add(conversa);
    var distinct = ObjectUtils().removeDuplicates(conversations);
    conversation.sink.add(distinct);
    scrollToBottom(context);
    var dateTime = await MyDateUtils.getTrueTime();
    conversa.sendHr =
        MyDateUtils.parseDateTimeFormat(dateTime, null, format: "HHmmss");
    conversa.sendAt = MyDateUtils.parseDateTimeFormat(dateTime, null,
        format: "dd/MM/yyyy HH:mm:ss");

    await _repository.sendMessage(conversa, attendance);
  }
}
