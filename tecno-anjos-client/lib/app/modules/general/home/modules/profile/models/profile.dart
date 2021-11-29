import 'package:tecnoanjosclient/app/utils/date_utils.dart';
import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

class Profile {
  int id;
  String name;
 // String level;
  String levelInfo;
  int point;
  String telephone;
  String email;
  String address;
  String birthDate;
  String gender;
  String cpf;
  String totalAttendances;
  String pathImage;
  bool isOnline;
  bool isFirstLogin;

  String hoursWorked;

  String schedule;
  String tagTechnician;
  String avaliations;

  Profile(
      {this.id,
      this.name,this.totalAttendances,
    //  this.level,
      this.levelInfo,
      this.point,
      this.telephone,
      this.email,
      this.address,
      this.birthDate,
      this.gender,
      this.cpf,
      this.isOnline,
      this.isFirstLogin,
      this.avaliations,
      this.schedule,
      this.hoursWorked,this.tagTechnician,
      this.pathImage});



  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalAttendances':totalAttendances,
      'name': name,
    //  'level': level,
      'levelInfo': levelInfo,
      'point': point,
      'cellPhone': telephone,
      'email': email,
      'address': address,
      'birthDate': birthDate,
      'gender': gender,
      'cpf': cpf,
      'pathImage': pathImage,
      'isOnline': isOnline,
      'isFirstLogin': isFirstLogin,
      'hoursWorked': hoursWorked,
      'schedule': schedule,
      'avaliations': avaliations,
      'tagTechnician':tagTechnician,
    };
  }

  factory Profile.fromMap(dynamic map) {
    if (null == map) return null;

    return Profile(
      id: map['id'] as int,
      name: map['name'] as String??"",
      totalAttendances : map['totalAttendances'] as String ,
    //  level: map['level'] as String,
      levelInfo: map['levelInfo'] as String,
      tagTechnician: map['tagTechnician'].toString(),
      point: map['point'] as int ?? 0,
      telephone: ObjectUtils.parseToInt(map['telephone']).toString(),
      email: map['email'] as String,
      address: map['address'] as String,
      birthDate: MyDateUtils.parseDateTimeFormat(map['birthDate'],null),
      gender: Utils.genderType(map['gender'] as String),
      cpf: map['cpf']?.toString(),
      isOnline: map['isOnline'] as bool,
      isFirstLogin: map['isFirstLogin'] as bool,
      avaliations: double.tryParse( "${map['avaliations']  ?? 0.0}").toStringAsFixed(1),
      schedule: map['schedule'] as String,
      hoursWorked: map['hoursWorked'].toString(),
      pathImage: map['pathImage'].toString(),

    );
  }

  static fromAttendanceClient(map) {
    if (null == map) return null;
    var temp;
    return Profile(
      id: null == (temp = map['userIdClient'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      name: map['clientName']?.toString(),
      pathImage: map['clientImage']?.toString(),
    );
  }

  static fromAttendanceTecno(map) {
    if (null == map) return null;
    var temp;
    return Profile(
      id: null == (temp = map['userIdTecno'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      name: map['technicianName']?.toString(),
      pathImage: map['technicianImage']?.toString(),
    );
  }
}
