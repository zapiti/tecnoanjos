

class SocketUtils {

  static String convertRoomToAttedance(dynamic value){
    try{
      print("SOCKETIO=> availableRoom chat => $value");
      return value["availableRoom"];
    }catch(e){
      return null;
    }


  }
}