


import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/components/external/models/scroll_to_bottom_style.dart';


class ScrollToBottom extends StatelessWidget {
  final Function onScrollToBottomPress;
  final ScrollController scrollController;
  final bool inverted;
  final ScrollToBottomStyle scrollToBottomStyle;

  ScrollToBottom({
    this.onScrollToBottomPress,
    this.scrollController,
    this.inverted,
    this.scrollToBottomStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: scrollToBottomStyle.width,
      height: scrollToBottomStyle.height,
      child: RawMaterialButton(
        elevation: 5,
        fillColor: scrollToBottomStyle.backgroundColor ??
            Theme.of(context).primaryColor,
        shape: CircleBorder(),
        child: Icon(
          scrollToBottomStyle.icon ?? Icons.keyboard_arrow_down,
          color: scrollToBottomStyle.textColor ?? Colors.white,
        ),
        onPressed: () {
          if (onScrollToBottomPress != null) {
            onScrollToBottomPress();
          } else {
            scrollController.animateTo(
              inverted ? 0.0 : scrollController.position.maxScrollExtent + 25.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
      ),
    );
  }
}
