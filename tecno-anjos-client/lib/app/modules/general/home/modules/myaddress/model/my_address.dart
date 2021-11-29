

import 'package:tecnoanjosclient/app/utils/utils.dart';

class MyAddress {
  int id;

  String myAddress;
  String num;
  String neighborhood;
  String postal;
  String latitude;
  String longitude;
  String complement;
  int codRegion;
  String nameRegion;
  String uf;
  bool isMain;
  String title;

  MyAddress(
      {this.id,
        this.myAddress,
        this.num,
        this.neighborhood,
        this.postal,
        this.latitude,
        this.longitude,
        this.complement,
        this.codRegion,
        this.nameRegion,this.uf,this.isMain,
        this.title});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'address': this.myAddress,
      'num': this.num,
      'neighborhood': this.neighborhood,
      'postal': Utils.removeMask(this.postal) ,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'complement': this.complement,
      'codRegion': this.codRegion,
      'nameRegion': this.nameRegion,
      'title': this.title,
      // 'isMain':this.isMain,
      'uf':(this.uf ?? "").length <= 2 ? Utils.listStates
          .firstWhere((element) => element.first == uf,orElse: ()=> null)?.second: (this.uf ?? "")
    };
  }

  factory MyAddress.fromMap(Map<String, dynamic> map) {
    if(map == null) return null;
    var temp;
    return new MyAddress(
      id: map['id'] as int,
      myAddress: map['address'] as String,
      uf: null == (map['uf']) ? (map['uf']?.toString() ?? null == (temp = map['city'])
          ? null
          : temp['state']['name']?.toString()):(map['uf']).toString() ,
      num: map['num'] as String,
      neighborhood: map['neighborhood'] as String,
      postal: map['postal'] as String,
      latitude: map['latitude'] as String,
      longitude: map['longitude'] as String,
      complement: map['complement'] as String,
      codRegion: map['cityId'] as int ?? null == (temp = map['city'])
          ? null
          : int.tryParse(temp['id']?.toString() ),
      nameRegion: map['nameRegion'] as String,
      title: map['title'] as String,
      isMain: map['isMain'] as bool ?? false,
    );
  }
}
