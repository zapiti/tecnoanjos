import 'package:flavor/flavor.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';


import '../../app_bloc.dart';

class MyWebSocket {
  static getMyWebSocketClock() {
    final appBloc = Modular.get<AppBloc>();
    final socketUrl = Flavor.I.getString(Keys.apiUrl);
    final socket = IO.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'reconnection': true,
      'upgrade': true
    });
    socket.onReconnecting((data) => print("onReconnecting $data"));
    socket.onConnect((data) => print("onConnect $data"));
    socket.onDisconnect((data) => print("onDisconnect $data"));
    socket.connect();
    socket.on('serverClock', (data) {
     // print("serverClock $data");
      var date = MyDateUtils.convertStringToDateTime(data);
      appBloc.dateNowWithSocket.sink.add(date);
    });
  }
}
