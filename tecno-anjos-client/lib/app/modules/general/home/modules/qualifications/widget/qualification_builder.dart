// import 'package:flutter/material.dart';
// import 'package:tecnoanjosclient/app/components/list/mult_select_chip.dart';
// import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
// import 'package:tecnoanjosclient/app/modules/home/modules/calling/model/calling.dart';
// import 'package:tecnoanjosclient/app/modules/home/modules/qualifications/models/qualification.dart';
// import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';
//
// class QualificationBuilder {
//   Widget buildBodyTechnicalQualification(
//       BuildContext context, ResponsePaginated responsePaginated,
//       {bool hideElemet = false, Function onSelectionChanged, Calling calling}) {
//     var listItens = [];
//     //
//     // if (responsePaginated.content is List) {
//     //   calling.items.forEach((point) {
//     //     var item = responsePaginated.content
//     //         .firstWhere((e) => e.name != e.name, orElse: () => null);
//     //     if (item == null) {
//     //       listItens.add(point);
//     //     }
//     //   });
//     //   if (listItens.length != 0) {
//     //     responsePaginated.content.addAll(listItens);
//     //   }
//     // }
//
//     return Container(
//         margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
//         child: MultiSelectChipQualifications<Qualification>(
//           ObjectUtils.parseToObjectList<Qualification>(
//               responsePaginated.content),
//           selectedChoices: calling.items ?? [],
//           onSelectionChanged: (selectedList) {
//             onSelectionChanged(selectedList);
//           },
//         ));
//   }
// }
