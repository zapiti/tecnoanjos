// import 'package:flutter/material.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:tecnoanjostec/app/components/builder/builder_component.dart';
// import 'package:tecnoanjostec/app/components/divider/line_view_widget.dart';
// import 'package:tecnoanjostec/app/components/image/image_with_bg_widget.dart';
// import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
// import 'package:tecnoanjostec/app/modules/general/home/modules/onboarding/widget/third/widget/third_page_builder.dart';
// import 'package:tecnoanjostec/app/modules/general/home/modules/opening_hours/models/opening_hours.dart';
// import 'package:tecnoanjostec/app/modules/general/home/modules/opening_hours/opening_hours_bloc.dart';
// import 'package:tecnoanjostec/app/modules/general/home/modules/opening_hours/utils/opening_hours_utils.dart';
// import 'package:tecnoanjostec/app/utils/image/image_path.dart';
// import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
//
// class ThirdPage extends StatefulWidget {
//   final ValueChanged<List<OpeningHours>> changeHoursWorked;
//   final ValueChanged<bool> changeButton;
//   final VoidCallback actionNext;
//   final ValueChanged<bool> showButton;
//   final List<OpeningHours> myHours;
//
//   ThirdPage(
//       {this.myHours,
//       this.changeHoursWorked,
//       this.changeButton,
//       this.actionNext,
//       this.showButton});
//
//   @override
//   _ThirdPageState createState() => _ThirdPageState();
// }
//
// class _ThirdPageState extends State<ThirdPage> {
//   var seletedHoursLayout = false;
//   final _openingBloc = Modular.get<OpeningHoursBloc>();
//
//   @override
//   void initState() {

//     super.initState();
//
// //    SchedulerBinding.instance
// //        .addPostFrameCallback((_) => _settingModalBottomSheet(context));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return seletedHoursLayout
//         ? builderComponent<ResponsePaginated>(
//             stream: _openingBloc.listOpeningHoursStream,
//             initCallData: () {
//               _openingBloc.getListOpeningHours();
//             },
//             buildBodyFunc: (context, data) => ThirdPageBuilder(
//                 myHours: data.content, selectedHours: (selectedHours) {}),
//           )
//         : SingleChildScrollView(
//             child: Column(
//             children: [
//               imageWithBgWidget(
//                 context,
//                 ImagePath.imageCalendar,
//               ),
//               Container(
//                   margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//                   child: Text(
//                     'Quais horários e dias da semana você gostaria de atender?',
//                     style: AppThemeUtils.normalBoldSize(fontSize: 20),
//                   )),
//               Container(
//                   margin: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
//                   child: Text(
//                     'Marque os dias e horários em que deseja trabalhar',
//                     style: AppThemeUtils.normalBoldSize(fontSize: 16),
//                   )),
//               SizedBox(
//                 height: 10,
//               ),
//               lineViewWidget(),
//               _settingModalBottomSheet(context)
//             ],
//           ));
//   }
//
//   Widget _settingModalBottomSheet(context) {
// //    showModalBottomSheet(
// //        context: context,
// //        isDismissible: false,
// //        builder: (BuildContext bc) {
//     return Container(
//       child: new Wrap(
//         children: <Widget>[
//           new ListTile(
//             leading: Container(
//                 child: Image.asset(
//               ImagePath.imageCalendar,
//               width: 24,
//               height: 24,
//             )),
//             title: new Text(
//                 'Todos os dias e Horários inclusive, finais de semana'),
//             onTap: () {
//               widget.changeHoursWorked([OpeningHoursUtils.allHours()]);
//               widget.actionNext();
//             },
//           ),
//           lineViewWidget(),
//           new ListTile(
//             leading: Container(
//                 child: Image.asset(
//               ImagePath.imageCalendar,
//               width: 24,
//               height: 24,
//             )),
//             title:
//                 new Text('Todos os dias e Horários exceto, finais de semana'),
//             onTap: () {
//               widget.changeHoursWorked([OpeningHoursUtils.allHoursNotSat()]);
//               widget.actionNext();
//             },
//           ),
//           lineViewWidget(),
//           new ListTile(
//             leading: Container(
//                 child: Image.asset(
//               ImagePath.imageCalendar,
//               width: 24,
//               height: 24,
//             )),
//             title: new Text(
//                 'Todos os dias inclusive, finais de semana e Apenas Horários comerciais'),
//             onTap: () {
//               widget
//                   .changeHoursWorked([OpeningHoursUtils.allHoursCommercial()]);
//               widget.actionNext();
//               //        Navigator.of(context).pop();
//             },
//           ),
//           lineViewWidget(),
//           new ListTile(
//             leading: Container(
//                 child: Image.asset(
//               ImagePath.imageCalendar,
//               width: 24,
//               height: 24,
//             )),
//             title: new Text(
//                 'Todos os dias exceto,finais de semana e Apenas Horários comerciais'),
//             onTap: () {
//               widget.changeHoursWorked(
//                   [OpeningHoursUtils.comercialDaysHoursCommercial()]);
//               widget.actionNext();
//               //        Navigator.of(context).pop();
//             },
//           ),
//           lineViewWidget(),
//           new ListTile(
//             leading: Container(
//                 child: Image.asset(
//               ImagePath.imageCalendar,
//               width: 24,
//               height: 24,
//             )),
//             title: new Text('Personalizado'),
//             onTap: () {
//               //      Navigator.of(context).pop();
//               setState(() {
//                 seletedHoursLayout = true;
//                 widget.showButton(true);
//               });
//             },
//           ),
//         ],
//       ),
//     );
//     //   });
//   }
// }
