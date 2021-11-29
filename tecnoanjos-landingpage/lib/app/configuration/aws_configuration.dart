

class AwsConfiguration {
  static final PRODUCTION_SERVER = "PRODUCTION_SERVER";
  static final SOCKET_ATTENDANCE_PORT = "SOCKET_ATTENDANCE_PORT";

  static final pushApi = "e0c60413-361f-4f24-aa2e-eb01ad67c193";

  static var teamViewUrl = "https://tinyurl.com/y4qkxw6x";

  static Future<String> base_url() async {
    return "";
  }

  static final isMockDevTest = false;
  //
  // static Future<String> socketUrlAttendance(String baseUrl) async {
  //   var appBloc = Modular.get<AppBloc>();
  //   var loginBloc = Modular.get<LoginBloc>();
  //   var remoteConfig = await FirebaseUtils.setupRemoteConfig();
  //   var urlBase = remoteConfig?.getString(SOCKET_ATTENDANCE_PORT);
  //   var user = await appBloc.getCurrentUserFutureValue();
  //   var devUrl = SOCKET_ATTENDANCE_PORT +
  //       "_" +
  //       (loginBloc.controllerUser.text.isNotEmpty
  //               ? Utils.removeMask(loginBloc.controllerUser.text)
  //               : user?.telephone ?? user?.name ?? user?.id?.toString())
  //           .toString();
  //
  //   var webServer = await FirebaseUtils.getServerHomologSocketPortWeb(
  //       SOCKET_ATTENDANCE_PORT, devUrl);
  //
  //   var urlDev = (remoteConfig?.getString(devUrl) ?? "");
  //   var port = (kIsWeb
  //       ? (webServer)
  //       : (urlDev.isNotEmpty ? urlDev : webServer ?? urlBase));
  //   final finalUrl = "$baseUrl:$port";
  //   return finalUrl;
  // }

  static String URL_TO_CLIENTE =
      "https://play.google.com/apps/testing/br.com.awscode.tecnoanjos.cliente";

  static var URL_TO_FORM =
      'https://webforms.pipedrive.com/f/1AjUIufpccYzH8GsrvC57EB58AoEBC0FKdi7qidTNNrQiAqKSYg9rD4WjIBjLplcL'; //kReleaseMode ? false : true;
}
