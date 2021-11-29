// import 'package:flutter/material.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:tecnoanjostec/app/components/builder/builder_component.dart';
// import 'package:tecnoanjostec/app/components/list/mult_select_chip.dart';
// import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
// import 'package:tecnoanjostec/app/modules/general/home/modules/qualifications/models/qualification.dart';
// import 'package:tecnoanjostec/app/modules/general/home/modules/qualifications/qualifications_bloc.dart';
// import 'package:tecnoanjostec/app/utils/object/object_utils.dart';
// import 'package:tecnoanjostec/app/utils/string/string_file.dart';
// import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
//
// class SecondPageBuilder {
//   var _qualificationBloc = Modular.get<QualificationsBloc>();
//   Widget buildBodyTechnicalQualification(
//       BuildContext context, ResponsePaginated responsePaginated,List<Qualification> listSelected,Function(dynamic) onSelectionChanged) {
//     return Column(children: <Widget>[
//       Expanded(
//           child: SingleChildScrollView(
//               child: Column(
//         children: <Widget>[
//           Container(
//               margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
//               child: Text(
//               StringFile.secondOnboard,
//                 style: AppThemeUtils.normalBoldSize(fontSize: 22),
//               )),
//           Container(
//               margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
//               child:MultiSelectChip<Qualification>(
//                ObjectUtils.parseToObjectList<Qualification>(responsePaginated.content) ,
//                       selectedChoices: listSelected,
//                       onSelectionChanged:onSelectionChanged,
//                     )),
//
//           SizedBox(
//             height: 30,
//           ),
//         ],
//       ))),
//
//
//
//     ]);
//   }
// }
