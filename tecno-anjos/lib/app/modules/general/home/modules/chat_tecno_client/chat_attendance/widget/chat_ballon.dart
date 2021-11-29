import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/chat_tecno_client/chat_attendance/chat_attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/chat_tecno_client/chat_attendance/model/conversation.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  return htmlText.replaceAll(exp, '');
}

class BubbleClient extends StatelessWidget {
  final conversationBloc = Modular.get<ChatAttendanceBloc>();
  final Conversation conversation;
  final Attendance attendance;

  BubbleClient({this.conversation, this.attendance});

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      padding: conversation.isMe
          ? EdgeInsets.only(left: 80)
          : EdgeInsets.only(right: 80),
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
              // Padding(
              //     padding: EdgeInsets.symmetric(horizontal: 10),
              //     child: Align(
              //       child: Text(
              //         conversation.sender?.name ?? "--",
              //         textAlign:
              //         conversation.isMe ? TextAlign.end : TextAlign.start,
              //         style: TextStyle(fontSize: 12),
              //       ),
              //       alignment: conversation.isMe
              //           ? Alignment.centerRight
              //           : Alignment.centerLeft,
              //     )),
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
                    RichText(
                        text: TextSpan(
                      text: "",
                      style: AppThemeUtils.normalSize(
                          color: Theme.of(context).textTheme.bodyText2.color,
                          fontSize: MediaQuery.of(context).size.height < 600
                              ? 16
                              : 18),
                      children: [
                        TextSpan(
                            text:   conversation.body,
                            style: AppThemeUtils.normalSize(
                                color:
                                conversation.isMe
                                    ? AppThemeUtils.whiteColor
                                    : AppThemeUtils.colorPrimary,
                                fontSize: 16)),
                        TextSpan(
                            text: "  " + (conversation.sendAt == null
                                ? "Falha ao enviar"
                                : MyDateUtils.parseDateTimeFormat(
                                    MyDateUtils.convertStringToDateTime(
                                        conversation.sendAt,
                                        format: "dd/MM/yyyy HH:mm"),
                                    null,
                                    format: "HH:mm")),
                            style: AppThemeUtils.normalSize(
                                color:
                                conversation.isMe
                                                ? AppThemeUtils.whiteColor
                                                : AppThemeUtils.black,
                                fontSize: 8)),
                        // WidgetSpan(
                        //   child:     Icon(
                        //     (conversation.readAt ?? "").isNotEmpty
                        //         ? Icons.done_all
                        //         : Icons.access_time,
                        //     size: 12,
                        //     color: (conversation.readAt ?? "").isNotEmpty
                        //         ?  AppThemeUtils.whiteColor
                        //         : AppThemeUtils.darkGrey,
                        //   ),
                        // ),
                      ],
                    ))
                    //   Container(
                    //     child: Row(children: [
                    //     Expanded(child:   Text(
                    //         conversation.body,
                    //         style: AppThemeUtils.normalSize(
                    //             color: conversation.isMe
                    //                 ? AppThemeUtils.whiteColor
                    //                 : AppThemeUtils.colorPrimary,
                    //             decoration: conversation.sendAt == null
                    //                 ? TextDecoration.lineThrough
                    //                 : TextDecoration.none),
                    //       )),
                    //
                    //   Container(
                    //   height: 12,
                    //   padding: EdgeInsets.symmetric(horizontal: 10),
                    //   child: Align(
                    //     child: Row(
                    //       mainAxisAlignment: conversation.isMe
                    //           ? MainAxisAlignment.end
                    //           : MainAxisAlignment.start,
                    //       crossAxisAlignment: conversation.isMe
                    //           ? CrossAxisAlignment.end
                    //           : CrossAxisAlignment.start,
                    //       children: [
                    //         conversation.sendAt != null
                    //             ? SizedBox()
                    //             : ElevatedButton(
                    //             onPressed: () {
                    //               conversationBloc.reSend(
                    //                   context, conversation, attendance);
                    //             },
                    //             child: Text(
                    //               "Reenviar",
                    //               style: AppThemeUtils.normalSize(
                    //                   fontSize: 12,
                    //                   color: AppThemeUtils.colorPrimary),
                    //             )),
                    //         Center(
                    //             child: Text(
                    //               conversation.sendAt == null
                    //                   ? "Falha ao enviar"
                    //                   : MyDateUtils.parseDateTimeFormat(
                    //                   MyDateUtils.convertStringToDateTime(
                    //                       conversation.sendAt,
                    //                       format: "dd/MM/yyyy HH:mm"),
                    //                   DateTime.now(),
                    //                   format: "HH:mm"),
                    //               textAlign:
                    //               conversation.isMe ? TextAlign.end : TextAlign.start,
                    //               style: AppThemeUtils.normalSize(
                    //                 fontSize: 9,color: conversation.isMe
                    //                   ? AppThemeUtils.whiteColor
                    //                   : AppThemeUtils.darkGrey
                    //               ),
                    //             )),
                    //         Center(
                    //             child: Icon(
                    //               (conversation.readAt ?? "").isNotEmpty
                    //                   ? Icons.done_all
                    //                   : Icons.access_time,
                    //               size: 8,
                    //               color: (conversation.readAt ?? "").isNotEmpty
                    //                   ?  AppThemeUtils.whiteColor
                    //                   : AppThemeUtils.darkGrey,
                    //             )),
                    //       ],
                    //     ),
                    //     alignment: conversation.isMe
                    //         ? Alignment.centerRight
                    //         : Alignment.centerLeft,
                    //   ))
                    // ],)
                    //   ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
