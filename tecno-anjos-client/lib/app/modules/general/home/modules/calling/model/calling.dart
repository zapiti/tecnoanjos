
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/model/service_prod.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/model/my_address.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/models/wallet.dart';

import 'package:tecnoanjosclient/app/utils/date_utils.dart';

class Calling {
  int id;

  //List<Qualification> items;
  DateTime hourAttendance;
  String description;
  String image;
  Wallet wallet;
  MyAddress myAddress;
  bool alter = false;
  DateTime dateInit;
  DateTime dateEnd;
  DateTime controllDate;
  bool clientNF;
  bool ignoreFavorite = false;
  int userIdClient;
  int userIdTecno;
  List<ServiceProd> serviceItems;

  String initHours = "-1";
  String initLocal = "-1";
  Calling(
      {

      //  this.items,
      this.hourAttendance,
      this.description,
      this.image,
      this.wallet,
      this.myAddress,
      this.alter,
      this.dateInit,
      this.dateEnd,
      this.userIdClient,
      this.userIdTecno,
      this.id});

  Map<String, dynamic> toMap() {
    return {
      //'items': this.items?.map((e) => e.toMap())?.toList(),
      'hourAttendance': MyDateUtils.converStringServer(this.hourAttendance, null),
      'description': this.description ?? "Sem descrição",
      'cardId': this.wallet?.pagarmeCardId,
      'id': this.id,
      'addressId': this.myAddress?.id,
      'dateInit': this.dateInit,
      'dateEnd': this.dateEnd, "ignoreFavorite": this.ignoreFavorite,
      'userIdClient': this.userIdClient,
      'userIdTecno': this.userIdTecno,

      'pendency': []
    };
  }

  Map<String, dynamic> toMapAttendance() {
    return {
      //   'QualificationAttendance': this.items.map((e) => e.toMap()).toList(),
      'hourAttendance': MyDateUtils.converStringServer(this.hourAttendance, null),
      'description': this.description,
      'id': this.id,
      'dateInit': this.dateInit,
      'dateEnd': this.dateEnd,
      'Address': this.myAddress?.toMap(),
      'userIdClient': this.userIdClient,
      'ignoreFavorite': this.ignoreFavorite,
      'userIdTecno': this.userIdTecno,
      'pendency': []
    };
  }

  factory Calling.fromMap(Attendance attendance) {
    return new Calling(
        id: attendance?.id,
        //    items: ActivityUtils.getItens(attendance),
        hourAttendance: attendance.hourAttendance,
        description: attendance.description,
        image: attendance.userClient?.pathImage,
        myAddress: attendance.address,
        dateInit: attendance.dateInit,
        wallet: Wallet.fromMapPayment(attendance.paymentMethod) ,
        dateEnd: attendance.dateEnd,
        userIdTecno: attendance?.userTecno?.id,
        userIdClient: attendance?.userClient?.id,
        alter: true);
  }

  static Calling fromMapSimple(dynamic map) {
    if (null == map) return null;
    var temp;
    return Calling(
      id: null == (temp = map['id'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      // items: null == (temp = map['items']) ? [] : (temp is List ? temp.map((
      //     map) => Qualification.fromMap(map)).toList() : []),
      hourAttendance: null == (temp = map['hourAttendance'])
          ? null
          : (temp is DateTime ? temp : MyDateUtils.convertDateToDate(temp, null)),
      description: map['description']?.toString(),
      image: map['image']?.toString(),
      myAddress: MyAddress?.fromMap(map['myAddress']),
      alter: null == (temp = map['alter'])
          ? null
          : (temp is bool ? temp : bool.fromEnvironment(temp)),
      dateInit: null == (temp = map['dateInit'])
          ? null
          : (temp is DateTime ? temp : MyDateUtils.convertDateToDate(temp, null)),
      dateEnd: null == (temp = map['dateEnd'])
          ? null
          : (temp is DateTime ? temp : MyDateUtils.convertDateToDate(temp, null)),
      userIdClient: null == (temp = map['userIdClient'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      userIdTecno: null == (temp = map['userIdTecno'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
    );
  }

  toMapCreate() {
    return {
      // 'items': this.items?.map((e) => e.toSimpleNewItem())?.toList(),
      'hourAttendance': MyDateUtils.converStringServer(this.hourAttendance, null),
      'description': this.description ?? "Sem descrição",
      'paymentMethodId': this.wallet?.pagarmeCardId ?? this.wallet.id,
      //  'id': this.id,
      "address": this.myAddress?.toMap(),
      'dateInit': this.dateInit, 'ignoreFavorite': this.ignoreFavorite,
      'dateEnd': this.dateEnd,
      "serviceItems": serviceItems.map((e) => e.id).toList(),
    };
  }

  static Calling fromMapOld(Attendance attendance) {
    return new Calling(
        id: attendance?.id,
        //    items: ActivityUtils.getItensOld(attendance),
        hourAttendance: attendance.hourAttendance,
        description: attendance.description,
        image: attendance.userClient?.pathImage,
        myAddress: attendance.address,
        dateInit: attendance.dateInit,
        dateEnd: attendance.dateEnd,
        userIdTecno: attendance.userTecno?.id,
        userIdClient: attendance.userClient?.id,
        alter: true);
  }
}
