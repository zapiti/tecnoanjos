// import 'dart:convert';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:tecnoanjostec/app/utils/image/image_utils.dart';
//
//
// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ImagePickerPage(),
//     );
//   }
// }
//
// class ImagePickerPage extends StatefulWidget {
//   @override
//   _ImagePickerPageState createState() => _ImagePickerPageState();
// }
//
// class _ImagePickerPageState extends State<ImagePickerPage> {
//   Image image;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(image?.semanticLabel ?? ""),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.open_in_browser),
//         onPressed: () async {
//           final _image = await ImageUtils.pickImage();
//           setState(() {
//             image = _image;
//           });
//         },
//       ),
//       body: Center(child: image != null ? image : Text('No data...')),
//     );
//   }
// }