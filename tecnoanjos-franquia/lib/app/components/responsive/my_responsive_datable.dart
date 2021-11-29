import 'dart:math';

import 'package:tecnoanjos_franquia/app/components/tectfields/custom_textfield.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:rxdart/rxdart.dart';

import 'my_data_table_header.dart';





class MyResponsiveDatable extends StatefulWidget {
  final bool showSelect;
  final List<MyDatableHeader> headers;
  final List<Map<String, dynamic>> source;
  final List<Map<String, dynamic>> selecteds;
  final Widget title;
  final List<Widget> actions;
  final List<Widget> footers;
  final Function(bool value) onSelectAll;
  final Function(bool value, Map<String, dynamic> data) onSelect;
  final Function(dynamic value) onTabRow;
  final Function(dynamic value) onSort;
  final String sortColumn;
  final bool sortAscending;
  final bool isLoading;
  final bool autoHeight;
  final bool hideUnderline;
  final bool isBig;

  const MyResponsiveDatable({
    Key key,
    this.showSelect: false,
    this.onSelectAll,this.isBig :false,
    this.onSelect,
    this.onTabRow,
    this.onSort,
    this.headers,
    this.source,
    this.selecteds,
    this.title,
    this.actions,
    this.footers,
    this.sortColumn,
    this.sortAscending,
    this.isLoading: false,
    this.autoHeight: true,
    this.hideUnderline: true,
  }) : super(key: key);

  @override
  _MyResponsiveDatableState createState() => _MyResponsiveDatableState();
}

class _MyResponsiveDatableState extends State<MyResponsiveDatable> {
  Widget mobileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Checkbox(
            value: widget.selecteds.length == widget.source.length &&
                widget.source != null &&
                widget.source.length > 0,
            onChanged: (value) {
              if (widget.onSelectAll != null) widget.onSelectAll(value);
            }),
        PopupMenuButton(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Text("SORT BY"),
            ),
            tooltip: "SORT BY",
            initialValue: widget.sortColumn,
            itemBuilder: (_) => widget.headers
                .where(
                    (header) => header.show == true && header.sortable == true)
                .toList()
                .map((header) => PopupMenuItem(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "${header.text}",
                            textAlign: header.textAlign,
                          ),
                          if (widget.sortColumn != null &&
                              widget.sortColumn == header.value)
                            widget.sortAscending
                                ? Icon(Icons.arrow_downward, size: 15)
                                : Icon(Icons.arrow_upward, size: 15)
                        ],
                      ),
                      value: header.value,
                    ))
                .toList(),
            onSelected: (value) {
              if (widget.onSort != null) widget.onSort(value);
            })
      ],
    );
  }

  List<Widget> mobileList() {
    return widget.source.map((data) {
      return GestureDetector(
        onTap: widget.onTabRow != null
            ? () {
                widget.onTabRow(data);
              }
            : null,
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey[300], width: 1))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  if (widget.showSelect && widget.selecteds != null)
                    Checkbox(
                        value: widget.selecteds.indexOf(data) >= 0,
                        onChanged: (value) {
                          if (widget.onSelect != null)
                            widget.onSelect(value, data);
                        }),
                ],
              ),
              ...widget.headers
                  .where((header) => header.show == true)
                  .toList()
                  .map(
                    (header) => Container(
                      padding: EdgeInsets.all(11),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          header.headerBuilder != null
                              ? header.headerBuilder(header.value)
                              : Text(
                                  "${header.text}",
                                  overflow: TextOverflow.clip,
                                ),
                          Spacer(),
                          header.sourceBuilder != null
                              ? header.sourceBuilder(data[header.value], data)
                              : header.editable
                                  ? editAbleWidget(
                                      data: data,
                                      header: header,
                                      textAlign: TextAlign.end,
                                    )
                                  : Text("${data[header.value]}")
                        ],
                      ),
                    ),
                  )
                  .toList()
            ],
          ),
        ),
      );
    }).toList();
  }

  Alignment headerAlignSwitch(TextAlign textAlign) {
    switch (textAlign) {
      case TextAlign.center:
        return Alignment.center;
        break;
      case TextAlign.left:
        return Alignment.centerLeft;
        break;
      case TextAlign.right:
        return Alignment.centerRight;
        break;
      default:
        return Alignment.center;
    }
  }

  Widget desktopHeader() {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.grey[300], width: 1))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showSelect && widget.selecteds != null)
            Checkbox(
                value: widget.selecteds.length == widget.source.length &&
                    widget.source != null &&
                    widget.source.length > 0,
                onChanged: (value) {
                  if (widget.onSelectAll != null) widget.onSelectAll(value);
                }),
          ...widget.headers
              .where((header) => header.show == true)
              .map(
                (header) => Expanded(
                    flex: header.flex ?? 1,
                    child: GestureDetector(
                      onTap: () {
                        if (widget.onSort != null && header.sortable)
                          widget.onSort(header.value);
                      },
                      child: header.headerBuilder != null
                          ? header.headerBuilder(header.value)
                          : Container(
                              padding: EdgeInsets.all(11),
                              alignment: headerAlignSwitch(header.textAlign),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    "${header.text}",
                                    textAlign: header.textAlign,
                                  ),
                                  if (widget.sortColumn != null &&
                                      widget.sortColumn == header.value)
                                    widget.sortAscending
                                        ? Icon(Icons.arrow_downward, size: 15)
                                        : Icon(Icons.arrow_upward, size: 15)
                                ],
                              ),
                            ),
                    )),
              )
              .toList()
        ],
      ),
    );
  }

  List<Widget> desktopList() {
    List<Widget> widgets = [];
    for (var index = 0; index < widget.source.length; index++) {
      final data = widget.source[index];
      widgets.add(GestureDetector(
        onTap: widget.onTabRow != null
            ? () {
                widget.onTabRow(data);
              }
            : null,
        child: Container(
            padding: EdgeInsets.all(widget.showSelect ? 0 : 11),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey[300], width: 1))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.showSelect && widget.selecteds != null)
                  Checkbox(
                      value: widget.selecteds.indexOf(data) >= 0,
                      onChanged: (value) {
                        if (widget.onSelect != null)
                          widget.onSelect(value, data);
                      }),
                ...widget.headers
                    .where((header) => header.show == true)
                    .map(
                      (header) => Expanded(
                        flex: header.flex ?? 1,
                        child: header.sourceBuilder != null
                            ? header.sourceBuilder(data[header.value], data)
                            : header.editable
                                ? editAbleWidget(
                                    data: data,
                                    header: header,
                                    textAlign: header.textAlign,
                                  )
                                : Container(
                                    child: Text(
                                      "${data[header.value]}",
                                      textAlign: header.textAlign,
                                    ),
                                  ),
                      ),
                    )
                    .toList()
              ],
            )),
      ));
    }
    return widgets;
  }

  Widget editAbleWidget({
    @required Map<String, dynamic> data,
    @required MyDatableHeader header,
    TextAlign textAlign: TextAlign.center,
  }) {
    return Container(
      constraints: BoxConstraints(maxWidth: 150),
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(0),
      child: CustomTextField(
        controller: TextEditingController.fromValue(
          TextEditingValue(text: "${data[header.value]}"),
        ),
        onChanged: (newValue) => data[header.value] = newValue,
      ),
    );
  }

  var _controller = ScrollController();
  var scrollSizeSubject = BehaviorSubject<double>.seeded(0.0);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollSizeSubject.drain();
    if (_controller.hasClients)
    _controller.removeListener(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_controller.hasClients)
        if ((_controller.position.maxScrollExtent ?? 1) > 1) {
          scrollSizeSubject.sink.add((MediaQuery.of(context).size.height > 1000 ? 800 :
          MediaQuery.of(context).size.height) *
              400 /
              (_controller.position.maxScrollExtent ?? 1));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // >> Ref: https://www.w3schools.com/css/css_rwd_mediaqueries.asp
//   /* Extra small devices (phones, 600px and down) */
// @media only screen and (max-width: 600px) {...}

// /* Small devices (portrait tablets and large phones, 600px and up) */
// @media only screen and (min-width: 600px) {...}

// /* Medium devices (landscape tablets, 768px and up) */
// @media only screen and (min-width: 768px) {...}

// /* Large devices (laptops/desktops, 992px and up) */
// @media only screen and (min-width: 992px) {...}

// /* Extra large devices (large laptops and desktops, 1200px and up) */
// @media only screen and (min-width: 1200px) {...}

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(children: [
        Align(
            alignment: Alignment.centerRight,
            child: Container(
                width: 10,margin: EdgeInsets.only(top: widget.isBig ? 310 :80),
                color: Colors.grey[200],
                height: MediaQuery.of(context).size.height)),
        MediaQuery.of(context).size.width < 900
            ?
            /**
             * for small screen
             */
            Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //title and actions
                    if (widget.title != null || widget.actions != null)
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey[300]))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (widget.title != null) widget.title,
                            if (widget.actions != null) ...widget.actions
                          ],
                        ),
                      ),

                    if (widget.autoHeight)
                      Column(
                        children: [
                          if (widget.showSelect && widget.selecteds != null)
                            mobileHeader(),
                          if (widget.isLoading) LinearProgressIndicator(),
                          //mobileList
                          ...mobileList(),
                        ],
                      ),
                    if (!widget.autoHeight)
                      Expanded(
                        child: Container(
                          child: DraggableScrollbar(
                              heightScrollThumb: 50,
                              backgroundColor: AppThemeUtils.colorGrayLight,
                              scrollThumbBuilder: (
                                Color backgroundColor,
                                Animation<double> thumbAnimation,
                                Animation<double> labelAnimation,
                                double height, {
                                Text labelText,
                                BoxConstraints labelConstraints,
                              }) {
                                return StreamBuilder(
                                    stream: scrollSizeSubject,
                                    initialData: 0.0,
                                    builder: (context, snapshot) {

                                      return InkWell(
                                          onTap: () {},
                                          child: Container(
                                              height: snapshot.data,
                                              width: 10.0,
                                              color: backgroundColor));
                                    });
                              },
                              controller: _controller,
                              child: ListView(
                                key: ValueKey<int>(Random(DateTime.now().millisecondsSinceEpoch).nextInt(4294967296)),
                                cacheExtent: 0,
                                controller: _controller,
                                padding: EdgeInsets.only(
                                    right: 20, left: 20, bottom: 80, top: 20),
                                // itemCount: source.length,
                                children: [
                                  if (widget.showSelect &&
                                      widget.selecteds != null)
                                    mobileHeader(),
                                  if (widget.isLoading)
                                    LinearProgressIndicator(),
                                  //mobileList
                                  ...mobileList(),
                                ],
                              )),
                        ),
                      ),
                    //footer
                    if (widget.footers != null)
                      Container(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [...widget.footers],
                        ),
                      )
                  ],
                ),
              )
            /**
             * for large screen
             */
            : Container(
                child: Column(
                  children: [
                    //title and actions
                    if (widget.title != null || widget.actions != null)
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey[300]))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (widget.title != null) widget.title,
                            if (widget.actions != null) ...widget.actions
                          ],
                        ),
                      ),

                    //desktopHeader
                    if (widget.headers != null && widget.headers.isNotEmpty)
                      desktopHeader(),

                    if (widget.isLoading) LinearProgressIndicator(),

                    if (widget.autoHeight) Column(children: desktopList()),

                    if (!widget.autoHeight)
                      // desktopList
                      if (widget.source != null && widget.source.isNotEmpty)
                        Expanded(
                            child: Container(
                                child: DraggableScrollbar(
                                    heightScrollThumb: 50,
                                    backgroundColor:
                                        AppThemeUtils.colorGrayLight,
                                    scrollThumbBuilder: (
                                      Color backgroundColor,
                                      Animation<double> thumbAnimation,
                                      Animation<double> labelAnimation,
                                      double height, {
                                      Text labelText,
                                      BoxConstraints labelConstraints,
                                    }) {
                                      return StreamBuilder(
                                          stream: scrollSizeSubject,
                                          initialData: 0.0,
                                          builder: (context, snapshot) {

                                            return InkWell(
                                                onTap: () {},
                                                child: Container(
                                                    height: snapshot.data,
                                                    width: 10.0,
                                                    color: backgroundColor));
                                          });
                                    },
                                    // isAlwaysShown: true,
                                    controller: _controller,
                                    child: ListView(
                                        key: ValueKey<int>(Random(DateTime.now().millisecondsSinceEpoch).nextInt(4294967296)),
                                        cacheExtent: 0,
                                        controller: _controller,
                                        padding: EdgeInsets.only(
                                            right: 20,
                                            left: 20,
                                            bottom: 80,
                                            top: 20),
                                        children: desktopList())))),

                    //footer
                    if (widget.footers != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [...widget.footers],
                      )
                  ],
                ),
              ),
      ]);
    });
  }
}
