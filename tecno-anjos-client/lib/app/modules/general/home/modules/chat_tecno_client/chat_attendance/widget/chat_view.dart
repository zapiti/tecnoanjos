import 'package:grouped_list/grouped_list.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/chat_tecno_client/chat_attendance/model/conversation.dart';

import 'package:tecnoanjosclient/app/utils/date_utils.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../../../app_bloc.dart';
import '../chat_attendance_bloc.dart';
import 'chat_ballon.dart';

class ChatClienteView extends StatefulWidget {
  final Attendance attedance;

  ChatClienteView(this.attedance);

  @override
  _ChatClienteViewState createState() => _ChatClienteViewState();
}

class _ChatClienteViewState extends State<ChatClienteView> {
  var chatAttendanceBloc = Modular.get<ChatAttendanceBloc>();
  var controler = TextEditingController();

  bool onScrollBottom = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      chatAttendanceBloc.scrollToBottom(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
//      appBar: AppBar(
//        elevation: 0.4,
//        iconTheme: IconThemeData(color: Colors.black),
//        backgroundColor: Colors.red,
//        title: StreamBuilder(
//          stream: socketioChat.imageAttendance,
//            builder: (context,snapshot)=>Row(
//          children: <Widget>[
//            Container(
//              width: 40,
//              height: 40,
//              margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
//              child: CircleAvatar(
//                backgroundImage:snapshot.data == null ?Image.asset("teste").image :  NetworkImage(snapshot.data),
//                backgroundColor: Colors.grey[200],
//                minRadius: 30,
//              ),
//            ),
//            Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Text(
//                  widget.attendance.clientName.toString(),
//                  style: TextStyle(color: Colors.black),
//                ),
//                Text(
//                  'Está online agora',
//                  style: TextStyle(
//                    color: Colors.grey[400],
//                    fontSize: 12,
//                  ),
//                )
//              ],
//            )
//          ],
//        )),
//      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Container(
                  color: Colors.white,
                  child: StreamBuilder<List<Conversation>>(
                      stream: chatAttendanceBloc.conversation,
                      initialData: [],
                      builder: (context, snapshot) =>

                          GroupedListView(
                            elements: (snapshot.data ?? []),
                            groupBy: (element) =>
                            MyDateUtils.convertStringToDateTime(element.sendAt,
                                format: "dd/MM/yyyy HH") ??
                                Modular.get<AppBloc>().dateNowWithSocket.stream.value,
                            controller: chatAttendanceBloc.scrollController,
                            padding: EdgeInsets.only(bottom: 10),
                            groupSeparatorBuilder: _buildGroupSeparator,
                            itemBuilder: (context, element) =>
                                BubbleClient(conversation: element),
                            order: GroupedListOrder.ASC,
                          )))),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                offset: Offset(-2, 0),
                blurRadius: 5,
              ),
            ]),
            child: Row(
              children: <Widget>[
//                  IconButton(
//                    onPressed: () {
//                      socketioChat.socket?.disconnect();
//                      socketioChat.socket?.destroy();
//
//                      socketioChat.socket = null;
//                      socketioChat.createSocketConnection(  widget.attendance);
//                      socketioChat.socket.connect();
//                    },
//                    icon: Icon(
//                      Icons.sync,
//                      color: Color(0xff3E8DF3),
//                    ),
//                  ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                Expanded(
                  child: TextFormField(
                    focusNode: chatAttendanceBloc.focusNode,
                    keyboardType: TextInputType.text,
                    controller: controler,
                    onFieldSubmitted: (value) {
                      if (controler.text.length > 0) {
                        chatAttendanceBloc.sendMessage(
                            context, controler.text, widget.attedance);
                        controler.clear();
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      hintText: 'Digite a mensagem',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (controler.text.length > 0) {
                      chatAttendanceBloc.sendMessage(
                          context, controler.text, widget.attedance);
                      controler.clear();
                    }
                  },
                  icon: Icon(
                    Icons.send,
                    color: AppThemeUtils.colorPrimary,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGroupSeparator(dynamic groupByValue) {
    return Container(
        margin: EdgeInsets.all(15),
        child: Text(
          ("${MyDateUtils.parseDateTimeFormat(
              groupByValue,
              null,
              format: "EEEE")} às " + MyDateUtils.parseDateTimeFormat(
              groupByValue,
              null,
              format: "HH:00")
              + " horas").toUpperCase(),
          textAlign: TextAlign.center,
          maxLines: 1,
          style: AppThemeUtils.normalBoldSize(fontSize: 12),
        ));
  }
}
