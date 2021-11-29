import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/pendency.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/avaliation/models/avaliation.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/model/service_prod.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/model/my_address.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/payments/models/payment.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/models/profile.dart';

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
  Payment paymentMethod;
  List<Pendency> pendencies;

  List<Avaliation> avaliations;
  List<ServiceProd> attendanceItems;

  bool tecnoAvaliation;
  bool isFavorite;

  bool clientAvaliation;

  String popupStatus;
  String attendanceCode;

  Attendance(
      {this.id,
      this.description,
      this.hourAttendance,
      this.totalValue,
      this.tecnoNF,
      this.clientNF,
      this.fullAddress,
      this.status,
      this.technicianImage,
      this.pendencies,
      this.attendanceItems,
      this.clientImage,
      this.attendanceCode,
      this.createdAt,
      this.updatedAt,
      this.dateInit,
      this.dateEnd,
      this.address,
      this.userTecno,
      this.userClient,
      this.paymentMethod,
      this.popupStatus,
      //       this.pendencies,
      this.avaliations,
      // this.attendanceItems,
      this.isFavorite,
      this.tecnoAvaliation,
      this.clientAvaliation});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'hourAttendance': hourAttendance?.toString(),
      'totalValue': totalValue,
      'tecnoNF': tecnoNF,
      'clientNF': clientNF,
      'popupStatus': popupStatus,
      'fullAddress': fullAddress,
      'status': status,
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
      'serviceItems':
          attendanceItems?.map((map) => map?.toMap())?.toList() ?? [],
      'tecnoAvaliation': tecnoAvaliation,
      'isFavorite': isFavorite,
      'clientAvaliation': clientAvaliation,
      'attendanceCode': attendanceCode
    };
  }

  factory Attendance.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return Attendance(
        id: null == (temp = map['id'])
            ? null
            : (temp is num ? temp.toInt() : int.tryParse(temp)),
        description: map['description']?.toString(),
        attendanceCode: map['attendanceCode']?.toString(),
        hourAttendance: null == (temp = map['hourAttendance'])
            ? null
            : (temp is DateTime ? temp : DateTime.tryParse(temp)),
        totalValue: null == (temp = map['totalValue'])
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
        attendanceItems: null == (temp = map['serviceItems'])
            ? null
            : (temp is List
                ? temp.map((map) => ServiceProd.fromMap(map)).toList()
                : null),
        technicianImage: map['technicianImage']?.toString(),
        popupStatus: map['popupStatus']?.toString(),
        clientImage: map['clientImage']?.toString(),
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
        paymentMethod: map['card'] == null
            ? Payment(
                paymentMethodId: map['paymentMethodId'] ?? map['cardId'],
              )
            : Payment.fromMap(map['card']),
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
