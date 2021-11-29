import 'package:tecnoanjos_franquia/app/models/current_user.dart';
import 'package:tecnoanjos_franquia/app/models/myaddress.dart';
import 'package:tecnoanjos_franquia/app/utils/date_utils.dart';
import 'package:tecnoanjos_franquia/app/utils/utils.dart';

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
  List<MyAddress> address;
  String birthDate;
  String gender;
  String cpf;
  bool isOnline;
  bool onWorking;
  String pathImage;
  bool isFirstLogin;
  bool inOnboard = false;
  String hoursWorked;
  String schedule;
  String avaliations;
  String endShift;
  String startShift;

  String confirmPass;
  List<MyAddress> cityAttendance;

  String password;
  String franchiseId;
  String image;

  String fantasyName;

  String role;
  String status;

  static const blocked = "blocked";
  static const active = "active";
  static const INITDEFAULT = "0001";
  static const ENDDEFAULT = "2359";

  Profile(
      {this.id,
      this.name,
      this.level,
      this.point,this.startShift,this.endShift,
      this.telephone,
      this.email,
      this.address,
      this.birthDate,
      this.gender,
      this.cpf,
      this.isOnline,
      this.pathImage,
      this.isFirstLogin,
      this.cityAttendance,
      this.inOnboard,
      this.hoursWorked,
      this.schedule,
      this.avaliations,
      this.confirmPass,
      this.password,
      this.role,
      this.franchiseId,
      this.fantasyName,
      this.image,
      this.onWorking,
      this.status});

  Map<String, dynamic> toCreate() {
    return {
      "name": name,
      "cpf": Utils.removeMask(cpf),
      "telephone": Utils.removeMask(telephone),
      "email": email,
      "role": role,
      "password": password ?? "Code147@",
      "franchise": {"id": franchiseId},
      "address": address?.map((e) => e.toRegion())?.toList(),
      "gender": gender,
      "status": status,
      "birthDate": birthDate,
      "endShift":endShift ?? ENDDEFAULT,
      "startShift":startShift ?? INITDEFAULT,
    };
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
      "status": status,
      'isOnline': isOnline,
      'pathImage': pathImage,
      'isFirstLogin': isFirstLogin,
      'inOnboard': inOnboard,
      'hoursWorked': hoursWorked,
      'schedule': schedule,
      'avaliations': avaliations,
      'confirmPass': confirmPass,
      'pass': password,
      'onWorking': onWorking,
      'image': image,
      "endShift":endShift ?? ENDDEFAULT,
      "startShift":startShift ?? INITDEFAULT
    };
  }

  Map<String, dynamic> toNewFuncionary() {
    return {
      "cpf": this.cpf,
      "email": this.email,
      "level": "ANJO I",
      "levelInfo": "Anjo inicial",
      "status": status,
      "name": this.name,
      "password": this.password ?? "12345678",
      "point": 1,
      "role": CurrentUser.FUNCIONARY,
      "telephone": this.telephone,
      "onWorking": this.onWorking,
      "address": address.map((e) => e.toRegion()).toList(),
      "endShift":endShift ?? ENDDEFAULT,
      "startShift":startShift ?? INITDEFAULT,
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

  factory Profile.fromMap(dynamic map) {
 //    print( "===========");
 // print( map['onWorking']);
    // print( map['startShift']);
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
      status: map['status']?.toString(),
      // address:  MyAddress.fromMap(map['address']),
      birthDate: map['birthDate']?.toString(),
      gender: map['gender']?.toString(),
      cpf: map['cpf']?.toString(),
      isOnline: null == (temp = map['isOnline'])
          ? null
          : (temp is bool
              ? temp
              : (temp is num
                  ? 0 != temp.toInt()
                  : ('true' == temp.toString()))),
      onWorking: null == (temp = map['onWorking'])
          ? null
          : (temp is bool
              ? temp
              : (temp is num
                  ? 0 != temp.toInt()
                  : ('true' == temp.toString()))),
      pathImage: map['pathImage']?.toString(),
      isFirstLogin: null == (temp = map['isFirstLogin'])
          ? null
          : (temp is bool
              ? temp
              : (temp is num
                  ? 0 != temp.toInt()
                  : ('true' == temp.toString()))),
      inOnboard: null == (temp = map['inOnboard'])
          ? null
          : (temp is bool
              ? temp
              : (temp is num
                  ? 0 != temp.toInt()
                  : ('true' == temp.toString()))),
      hoursWorked: map['hoursWorked']?.toString(),
      schedule: map['schedule']?.toString(),
      avaliations: map['avaliations']?.toString(),
      confirmPass: map['confirmPass']?.toString(),
      cityAttendance: null == (temp = map['cityAttendance'])
          ? []
          : (temp is List
              ? temp.map((map) => MyAddress.fromMap(map)).toList()
              : []),
      password: map['password']?.toString(),
      franchiseId: map['franchiseId']?.toString(),
      image: map['image']?.toString(),
      fantasyName: map['fantasyName']?.toString(),
      role: map['role']?.toString(),
      endShift: map['endShift']?.toString(),
      startShift: map['startShift']?.toString(),
    );
  }

  toEdit() {
    return {
      "fields": {
        "name": name,
        "cpf": Utils.removeMask(cpf),
        "telephone": Utils.removeMask(telephone),
        "email": email,
        "address": address?.map((e) => e.toRegion())?.toList(),
        "gender": gender,
        "birthDate": birthDate,
        "endShift":endShift ?? ENDDEFAULT,
        "startShift":startShift ?? INITDEFAULT,
      }
    };
  }
}
