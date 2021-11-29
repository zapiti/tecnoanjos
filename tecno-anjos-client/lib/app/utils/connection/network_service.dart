
import 'dart:async'; //For StreamController/Stream
class NetWorkService {

 static Future<bool> check() async {
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.mobile) {
    //   return true;
    // } else if (connectivityResult == ConnectivityResult.wifi) {
    //   return true;
    // }
    return true;
  }

}
