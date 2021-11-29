import 'dart:convert';

import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/pendency.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/service_prod.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/avaliation/models/avaliation.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/payments/models/payment.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/models/profile.dart';
import 'address.dart';

class Attendance {
  int id;
  String description;
  DateTime hourAttendance;
  double totalValue;
  bool tecnoNF;
  bool clientNF;
  String fullAddress;
  String status;
  String attendanceCode;
  String technicianImage;
  String clientImage;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime dateInit;
  DateTime dateEnd;
  MyAddress address;
  Profile userTecno;
  Profile userClient;
  Payment paymentMethod;
  double splittedValue;
  List<Pendency> pendencies;
  List<Avaliation> avaliations;
  bool tecnoAvaliation;
  bool isFavorite;
  bool clientAvaliation;
  String popupStatus;
  List<ServiceProd> attendanceItems;

  Attendance(
      {this.id,
      this.description,
      this.hourAttendance,this.attendanceItems,
      this.totalValue,
      this.tecnoNF,
      this.clientNF,this.attendanceCode,
      this.fullAddress,
      this.status,
      this.technicianImage,
      this.pendencies,
      this.clientImage,
      this.createdAt,
      this.updatedAt,
      this.dateInit,
      this.dateEnd,
      this.address,
      this.userTecno,
      this.userClient,
      this.paymentMethod,
      this.avaliations,
      this.isFavorite,
      this.splittedValue,
      this.tecnoAvaliation,
      this.popupStatus,
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
      'splittedValue': splittedValue,
      'popupStatus': popupStatus,
      'technicianImage': technicianImage,
      'clientImage': clientImage,
      'createdAt': createdAt?.toString(),
      'updatedAt': updatedAt?.toString(),
      'dateInit': dateInit?.toString(),
      'dateEnd': dateEnd?.toString(),
      'address': address?.toMap(),
      'userTecno': userTecno?.toMap(),
      'userClient': userClient?.toMap(),
      'paymentMethod': paymentMethod?.toMap(),
      'pendencies': pendencies?.map((map) => map?.toMap())?.toList() ?? [],
      'avaliations': avaliations?.map((map) => map?.toMap())?.toList() ?? [],
      'serviceItems': attendanceItems?.map((map) => map?.toMap())?.toList() ?? [],
      'tecnoAvaliation': tecnoAvaliation,
      'isFavorite': isFavorite,
      'clientAvaliation': clientAvaliation,
    };
  }

  factory Attendance.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    jsonEncode(map);
   var list =   null == (temp = map['serviceItems'])
        ? null
        : (temp is List
        ? temp.map((map) => ServiceProd.fromMap(map)).toList()
        : null);

   if(list != null){
     list.removeWhere((e)=> e == null);
     if(list.isEmpty){
       list = null;
     }
   }

    return Attendance(
        id: null == (temp = map['id'])
            ? null
            : (temp is num ? temp.toInt() : int.tryParse(temp)),
        description: map['description']?.toString(),
        attendanceCode: map['attendanceCode']?.toString(),
        hourAttendance: null == (temp = map['hourAttendance'])
            ? null
            : (temp is DateTime ? temp : DateTime.tryParse(temp)),
        totalValue: null == (temp = map['splittedValue'])
            ? null
            : (temp is num ? temp.toDouble() : double.tryParse(temp)),
        tecnoNF: null == (temp = map['tecnoNF'])
            ? null
            : (temp is bool ? temp : bool.fromEnvironment(temp)) ?? false,
        clientNF: null == (temp = map['clientNF'])
            ? null
            : (temp is bool ? temp : bool.fromEnvironment(temp)) ?? false,
        fullAddress: map['fullAddress']?.toString(),
        status: map['status']?.toString(),
        technicianImage: map['technicianImage']?.toString(),
        popupStatus: map['popupStatus']?.toString(),
        clientImage: map['clientImage']?.toString(),
        attendanceItems:list,
        createdAt: null == (temp = map['createdAt'])
            ? null
            : (temp is DateTime ? temp : DateTime.tryParse(temp)),
        updatedAt: null == (temp = map['updatedAt'])
            ? null
            : (temp is DateTime ? temp : DateTime.tryParse(temp)),
        dateInit: null == (temp = map['dateInit'])
            ? null
            : (temp is DateTime ? temp : DateTime.tryParse(temp)),
        dateEnd: null == (temp = map['dateEnd'])
            ? null
            : (temp is DateTime ? temp : DateTime.tryParse(temp)),
        address: MyAddress.fromMap(map['address']),
        userTecno: Profile.fromMap(map['userTecno']),
        userClient: Profile.fromMap(map['userClient']),
        splittedValue: null == (temp = map['splittedValue'])
            ? null
            : (temp is num ? temp.toDouble() : double.tryParse(temp)),
        paymentMethod: Payment.fromMap(map['paymentMethod']),
        pendencies: null == (temp = map['pendencies'])
            ? []
            : (temp is List
                ? temp.map((map) => Pendency.fromMap(map)).toList()
                : []),
        avaliations: null == (temp = map['avaliations'])
            ? []
            : (temp is List
                ? temp.map((map) => Avaliation.fromMap(map, false)).toList()
                : []),
        tecnoAvaliation: null == (temp = map['tecnoAvaliation'])
            ? null
            : (temp is bool ? temp : bool.fromEnvironment(temp)),
        isFavorite: null == (temp = map['isFavorite'])
            ? null
            : (temp is bool ? temp : bool.fromEnvironment(temp)),
        clientAvaliation: null == (temp = map['clientAvaliation'])
            ? null
            : (temp is bool ? temp : bool.fromEnvironment(temp)));
  }
}
