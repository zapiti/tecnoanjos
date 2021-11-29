
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:tecnoanjostec/app/utils/object/object_utils.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationUtils {
  static void navigateTo(BuildContext context, double lat, double lng) async {
    try {
      showLoading(true);

      var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
      if (await canLaunch(uri.toString())) {
        showLoading(false);
        await launch(uri.toString());
      } else {
        var uri2 = Uri.parse("comgooglemapsurl://maps.google.com/?q=$lat,$lng");

        if (await canLaunch(uri2.toString())) {
          await launch(uri2.toString());
          showLoading(false);
        } else {


          var uri3 = Uri.parse("http://maps.google.com/maps?daddr=$lat,$lng");

          print(uri3);
          if (await canLaunch(uri3.toString())) {
            await launch(uri3.toString());
            showLoading(false);
          } else {
            showLoading(false);
            showGenericDialog(
                context: context,
                title: StringFile.Erro,
                description: "Não foi possivel abrir o gps",
                iconData: Icons.error_outline,
                positiveCallback: () {},
                positiveText: StringFile.OK);
          }
        }
      }
    } catch (e) {
      showLoading(false);

      showGenericDialog(
          context: context,
          title: StringFile.Erro,
          description: "Não foi possivel abrir o gps",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    }
  }

  static Future<Coordinates> getCoordenateWithAttendance(
      Attendance attendance) async {
    // if(attendance.address.latitude == null){
    var fullAddress ="${attendance.address.myAddress} ${attendance.address.num}, ${attendance.address.neighborhood}, ${attendance.address.nameRegion}";
    if (fullAddress == null) {
      return null;
    } else {
      try{
        List locations =
        await geo.locationFromAddress(fullAddress);
        //var addresses = await Geocoder.local.findAddressesFromQuery(fullAddress);
        //   await Geocoder.local.f(coordinates);
        if (locations.length == 0) {
          return null;
        } else {
          return Coordinates(locations.first.latitude, locations.first.longitude);
        }
      }catch(e){
        return Coordinates( ObjectUtils.parseToDouble( attendance.address.latitude ?? "0.0") ?? 0.0, ObjectUtils.parseToDouble( attendance.address.longitude  ?? "0.0") ?? 0.0);
      }

    }

    // }else{
    // return attendance.address.latitude;
    // }
  }
}
