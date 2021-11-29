

import 'package:tecnoanjos_franquia/app/modules/attendance/model/pendency.dart';
import 'package:tecnoanjos_franquia/app/modules/tecno/model/profile.dart';

import 'myaddress.dart';

class Attendance {
  int id;
  String description;
  DateTime hourAttendance;
  double totalValue;
  bool tecnoNF;
  bool clientNF;
  String fullAddress;
  String status;
  String technicianImage;
  String clientImage;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime dateInit;
  DateTime dateEnd;
  MyAddress address;
  Profile userTecno;
  Profile userClient;
  // Payment paymentMethod;
  List<Pendency> pendencies;
  // List<Avaliation> avaliations;
  bool tecnoAvaliation;
  bool isFavorite;
  bool clientAvaliation;
  String popupStatus;

  Attendance(
      {this.id,
        this.description,
        this.hourAttendance,
        this.totalValue,
        this.tecnoNF,
        this.clientNF,
        this.fullAddress,
        this.status,
        this.technicianImage,this.pendencies,
        this.clientImage,
        this.createdAt,
        this.updatedAt,
        this.dateInit,
        this.dateEnd,
        this.address,
        this.userTecno,
        this.userClient,
        // this.paymentMethod,
        // this.avaliations,
        this.isFavorite,
        this.tecnoAvaliation,this.popupStatus,
        this.clientAvaliation});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'hourAttendance': hourAttendance?.toString(),
      'totalValue': totalValue,
      'tecnoNF': tecnoNF,
      'clientNF': clientNF,
      'fullAddress': fullAddress,
      'status': status,
      'popupStatus':popupStatus,
      'technicianImage': technicianImage,
      'clientImage': clientImage,
      'createdAt': createdAt?.toString(),
      'updatedAt': updatedAt?.toString(),
      'dateInit': dateInit?.toString(),
      'dateEnd': dateEnd?.toString(),
      'address': address?.toMap(),
      'userTecno': userTecno?.toMap(),
      'userClient': userClient?.toMap(),

      'pendencies': pendencies?.map((map) => map?.toMap())?.toList() ?? [],
      // 'avaliations': avaliations?.map((map) => map?.toMap())?.toList() ?? [],
      'tecnoAvaliation': tecnoAvaliation,
      'isFavorite': isFavorite,
      'clientAvaliation': clientAvaliation,
    };
  }

  factory Attendance.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return Attendance(id: null == (temp = map['id']) ? null : (temp is num
        ? temp.toInt()
        : int.tryParse(temp)),
      description: map['description']?.toString(),
      hourAttendance: null == (temp = map['hourAttendance'])
          ? null
          : (temp is DateTime ? temp : DateTime.tryParse(temp)),
      totalValue:null ==(temp = map['totalValue']) ? null : (temp is num
          ? temp.toDouble()
          : double.tryParse(temp)),
      tecnoNF:null == (temp = map['tecnoNF']) ? null : (temp is bool ? temp : bool.fromEnvironment(temp)),
      clientNF:null == (temp = map['clientNF']) ? null : (temp is bool ? temp : bool.fromEnvironment(temp)),
      fullAddress:map['fullAddress']?.toString(),
      status:map['status']?.toString(),
      technicianImage:map['technicianImage']?.toString(),popupStatus:map['popupStatus']?.toString(),
      clientImage:map['clientImage']?.toString(),
      createdAt:null == (temp = map['createdAt']) ? null : (temp is DateTime ? temp : DateTime.tryParse(temp)),
      updatedAt:null == (temp = map['updatedAt']) ? null : (temp is DateTime ? temp : DateTime.tryParse(temp)),
      dateInit:null == (temp = map['dateInit']) ? null : (temp is DateTime ? temp : DateTime.tryParse(temp)),
      dateEnd:null == (temp = map['dateEnd']) ? null : (temp is DateTime ? temp : DateTime.tryParse(temp)),
      address:MyAddress.fromMap(map['address'] ),
      userTecno:Profile.fromMap(map['userTecno'] ),
      userClient:Profile.fromMap(map['userClient'] ),

      pendencies:null == (temp = map['pendencies']) ? [] : (temp is List ? temp.map((map)=>Pendency.fromMap(map )).toList() : []),
      // avaliations:null == (temp = map['avaliations']) ? [] : (temp is List ? temp.map((map)=>Avaliation.fromMap(map,false )).toList() : []),
      tecnoAvaliation:null == (temp = map['tecnoAvaliation']) ? null : (temp is bool ? temp : bool.fromEnvironment(temp)),
      isFavorite:null == (temp = map['isFavorite']) ? null : (temp is bool ? temp : bool.fromEnvironment(temp)),
      clientAvaliation:null == (temp = map['clientAvaliation']) ? null : (temp is bool ? temp : bool.fromEnvironment(temp))
    );
  }
}
