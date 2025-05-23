import 'package:flutter/material.dart';

class MyDatableHeader {
  final String text;
  final String value;
  final bool sortable;
  final bool editable;
  bool show;
  final TextAlign textAlign;
  final int flex;
  final Widget Function(dynamic value) headerBuilder;
  final Widget Function(dynamic value, Map<String, dynamic> row) sourceBuilder;

  MyDatableHeader({
    this.text,
    this.textAlign: TextAlign.center,
    this.sortable,
    this.value,
    this.show: true,
    this.editable: false,
    this.flex,
    this.headerBuilder,
    this.sourceBuilder,
  });

  factory MyDatableHeader.fromMap(Map<String, dynamic> map) => MyDatableHeader(
    text: map['text'],
    value: map['value'],
    sortable: map['sortable'],
    show: map['show'],
    textAlign: map['textAlign'],
    flex: map['flex'],
    headerBuilder: map['headerBuilder'],
    sourceBuilder: map['sourceBuilder'],
  );
  Map<String, dynamic> toMap() => {
    "text": this.text,
    "value": this.value,
    "sortable": this.sortable,
    "show": this.show,
    "textAlign": this.textAlign,
    "flex": this.flex,
    "headerBuilder": this.headerBuilder,
    "sourceBuilder": this.sourceBuilder,
  };
}
