import 'package:tecnoanjos_franquia/app/components/tectfields/custom_textfield.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:flutter/material.dart';

// Widget titleDescriptionCustomTextField(BuildContext context,
//     String title,{
//     TextEditingController controller,
//       bool obscure = false,
//       Function onTap,
//       ValueChanged<String> onChange,
//       TextInputType keyboard, InputDecoration decoration, Icon suffixIcon,
//     }) {
//
//   return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Container(
//             margin: EdgeInsets.symmetric(horizontal: 0),
//             padding: EdgeInsets.only(top: 5, bottom: 0),
//             child: Text(
//               title,
//               maxLines: 1,
//               style: AppThemeUtils.normalSize(color: AppThemeUtils.black),
//             )),
//         GestureDetector(
//             onTap: onTap,
//             child: Container(
//               margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
//
//               child: CustomTextField(
//                 controller: controller,
//                 obscureText: obscure,
//
//                 enabled: onTap == null,
//                 onChanged: onChange,
//                 keyboardType: keyboard,
//
//                     hintText: "", suffixIcon: suffixIcon,
//
//               ),
//             ))
//       ]);
// }