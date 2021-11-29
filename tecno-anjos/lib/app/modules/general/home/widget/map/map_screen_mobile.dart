import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tecnoanjostec/app/utils/image/image_path.dart';

class MapScreenMobile extends StatefulWidget {
  @override
  _MapScreenMobileState createState() => _MapScreenMobileState();
}

class _MapScreenMobileState extends State<MapScreenMobile> {
  GoogleMapController mapController;
  double _originLatitude = -18.9402339, _originLongitude = -48.3409575;
  double _destLatitude = -18.9297543, _destLongitude = -48.2933346;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  // PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = 'AIzaSyB_5vTLi7TI9jNE2vWAoZE_jl0GL6NLhNI';

  @override
  void initState() {
    super.initState();

// make sure to initialize before map loading

    initMarker();
  }

  initMarker() async {
    //var customIcon = await _createMarkerImageFromAsset(ImagePath.imageLocationArrow);

    final Uint8List markerIcon =
        await getBytesFromAsset(ImagePath.imageLocationArrow, 100);
    _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
        BitmapDescriptor.fromBytes(markerIcon));
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(30));

    setState(() {
      _getPolyline();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: GoogleMap(
        circles: Set.from([
          Circle(
              circleId: CircleId("myCircle"),
              radius: 500,
              center: LatLng(_originLatitude, _originLongitude),
              fillColor: Color.fromRGBO(0, 164, 213, 0.1),
              strokeColor: Color.fromRGBO(0, 164, 213, 0.1),
              onTap: () {
                print('circle pressed');
              })
        ]),
        initialCameraPosition: CameraPosition(
          target: LatLng(_originLatitude, _originLongitude),
          zoom: 15,
        ),
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: _onMapCreated,
        markers: Set<Marker>.of(markers.values),
        polylines: Set<Polyline>.of(polylines.values),
      )),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }



  _getPolyline() async {
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

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
      .buffer
      .asUint8List();
}
