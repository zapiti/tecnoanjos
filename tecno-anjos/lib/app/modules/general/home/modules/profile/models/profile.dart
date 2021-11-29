import 'package:tecnoanjostec/app/models/current_user.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';
import 'package:tecnoanjostec/app/utils/utils.dart';


class Level {
  int id;
  String tag;
  String description;
  double min;
  double max;

  Level({this.id, this.tag, this.description, this.min, this.max});

  factory Level.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return Level(
      id: null == (temp = map['id'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      tag: map['tag']?.toString(),
      description: map['description']?.toString(),
      min: null == (temp = map['min'])
          ? null
          : (temp is num ? temp.toDouble() : double.tryParse(temp)),
      max: null == (temp = map['max'])
          ? null
          : (temp is num ? temp.toDouble() : double.tryParse(temp)),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tag': tag,
      'description': description,
      'min': min,
      'max': max,
    };
  }
}

class Profile {
  int id;
  String name;
  Level level;

  int point;
  String telephone;
  String email;
  String address;
  String birthDate;
  String gender;
  String cpf;
  bool isOnline;
  String pathImage;
  bool isFirstLogin;
  bool inOnboard = false;
  String hoursWorked;
  String schedule;
  String avaliations;

  String confirmPass;

  String pass;

  String image;

  Profile(
      {this.id,
      this.name,
      this.level,

      this.point,
      this.telephone,
      this.email,
      this.address,
      this.birthDate,
      this.gender,
      this.cpf,
      this.isOnline,
      this.pathImage,
      this.isFirstLogin,
      this.inOnboard,
      this.hoursWorked,
      this.schedule,
      this.avaliations,
      this.confirmPass,
      this.pass,
      this.image});


  factory Profile.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return Profile(
      id: null == (temp = map['id'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      name: map['name']?.toString(),
      level: Level.fromMap(map['level']),
      point: null == (temp = map['point'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      telephone: map['telephone']?.toString(),
      email: map['email']?.toString(),
      address: map['address']?.toString(),
      birthDate: MyDateUtils.parseDateTimeFormat( map['birthDate'],null),
      gender: Utils.genderType(map['gender']?.toString()),
      cpf: map['cpf']?.toString(),
      isOnline: null == (temp = map['isOnline'])
          ? null
          : (temp is bool ? temp : bool.fromEnvironment(temp)),
      pathImage: map['pathImage']?.toString(),
      isFirstLogin: null == (temp = map['isFirstLogin'])
          ? null
          : (temp is bool ? temp : bool.fromEnvironment(temp)),
      inOnboard: null == (temp = map['inOnboard'])
          ? null
          : (temp is bool ? temp : bool.fromEnvironment(temp)),
      hoursWorked: map['hoursWorked']?.toString(),
      schedule: map['schedule']?.toString(),
      avaliations: double.tryParse( "${map['avaliations']  ?? 0.0}").toStringAsFixed(1),
      confirmPass: map['confirmPass']?.toString(),
      pass: map['pass']?.toString(),
      image: map['image']?.toString(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'level': level?.toMap(),

      'point': point,
      'cellPhone': telephone,
      'email': email,
      'address': address,
      'birthDate': birthDate,
      'gender': gender,
      'cpf': cpf,
      'isOnline': isOnline,
      'pathImage': pathImage,
      'isFirstLogin': isFirstLogin,
      'inOnboard': inOnboard,
      'hoursWorked': hoursWorked,
      'schedule': schedule,
      'avaliations': avaliations,
      'confirmPass': confirmPass,
      'pass': pass,
      'image': image,
    };
  }

  Map<String, dynamic> toNewFuncionary() {

    return {
      "cpf": this.cpf,
      "email": this.email,
      "level": "ANJO I",
      "levelInfo": "Anjo inicial",
      "name": this.name,
      "password": this.pass ?? "12345678",
      "point": 1,
      "role": CurrentUser.FUNCIONARY,
      "telephone": this.telephone,

    };
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
