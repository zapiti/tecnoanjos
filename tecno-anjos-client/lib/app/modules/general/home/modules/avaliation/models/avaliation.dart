import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';

class Avaliation {
  int id;
  double rating;
  String description;
  String createdAt;
  String updatedAt;
  int userSenderId;
  int userReceiverId;
  String userNameSander;
  String userNameReceiver;
  String imageUrlSender;
  String imageUrlReceiver;
  bool isAttendance = false;
  bool isReceiver = true;
  int codAttendanceId;
  Attendance attendance;

  Avaliation(
      {this.id,
      this.rating,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.userSenderId,
      this.userReceiverId,
      this.userNameSander,
      this.userNameReceiver,
      this.imageUrlSender,
      this.isAttendance,
      this.attendance,
      this.imageUrlReceiver,this.isReceiver = true, this. codAttendanceId});

  factory Avaliation.fromMap(Map<String, dynamic> map,bool isReceiver) {
    return new Avaliation(
        id: map['id'] as int,
        rating: ObjectUtils.parseToDouble(map['rating']),
        description: map['description'] as String,
        createdAt: map['createdAt'] as String,
        updatedAt: map['updatedAt'] as String,
        userSenderId: map['userSenderId'] as int,
        userReceiverId: map['userReceiverId'] as int,
        userNameSander: map['userNameSander'] as String,
        userNameReceiver: map['userNameReceiver'] as String,
        imageUrlSender: map['imageUrlSender'] as String,
        imageUrlReceiver: map['ImageUrlReceiver'] as String,
        isAttendance: false,isReceiver: isReceiver);
  }

  factory Avaliation.fromAttendance(Map<String, dynamic> map) {
    Attendance attendance = Attendance.fromMap(map);
    if (attendance == null) return null;
    return new Avaliation(
        id: attendance?.id,isReceiver: true,
        isAttendance: true,userNameReceiver:
    attendance?.userTecno?.name ?? attendance?.userTecno?.name ?? "",
        imageUrlReceiver:
            attendance?.userTecno?.pathImage ?? attendance.technicianImage ?? "",
        attendance: attendance,
        description:
           StringFile.naoAvaliouAinda);
  }

  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "rating": rating,
      "userReceiver": {
        "id":userReceiverId
      }
    };
  }
}
