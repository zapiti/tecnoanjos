
import 'package:geocoder/geocoder.dart';


import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';

import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';

import 'package:geocoding/geocoding.dart' as geo;

class LocationUtils {
//   static Future<Address> openLocation(BuildContext context) async {
//     try{
//       Location location = new Location();
//
//       bool _serviceEnabled;
//       PermissionStatus _permissionGranted;
//       LocationData _locationData;
//
//       _serviceEnabled = await location.serviceEnabled();
//       if (!_serviceEnabled) {
//         _serviceEnabled = await location.requestService();
//         if (!_serviceEnabled) {
//           return null;
//         }
//       }
//
//       _permissionGranted = await location.hasPermission();
//       if (_permissionGranted == PermissionStatus.denied) {
//         _permissionGranted = await location.requestPermission();
//         if (_permissionGranted != PermissionStatus.granted) {
//           return null;
//         }
//       }
//
//       _locationData = await location.getLocation();
//
//       final coordinates =
//       new Coordinates(_locationData.latitude, _locationData.longitude);
//       var addresses =
//       await Geocoder.local.findAddressesFromCoordinates(coordinates);
//       var address = addresses.first;
//       var localeName = "${address.addressLine ?? ""}";
//
//       return address;
//     }catch(e){
//       return null;
//     }
//
//
//
// //    location.onLocationChanged.listen((LocationData currentLocation) {
// //      print(currentLocation.longitude);
// //      print(currentLocation.latitude);
// //    });
//   }

  static Future<Coordinates> getCoordenateWithAttendance(
      Attendance attendance) async {
    // if(attendance.address.latitude == null){
    var fullAddress = "${attendance.address.myAddress} ${attendance.address
        .num}, ${attendance.address.neighborhood}, ${attendance.address
        .nameRegion}";
    if (fullAddress == null) {
      return null;
    } else {
      try {
        List locations =
        await geo.locationFromAddress(fullAddress);
        //var addresses = await Geocoder.local.findAddressesFromQuery(fullAddress);
        //   await Geocoder.local.f(coordinates);
        if (locations.length == 0) {
          return null;
        } else {
          return Coordinates(
              locations.first.latitude, locations.first.longitude);
        }
      } catch (e) {
        return Coordinates(
            ObjectUtils.parseToDouble(attendance.address.latitude ?? "0.0") ??
                0.0,
            ObjectUtils.parseToDouble(attendance.address.longitude ?? "0.0") ??
                0.0);
      }
    }
  }

    // }else{
    // return attendance.address.latitude;
    // }
}
