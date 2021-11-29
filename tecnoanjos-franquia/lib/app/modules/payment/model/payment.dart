
import 'package:tecnoanjos_franquia/app/modules/attendance/model/attendance.dart';
import 'package:tecnoanjos_franquia/app/modules/tecno/model/profile.dart';

class Payment {
  double totalToPay;
  int attendanceId;
  String status;
  String dateInit;
  String dateEnd;
  int userClientId;
  String  clientName;
  String techName;

  Payment({this.totalToPay, this.attendanceId, this.status, this.dateInit,
      this.dateEnd, this.userClientId, this.clientName, this.techName});

  Map<String, dynamic> toMap() {
    return {
      'totaltopay': totalToPay,
      'attendanceId': attendanceId,
      'status': status,
      'dateInit': dateInit,
      'dateEnd': dateEnd,
      'userClientId': userClientId,
      'clientName': clientName,
      'techName': techName,
    };
  }

  factory Payment.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return Payment(
      totalToPay: null == (temp = map['totalToPay'])
          ? null
          : (temp is num ? temp.toDouble() : double.tryParse(temp)),
      attendanceId: null == (temp = map['attendanceId'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      status: map['status']?.toString(),
      dateInit: map['dateInit']?.toString(),
      dateEnd: map['dateEnd']?.toString(),
      userClientId: null == (temp = map['userClientId'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      clientName: map['clientName']?.toString(),
      techName: map['techName']?.toString(),
    );
  }
}
