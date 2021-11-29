import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjos_franquia/app/modules/attendance/core/attendance_repository.dart';
import 'package:tecnoanjos_franquia/app/modules/attendance/model/attendance.dart';
import 'package:tecnoanjos_franquia/app/utils/object/object_utils.dart';

class AttendanceBloc extends Disposable {
  //dispose will be called automatically by closing its streams

  final listAttendanceSubject = BehaviorSubject<List<Attendance>>();
  final _repository = AttendanceRepository();

 getListAttedance() async {
    var response = await _repository.getListAttedance();

    listAttendanceSubject.sink
        .add(ObjectUtils.parseToObjectList<Attendance>(response.content ?? []));


  }

  @override
  void dispose() {
    listAttendanceSubject.drain();
  }




  //dispose will be called automatically by closing its streams

}
