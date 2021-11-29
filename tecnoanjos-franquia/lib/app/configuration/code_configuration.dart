
import 'package:flavor/flavor.dart';
import 'package:universal_html/html.dart' as html;

class CodeConfiguration {
  static final BASEURL = "base_url";
  static final PRODUCTION_SERVER = "PRODUCTION_SERVER";

  static final codeProtocol =  html.window.location.protocol;

  static final hostProtocol =   html.window.location.hostname;

  static final portProtocol = html.window.location.port;

  static String baseUrl()  {
    //  return "http://44.192.83.18:3000";
//  return "http://3.236.80.183";
    return Flavor.I.getString(Keys.apiUrl);
  }


  //http://36bee169a3d9.ngrok.io/
  static final isMockDevTest = false; //kReleaseMode ? false : true;
// static final tempPartner = "861";
//   static final tempContato= "1";
}
