import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/call_heaven/repository/call_heaven_repository.dart';

class CallHeavenBloc extends Disposable {
  final roomSubject = BehaviorSubject<ResponsePaginated>();

  final _repository = Modular.get<CallHeavenRepository>();

  createSocketConnection(Attendance attendance) async {
    var myProtocol = await _repository.createMyProtocol(attendance?.id);
    roomSubject.sink.add(myProtocol);
  }

  @override
  void dispose() {
    roomSubject.sink.add(null);
    roomSubject.drain();
  }
}
