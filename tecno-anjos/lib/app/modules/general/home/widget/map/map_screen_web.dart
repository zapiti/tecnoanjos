import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import 'package:tecnoanjostec/app/components/load/load_elements.dart';
import 'package:tecnoanjostec/app/components/not_init_now/not_init_now.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/current_attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/start_called_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';

import 'package:tecnoanjostec/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjostec/app/utils/image/image_path.dart';
import 'package:tecnoanjostec/app/utils/location/location_utils.dart';
import 'package:tecnoanjostec/app/utils/object/object_utils.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

import 'map_screen_mobile.dart';

class MapScreenWeb extends StatefulWidget {
  final Attendance attendance;

  MapScreenWeb(this.attendance);

  @override
  _MapScreenWebState createState() => _MapScreenWebState();
}

class _MapScreenWebState extends State<MapScreenWeb> {
  double _originLatitude, _originLongitude;
  GoogleMapController mapController;
  var startCalledBloc = Modular.get<StartCalledBloc>();
  var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  // PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = 'AIzaSyB_5vTLi7TI9jNE2vWAoZE_jl0GL6NLhNI';

  var keyMap = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  initMarker(_destLatitude, _destLongitude) async {
    _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
        BitmapDescriptor.defaultMarkerWithHue(15));
    final Uint8List markerIcon =
    await getBytesFromAsset(ImagePath.imageAureula, 100);
    if (_destLatitude != null && _destLongitude != null) {
      _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
          BitmapDescriptor.fromBytes(markerIcon));
    }

    setState(() {
      if (_destLatitude != null && _destLongitude != null) {
        _getPolyline(_destLatitude, _destLongitude);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return    FutureBuilder(
        future: LocationUtils.getCoordenateWithAttendance(widget.attendance),
        builder: (context, location) {
          if (location.data != null) {
            _originLatitude =
                location?.data?.latitude ??
                    widget.attendance?.address?.latitude;
            _originLongitude = location?.data?.longitude ??
                widget.attendance?.address?.longitude;
          }
          var latitude;
          var longitude;
          return Stack(
            children: [
              location.data == null
                  ? loadElements(context)
                  : StreamBuilder<DocumentSnapshot>(
                  stream:
                  Modular.get<FirebaseClientTecnoanjo>().getDataMapSnapshot(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Container(
                        color: AppThemeUtils.colorError,
                        margin: EdgeInsets.only(top: 90),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: 86,
                        child: Center(
                            child: Text(
                              "Erro ao conectar-se com atendimento,\nContate nosso administrativo",
                              textAlign: TextAlign.center,
                              style: AppThemeUtils.normalBoldSize(
                                  color: Colors.white),
                            )),
                      );
                    } else {
                      if (snapshot.hasData) {
                        var coordenate = snapshot.data.data();
                        if (coordenate != null) {
                          latitude = ObjectUtils.parseToDouble(
                              coordenate[
                              FirebaseClientTecnoanjo.LATITUDE]);
                          longitude = ObjectUtils.parseToDouble(
                              coordenate[
                              FirebaseClientTecnoanjo.LONGITUDE]);
                          initMarker(latitude, longitude);
                        }
                      }

                      return Container(
                        color: Colors.white,

                      );
                    }
                  }),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    children: [
                      Container(

                          color: AppThemeUtils.colorPrimary,
                          padding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          child: Center(child: ConfirmationSlider(

                                foregroundColor: AppThemeUtils.colorPrimary,height: 60,backgroundColorEnd: AppThemeUtils.colorPrimaryClient,
                                width: MediaQuery.of(context).size.width > 400 ? 400 : MediaQuery.of(context).size.width - 50,

                                onConfirmation: () {
                                  currentBloc.patchStart(
                                      context, widget.attendance);
                                },
                                text:
                                  StringFile.iniciarAtendimento,

                                ),

                              )),
                      buildNotInitNow(context, widget.attendance, currentBloc),
                    ],
                  )),
            ],
          );
        });
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }


  _getPolyline(_destLatitude, _destLongitude) async {
    // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    //   googleAPiKey,
    //   PointLatLng(_originLatitude, _originLongitude),
    //   PointLatLng(_destLatitude, _destLongitude),
    //   travelMode: TravelMode.driving,
    // );
    // if (result.points.isNotEmpty) {
    //   result.points.forEach((PointLatLng point) {
    //     polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    //   });
    // }
    //
    // _addPolyLine();
  }
}
