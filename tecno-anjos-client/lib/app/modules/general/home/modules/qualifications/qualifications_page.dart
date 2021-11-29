// import 'package:flutter/material.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:tecnoanjosclient/app/components/builder/builder_component.dart';
// import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
// import 'package:tecnoanjosclient/app/modules/home/modules/qualifications/qualifications_bloc.dart';
// import 'package:tecnoanjosclient/app/modules/home/modules/qualifications/widget/qualification_builder.dart';
//
// class QualificationsPage extends StatelessWidget {
//   var _qualificationBloc = Modular.get<QualificationsBloc>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Qualificações'),
//         ),
//         body: builderComponent<ResponsePaginated>(
//           stream: _qualificationBloc.listQualificationInfo.stream,
//           initCallData: () {
//             _qualificationBloc.getListQualification();
//           },
//           buildBodyFunc: QualificationBuilder().buildBodyTechnicalQualification,
//         ));
//   }
// }
