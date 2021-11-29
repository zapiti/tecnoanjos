// import 'package:flutter/material.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:tecnoanjostec/app/components/builder/builder_component.dart';
// import 'package:tecnoanjostec/app/components/image/image_with_bg_widget.dart';
// import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
// import 'package:tecnoanjostec/app/modules/general/home/modules/onboarding/widget/second/widget/second_page_builder.dart';
// import 'package:tecnoanjostec/app/modules/general/home/modules/qualifications/models/qualification.dart';
// import 'package:tecnoanjostec/app/modules/general/home/modules/qualifications/qualifications_bloc.dart';
// import 'package:tecnoanjostec/app/utils/image/image_path.dart';
// import 'package:tecnoanjostec/app/utils/object/object_utils.dart';
//
// class SecondPage extends StatefulWidget {
//   final ValueChanged<List<Qualification>> changeQualifications;
//   final ValueChanged<bool> changeButton;
//   List<Qualification> myQualifications;
//
//   SecondPage(
//       {this.changeButton, this.changeQualifications, this.myQualifications});
//
//   @override
//   _SecondPageState createState() => _SecondPageState();
// }
//
// class _SecondPageState extends State<SecondPage> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   var _qualificationBloc = Modular.get<QualificationsBloc>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(children: <Widget>[
//       imageWithBgWidget(context, ImagePath.imageTarget),
//       Expanded(
//           child: builderComponent<ResponsePaginated>(
//         stream: _qualificationBloc.listQualificationInfo.stream,
//         initCallData: () {
//           _qualificationBloc.getListQualification();
//         },
//         buildBodyFunc: (context, content) => SecondPageBuilder()
//             .buildBodyTechnicalQualification(
//                 context, content, widget.myQualifications, (listSelected) {
//           var enableButton = true;
//           if (listSelected.isEmpty) {
//             enableButton = false;
//           }
//           widget.changeButton(enableButton);
//           widget.changeQualifications(
//               ObjectUtils.parseToObjectList<Qualification>(listSelected));
//         }),
//       ))
//
// //      Container(
// //          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
// //          child: builderComponent<ResponsePaginated>(
// //            stream: QualificationBloc().listQualificationStream,
// //            buildBodyFunc: SecondBuilder.buildBodyTechnicalQualification,
// //          )),
//     ]);
//   }
// }
