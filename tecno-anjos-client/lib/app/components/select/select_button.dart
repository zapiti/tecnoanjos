import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tecnoanjosclient/app/models/pairs.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class SelectButton extends StatefulWidget {
  final List<Pairs> title;
  final Function(Pairs) tapIndex;
  final int initialItem;
  final bool everyEnable;
  final Key key;
  final Key keys1;
  final Key keys2;
  SelectButton({
    this.key,
    this.title,
    this.keys1,this.keys2,
    this.initialItem,
    this.tapIndex,
    this.everyEnable = false,
  });

  @override
  _SelectButtonState createState() => _SelectButtonState();
}

class _SelectButtonState extends State<SelectButton>
    with SingleTickerProviderStateMixin {
  var index;

  @override
  void initState() {
    super.initState();
    if (!widget.everyEnable) {
      index = widget.initialItem;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.everyEnable) {
      setState(() {
        if (index != widget.initialItem) index = widget.initialItem;
      });
    }

    return KeyedSubtree(
        // key:  widget.key,
        child: Row(children: [
      Expanded(

          child: KeyedSubtree(
              // key:  (widget.keys ?? []).isEmpty ? null: widget.keys[e.key],
              child: Container(
                key: widget.keys1,
                  padding: EdgeInsets.all(5),
                  child: ElevatedButton(
                    //
                    style: ElevatedButton.styleFrom(
                        primary: index == 0
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            side: BorderSide(
                                color: index == 0
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).primaryColor,
                                width: 1))),
                    onPressed: () {
                      if (widget.tapIndex != null) {
                        setState(() {
                          if (0 == index && widget.everyEnable == false) {
                            index = null;
                            widget.tapIndex(null);
                          } else {
                            index = 0;
                            widget.tapIndex(widget.title[0]);
                          }
                        });
                      }
                    },
                    child: Container(
                      height: 45,
                      child: Center(
                        child: AutoSizeText(
                          widget.title[0].second,
                          maxLines: 1,
                          minFontSize: 12,
                          maxFontSize: 16,
                          textAlign: TextAlign.center,
                          style: AppThemeUtils.normalSize(
                            color: index == 0
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  )))),
      Expanded(
          child: KeyedSubtree(
              // key:  (widget.keys ?? []).isEmpty ? null: widget.keys[e.key],
              child: Container(
                  key: widget.keys2,
                  padding: EdgeInsets.all(5),
                  child: ElevatedButton(
                    //
                    style: ElevatedButton.styleFrom(
                        primary: index == 1
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            side: BorderSide(
                                color: index == 1
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).primaryColor,
                                width: 1))),
                    onPressed: () {
                      if (widget.tapIndex != null) {
                        setState(() {
                          if (1 == index && widget.everyEnable == false) {
                            index = null;
                            widget.tapIndex(null);
                          } else {
                            index = 1;
                            widget.tapIndex(widget.title[1]);
                          }
                        });
                      }
                    },
                    child: Container(
                      height: 45,
                      child: Center(
                        child: AutoSizeText(
                          widget.title[1].second,
                          maxLines: 1,
                          minFontSize: 12,
                          maxFontSize: 16,
                          textAlign: TextAlign.center,
                          style: AppThemeUtils.normalSize(
                            color: index == 1
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ))))
    ]));
  }
}
