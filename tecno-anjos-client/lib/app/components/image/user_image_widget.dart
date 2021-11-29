import 'dart:convert';
import 'dart:io';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tecnoanjosclient/app/components/builder/builder_component.dart';

import 'package:tecnoanjosclient/app/models/pairs.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/profile_bloc.dart';


import 'package:tecnoanjosclient/app/utils/image/image_utils.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class UserImageWidget extends StatefulWidget {
  final double height;
  final double width;
  final bool isButton;
  final ValueChanged<Pairs> changeButton;

  final File image;

  UserImageWidget({
    this.height,
    this.width,
    this.isButton = false,
    this.changeButton,
    this.image,
  });

  @override
  _UserImageWidgetState createState() => _UserImageWidgetState();
}

class _UserImageWidgetState extends State<UserImageWidget> {
  var profileBloc = Modular.get<ProfileBloc>();

  File _images;
  Image _image;
  String _base64;

  final picker = ImagePicker();

  _onImageButtonPressed(ImageSource source, {bool singleImage = false}) async {
    var pickedFile;
    File photo2;
    try {
      if (!kIsWeb) {
        pickedFile = await ImagePicker.pickImage(
            source: source, maxWidth: 200, maxHeight: 200);

        photo2 = File(pickedFile.path);
      } else {
        Pairs image = await ImageUtils.pickImage();
        _image = image.first;
        _base64 = image.second;
      }
    } catch (e) {
      print(e);
    }

    if (photo2 != null) {
      File photo = await ImageCropper.cropImage(
          sourcePath: photo2.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cortar',
              toolbarColor: AppThemeUtils.colorPrimary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (photo != null) {
        final bytes = photo.readAsBytesSync();

        String img64 = base64Encode(bytes);
        salvarImage(img64, photo);
      }
    }
    if (_base64 != null) {
      salvarImage(_base64, null);
    }
  }

  void salvarImage(String img64, File photo) {
    profileBloc.saveUserImage(context, img64, sucess: (value) {
      profileBloc.userImage.sink.add("");
      profileBloc.getUserImage();
      setState(() {
        if (value) {
          _images = photo;
          if (widget.changeButton != null) {
            widget.changeButton(Pairs(true, photo));
          }
        } else {
          if (widget.changeButton != null) {
            widget.changeButton(Pairs(false, null));
          }
          _images = null;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _images = widget.image;
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
                  title: new Text(StringFile.camera),
                  onTap: () {
                    Navigator.of(context).pop();
                    _onImageButtonPressed(ImageSource.camera);
                  },
                ),
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text(StringFile.galeria),
                    onTap: () {
                      Navigator.of(context).pop();
                      _onImageButtonPressed(ImageSource.gallery,
                          singleImage: true);
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_album),
                  title: new Text(StringFile.album),
                  onTap: () {
                    Navigator.of(context).pop();
                    _onImageButtonPressed(ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isButton
        ? Container(
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(120.0),
                child: Container(
                    color: Colors.grey,
                    child: builderComponent<String>(
                        stream: profileBloc.userImage.stream,
                        enableLoad: false,
                        initCallData: () {

                        },
                        buildBodyFunc: (context, response) => Container(
                            width: response == null ? 0 : 120,
                            height: response == null ? 0 : 120,
                            child:Center(
                                child: response == null
                                    ? kIsWeb
                                    ? _image
                                    :_images == null ? SizedBox(): Image.file(
                                  _images,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.fill,
                                )
                                    : Image.network(
                                  response ?? "", fit: BoxFit.fill,

                                  width: 120,
                                  height: 120,
                                  //
                                  // placeholder: (context, url) =>
                                  //     new CircularProgressIndicator(),
                                  // errorWidget:
                                  //     (context, url, error) =>
                                  //         new Icon(
                                  //   Icons.person,
                                  //   size: 60,
                                  // ),
                                )))))),
            kIsWeb
                ? SizedBox()
                : InkWell(
                onTap: () {
                  _onImageButtonPressed(ImageSource.camera);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 45,
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),

                  child: Center(
                      child: Text(
                        StringFile.tirarFoto,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        topLeft: Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                )),
            InkWell(
                onTap: () {
                  _onImageButtonPressed(ImageSource.gallery,
                      singleImage: true);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 45,
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),

                  child: Center(
                      child: Text(
                        StringFile.escolhaUmaFoto,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                ))
          ],
        ))
        : Container(
        width: widget.width ?? 120,
        height: widget.height ?? 120,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
                color: Colors.grey[200],
                child: InkWell(
                    onTap: kIsWeb
                        ? null
                        : () {
                      _settingModalBottomSheet(context);
                    },
                    child: Stack(children: <Widget>[
                      _images == null
                          ? builderComponent<String>(
                          stream: profileBloc.userImage.stream,
                          enableLoad: false,
                          initCallData: () {
                            profileBloc.getUserImage();
                          },
                          buildBodyFunc: (context, response) => Center(
                              child: response == null
                                  ? Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                  ))
                                  : Image.network(
                                response ?? "", fit: BoxFit.fill,

                                width: 120,
                                height: 120,
                                //
                                // placeholder: (context, url) =>
                                //     new CircularProgressIndicator(),
                                // errorWidget:
                                //     (context, url, error) =>
                                //         new Icon(
                                //   Icons.person,
                                //   size: 60,
                                // ),
                              )))
                          : _images == null ? SizedBox(): Image.file(
                        _images,
                        width: 120,
                        height: 120,
                        fit: BoxFit.fill,
                      ),
                      kIsWeb
                          ? SizedBox()
                          : Align(
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
