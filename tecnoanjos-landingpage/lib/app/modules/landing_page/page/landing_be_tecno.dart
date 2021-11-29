// import 'package:flutter/material.dart';
// import 'package:flutter_modular/flutter_modular.dart';
//
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:tecno_anjos_landing/app/components/load_web_frame.dart';
// import 'package:tecno_anjos_landing/app/modules/landing_page/widget/navbar/navigation_drawer.dart';
// import 'package:tecno_anjos_landing/app/modules/landing_page/widget/navigation_bar/navigation_bar.dart';
//
// import '../landing_page_page.dart';
//
// class LandingBeTecno extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraint) { return  Scaffold(
//         drawer:
//         constraint.maxWidth <= 800
//             ? Modular.get<NavigationDrawer>()
//             : null,
//         body: Stack(
//             children: <Widget>[
//               headerLandingPage(context),
//               Column(children: [
//                 NavigationBar(),
//               Expanded(child:  loadWebView(
//                   url: "https://forms.gle/ZnAiZBC8GwTfDAjP8",
//                 ))
//               ],)
//             ])
//
//     );});
//     // return ResponsiveBuilder(
//     //     builder: (context, sizingInformation) => Scaffold(
//     //
//     //           backgroundColor: Colors.white,
//     //           body: Column(
//     //             children: [
//     //               NavigationBar(),
//     //               Expanded(
//     //                   child: loadWebView(
//     //                 url: "https://pub.dev/packages/flutter_webview_plugin",
//     //               ))
//     //             ],
//     //           ),
//     //         ));
//   }
// }
