import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../app_bloc.dart';
import 'models/chat_message.dart';
import 'models/chat_user.dart';

class ChatInputToolbar extends StatelessWidget {
  final TextEditingController controller;
  final TextStyle inputTextStyle;
  final InputDecoration inputDecoration;
  final TextCapitalization textCapitalization;
  final BoxDecoration inputContainerStyle;
  final List<Widget> leading;
  final List<Widget> trailling;
  final int inputMaxLines;
  final int maxInputLength;
  final bool alwaysShowSend;
  final ChatUser user;
  final Function(ChatMessage) onSend;
  final String text;
  final Function(String) onTextChange;
  final bool inputDisabled;
  final String Function() messageIdGenerator;
  final Widget Function(Function) sendButtonBuilder;
  final Widget Function() inputFooterBuilder;
  final bool showInputCursor;
  final double inputCursorWidth;
  final Color inputCursorColor;
  final ScrollController scrollController;
  final bool showTraillingBeforeSend;
  final FocusNode focusNode;
  final EdgeInsets inputToolbarPadding;
  final EdgeInsets inputToolbarMargin;
  final TextDirection textDirection;
  final bool sendOnEnter;
  final bool reverse;
  final TextInputAction textInputAction;

  ChatInputToolbar({
    Key key,
    this.textDirection = TextDirection.ltr,
    this.focusNode,
    this.scrollController,
    this.text,
    this.textInputAction,
    this.sendOnEnter = false,
    this.onTextChange,
    this.inputDisabled = false,
    this.controller,
    this.leading = const [],
    this.trailling = const [],
    this.inputDecoration,
    this.textCapitalization,
    this.inputTextStyle,
    this.inputContainerStyle,
    this.inputMaxLines = 1,
    this.showInputCursor = true,
    this.maxInputLength,
    this.inputCursorWidth = 2.0,
    this.inputCursorColor,
    this.onSend,
    this.reverse = false,
    @required this.user,
    this.alwaysShowSend = false,
    this.messageIdGenerator,
    this.inputFooterBuilder,
    this.sendButtonBuilder,
    this.showTraillingBeforeSend = true,
    this.inputToolbarPadding = const EdgeInsets.all(0.0),
    this.inputToolbarMargin = const EdgeInsets.all(0.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatMessage message = ChatMessage(
      text: text,
      user: user,
      messageIdGenerator: messageIdGenerator,
      createdAt: Modular.get<AppBloc>().dateNowWithSocket.stream.value,
    );

    return Container(
      padding: inputToolbarPadding,
      margin: inputToolbarMargin,
      decoration: BoxDecoration(color: Colors.transparent),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ...leading,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Directionality(
                    textDirection: textDirection,
                    child: Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        height: 61,
                        child: Row(children: [
                          Expanded(
                              child: Container(
                                  padding: EdgeInsets.all(15.0),
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
                                  child: Row(children: [
                                    // IconButton(
                                    //     icon: Icon(Icons.face), onPressed: () {}),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                        child: TextField(
                                      focusNode: focusNode,
                                      onChanged: (value) {
                                        onTextChange(value);
                                      },
                                      onSubmitted: (value) {
                                        if (sendOnEnter) {
                                          _sendMessage(context, message);
                                        }
                                      },
                                      textInputAction: textInputAction,
                                      buildCounter: (
                                        BuildContext context, {
                                        int currentLength,
                                        int maxLength,
                                        bool isFocused,
                                      }) =>
                                          null,
                                      decoration: inputDecoration != null
                                          ? inputDecoration
                                          : InputDecoration.collapsed(
                                              hintText: "",
                                              fillColor: Colors.white,
                                            ),
                                      textCapitalization: textCapitalization,
                                      controller: controller,
                                      style: inputTextStyle,
                                      maxLength: maxInputLength,
                                      minLines: 1,
                                      maxLines: inputMaxLines,
                                      showCursor: showInputCursor,
                                      cursorColor: inputCursorColor,
                                      cursorWidth: inputCursorWidth,
                                      enabled: !inputDisabled,
                                    ))
                                  ])))
                        ])),
                  ),
                ),
              ),
              if (showTraillingBeforeSend) ...trailling,
              if (sendButtonBuilder != null)
                sendButtonBuilder(() async {
                  if (text.length != 0) {
                    await onSend(message);

                    controller.text = "";

                    onTextChange("");
                  }
                })
              else
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: alwaysShowSend || text.length != 0
                      ? () => _sendMessage(context, message)
                      : null,
                ),
              if (!showTraillingBeforeSend) ...trailling,
            ],
          ),
          if (inputFooterBuilder != null) inputFooterBuilder()
        ],
      ),
    );
  }

  void _sendMessage(BuildContext context, ChatMessage message) async {
    if (text.length != 0) {
      await onSend(message);

      controller.text = "";

      onTextChange("");

    //  FocusScope.of(context).requestFocus(focusNode);

      Timer(Duration(milliseconds: 150), () {
        scrollController.animateTo(
          reverse ? 0.0 : scrollController.position.maxScrollExtent + 30.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      });
    }
  }
}
