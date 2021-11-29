import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/chat_tecno_client/chat_attendance/model/conversation.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';


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
  var controller = TextEditingController();

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
      body: Column(
        children: <Widget>[
          Expanded(
              child: Container(
            color: Colors.white,
            child: StreamBuilder<List<Conversation>>(
                stream: chatAttendanceBloc.conversation,
                initialData: [],
                builder: (context, snapshot) => GroupedListView(
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
                    )),
          )),
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
                Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                Expanded(
                  child: TextFormField(
                    focusNode: chatAttendanceBloc.focusNode,
                    keyboardType: TextInputType.text,
                    controller: controller,
                    onFieldSubmitted: (value) {
                      if (controller.text.length > 0) {
                        chatAttendanceBloc.sendMessage(
                            context, controller.text, widget.attedance);
                        controller.clear();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Digite a mensagem',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (controller.text.length > 0) {
                      chatAttendanceBloc.sendMessage(
                          context, controller.text, widget.attedance);
                      controller.clear();
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
