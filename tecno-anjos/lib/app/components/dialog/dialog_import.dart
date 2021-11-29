// import 'package:flutter/material.dart';
//
// import 'package:tecnoanjostec/app/components/dialog/type_popup.dart';
// import 'package:tecnoanjostec/app/components/divider/line_view_widget.dart';
// import 'package:tecnoanjostec/app/modules/general/home/modules/qualifications/models/qualification.dart';
// import 'package:tecnoanjostec/app/utils/string/string_file.dart';
// import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
// import 'package:tecnoanjostec/app/utils/utils.dart';
//
// import '../build_plus_less_button.dart';
//
// var _isOpen = false;
// void showUpdateValues( Qualification qualification,
//     {Function positiveCallback,BuildContext context}) {
//   if (!_isOpen) {
//     TypePopup.show(context:context,
//       child: _DialogGeneric(
//             positiveCallback: positiveCallback, qualification: qualification));
//   } else {
//     _isOpen = true;
//   }
// }
//
// class _DialogGeneric extends StatefulWidget {
//   var controller = TextEditingController();
//
//   final Function positiveCallback;
//
//   final Qualification qualification;
//
//   _DialogGeneric({this.positiveCallback, this.qualification});
//
//   @override
//   __DialogGenericState createState() => __DialogGenericState();
// }
//
// class __DialogGenericState extends State<_DialogGeneric> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     widget.controller.text = widget.qualification.quantity.toString();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Center(
//       child: SingleChildScrollView(
//           child: Container(
//               width: MediaQuery.of(context).size.width > 450
//                   ? 400
//                   : MediaQuery.of(context).size.width * 0.8,
//               padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).viewInsets.bottom),
//               child: Material(
//                 color: Colors.white,
//                 child: ListBody(
//                   children: <Widget>[
//                     Container(
//                         color: AppThemeUtils.colorPrimary,
//                         padding: EdgeInsets.symmetric(horizontal: 20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Container(
//                               margin: EdgeInsets.only(top: 10, bottom: 0),
//                               child: Icon(
//                                 Icons.card_travel,
//                                 color: AppThemeUtils.whiteColor,
//                                 size: 35,
//                               ),
//                             ),
//                             Container(
//                                 margin: EdgeInsets.only(top: 10, bottom: 20),
//                                 child: Text(
//                                   "Alterar quantidade de itens",
//                                   style: AppThemeUtils.normalBoldSize(
//                                       color: AppThemeUtils.whiteColor,
//                                       fontSize: 18),
//                                 )),
//                           ],
//                         )),
//                     Container(
//                       padding: EdgeInsets.only(top: 10, bottom: 0),
//                       width: 200,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         border: Border.all(color: Colors.white, width: 1),
//                         shape: BoxShape.rectangle,
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Container(
//                               margin: EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 10),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     child: Text(
//                                       "VALOR UNITÁRIO",
//                                       style: AppThemeUtils.normalSize(
//                                           fontSize: 12),
//                                     ),
//                                   ),
//                                   Expanded(
//                                       child: Container(
//                                     child: Text(
//                                       Utils.moneyFormat(widget
//                                               .qualification.money ??
//                                           widget.qualification.currentValue ??
//                                           0),
//                                       textAlign: TextAlign.end,
//                                       style: AppThemeUtils.normalBoldSize(),
//                                     ),
//                                   ))
//                                 ],
//                               )),
//                           lineViewWidget(),
//                           Container(
//                               margin: EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 10),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     child: Text(
//                                       StringFile.TotalValue,
//                                       style: AppThemeUtils.normalSize(
//                                           fontSize: 12),
//                                     ),
//                                   ),
//                                   Expanded(
//                                       child: Container(
//                                     child: Text(
//                                       Utils.moneyFormat(
//                                           (widget.qualification.money ??
//                                                   widget.qualification
//                                                       .currentValue ??
//                                                   0) *
//                                               (int.tryParse(
//                                                       widget.controller.text) ??
//                                                   0)),
//                                       textAlign: TextAlign.end,
//                                       style: AppThemeUtils.normalBoldSize(),
//                                     ),
//                                   ))
//                                 ],
//                               )),
//                           lineViewWidget(bottom: 10),
//                           buildPlusLessButtom(context, (item) {
//                             widget.controller.text = item.toString();
//                             setState(() {});
//                           }),
//                           Container(
//                             width: 200,
//                             padding: EdgeInsets.all(10),
//                             child: Center(
//                               child: Row(
//                                 children: <Widget>[
//                                   Flexible(
//                                     child: Wrap(
//                                       children: <Widget>[
//                                         Text(
//                                           StringFile.oqdeseja,
//                                           textAlign: TextAlign.center,
//                                           style: AppThemeUtils.normalBoldSize(),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           lineViewWidget(),
//                           Container(
//                             padding: EdgeInsets.only(top: 5),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: <Widget>[
//                                 widget.positiveCallback == null
//                                     ? SizedBox()
//                                     : Container(
//                                         margin: EdgeInsets.only(
//                                             right: 10,
//                                             left: 10,
//                                             bottom: 10,
//                                             top: 5),
//                                         child: ElevatedButton(
//                                           color: AppThemeUtils.colorPrimary,
//                                           elevation: 0,
//                                           onPressed: () {
//                                             widget.positiveCallback(
//                                                 widget.controller.text);
//                                             Navigator.pop(context);
//                                           },
//                                           child: Text(
//                                             StringFile.salvar,
//                                             style: AppThemeUtils.normalBoldSize(
//                                               color: AppThemeUtils.whiteColor,
//                                             ),
//                                           ),
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(5))),
//                                         ),
//                                       ),
//                                 lineViewWidget(),
//                                 Container(
//                                   margin: EdgeInsets.only(
//                                       right: 10, left: 10, bottom: 10, top: 10),
//                                   child: ElevatedButton(
//                                     color: AppThemeUtils.colorError,
//                                     elevation: 0,
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: Text(
//                                       StringFile.Cancelar,
//                                       style: AppThemeUtils.normalBoldSize(
//                                         color: AppThemeUtils.whiteColor,
//                                       ),
//                                     ),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(5)),
//                                         side: BorderSide(
//                                             color: AppThemeUtils.colorError,
//                                             width: 1)),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ))),
//     );
//   }
// }
