import 'dart:io';

import 'package:flutter/material.dart';

import '../../utils/image/image_path.dart';

class UserImageWidget extends StatefulWidget {
  final double height;
  final double width;
  UserImageWidget({this.height, this.width});
  @override
  _UserImageWidgetState createState() => _UserImageWidgetState();
}

class _UserImageWidgetState extends State<UserImageWidget> {
  File fileImage;
  //_onImageButtonPressed(ImageSource source, {bool singleImage = false}) async {
//    MultiMediaPicker.pickImages(source: source, singleImage: singleImage)
//        .then((imgs) {
//      Navigator.pop(context);
//      LoginBloc().alterImage(context, imgs).then((value) {
//        if (value) {
//          setState(() {
//            imageCache.clear();
//            fileImage = imgs.first;
//          });
//        }
//      });
//    });
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.camera_alt),
                  title: new Text('Câmera'),
                  onTap: () {
                    // _onImageButtonPressed(ImageSource.camera);
                  },
                ),
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Galeria'),
                    onTap: () {
                      // _onImageButtonPressed(ImageSource.gallery,singleImage: true);
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_album),
                  title: new Text('Album'),
                  onTap: () {
                    //  _onImageButtonPressed(ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width ?? 120,
        height: widget.height ?? 120,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
                color: Colors.grey,
                child: InkWell(
                    onTap: () {
                      _settingModalBottomSheet(context);
                    },
                    child: Stack(children: <Widget>[

//                  fileImage == null
//                      ? builderComponentFuture(
//                          buildBodyFunc: (token) {
//                            var header =
//                                ProviderService.getHeaderTokenSimple(token);
//                            var urlRequest = StartBloc().urlActual +
//                                LoginRepository.serviceImage;
//                            return Image.network(
//                              urlRequest,
//                              width: MediaQuery.of(context).size.width,
//                              height: 120,
//                              fit: BoxFit.fill,
//                              headers: header,
//                            );
//                          },
//                          future: LoginRepository.getTokenUser())
//                      : Image.file(
//                          fileImage,
//                          width: MediaQuery.of(context).size.width,
//                          height: 120,
//                          fit: BoxFit.fill,
//                        ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Opacity(
                              opacity: 0.7,
                              child: Container(
                                color: Colors.white,
                                width: 200,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                ),
                              ))),
                    ])))));
  }
}
