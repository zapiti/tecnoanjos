// import 'package:flutter/material.dart';
// import 'package:table_sticky_headers/table_sticky_headers.dart';
// import 'package:tecnoanjostec/app/components/builder/builder_component.dart';
// import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
// import 'package:tecnoanjostec/app/modules/general/home/modules/opening_hours/models/opening_hours.dart';
// import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
//
// class ThirdPageBuilder extends StatefulWidget {
//   final OpeningHours myHours;
//   final OpeningHours mySelectedHours;
//   final ValueChanged<OpeningHours> selectedHours;
//
//   ThirdPageBuilder({this.selectedHours, this.myHours,this.mySelectedHours});
//
//   @override
//   _ThirdPageBuilderState createState() => _ThirdPageBuilderState();
// }
//
// class _ThirdPageBuilderState extends State<ThirdPageBuilder> {
//   OpeningHours myData;
//
//   @override
//   void initState() {
//     super.initState();
// //    if(widget.myHours.isNotEmpty){
// //
// //      myData = widget.myHours.first;
// //    }else{
// //      myData = _makeData();
// //    }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(children: <Widget>[
//       Container(
//           margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//           child: Text(
//             'Quais horários e dias da semana você gostaria de atender?',
//             style: AppThemeUtils.normalBoldSize(fontSize: 22),
//           )),
//       Container(
//           margin: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
//           child: Text(
//             'Marque os dias e horários em que deseja trabalhar',
//             style: AppThemeUtils.normalBoldSize(fontSize: 16),
//           )),
//       Expanded(
//         child: ListView.builder(
//             shrinkWrap: true,
//             itemCount: (widget.myHours.daysOfWeek.length ?? 0),
//             itemBuilder: (context, index) {
//               return Container(
//                 child: Text(widget.myHours.daysOfWeek[index].name),
//               );
//             }),
//
//         // builderComponent<ResponsePaginated>(
//         //     stream: StreamData,
//         //     emptyMessage: empty,
//         //     initCallData: () => actionReload(0),
//         //     tryAgain: () {
//         //       actionReload(0);
//         //     },   columnsLength: widget.openingHours.dayOfWeek.length,
//         //     rowsLength: widget.openingHours.hoursOfWeek.length,
//         //     buildBodyFunc: (context, response) =>
//         //         builderInfinityListViewComponent(response,
//         //             callMoreElements: (page) {
//         //               actionReload(page);
//         //             },
//         //             buildBody: (content) =>
//         //                 attendanceItemListWidget(context, content, status))), ),
//       )
//     ]);
//   }
// }
