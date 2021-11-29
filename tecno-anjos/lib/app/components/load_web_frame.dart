

import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/fake/fake_ui.dart'
    if (dart.library.html) 'package:tecnoanjostec/app/fake/real_ui.dart' as ui;
import 'package:universal_html/html.dart' as html;

Widget loadWebView({String url}) {
  Widget widget;

  try {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
        'hello-world-html',
            (int viewId) => html.IFrameElement()
          ..src = url
          ..style.border = 'none');

    widget = HtmlElementView(key: UniqueKey(), viewType: 'hello-world-html');
  } catch (e) {
    //  print(e);
    widget = null;
  }

  return widget;
}
